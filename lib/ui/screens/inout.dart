/*
  Exercise Screen file
  Created on March 30 2020 by Sophie(bolesalavb@gmail.com)
  Updated on July 24 2020 by Sophie(bolesalavb@gmail.com)
*/

import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onboarding_flow/models/settings.dart';
import 'package:onboarding_flow/models/exercise.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onboarding_flow/ui/screens/nascarresults.dart';
import 'package:onboarding_flow/ui/screens/settings_screen.dart';
import 'package:onboarding_flow/ui/screens/preview_screen.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:onboarding_flow/ui/widgets/custom_flat_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wakelock/wakelock.dart';
import '../../globals.dart' as globals;


class InOut extends StatefulWidget {
  final int id;
  final String name;
  final String image;

  InOut({this.id, this.name, this.image});

  @override
  _InOutState createState() => _InOutState();
}

class _InOutState extends State<InOut> {
  Timer _timer;
  PanelController _pc = new PanelController();
  var txt = TextEditingController();
  FocusNode myFocusNode;
  AudioPlayer advancedPlayer;
  CarouselSlider exerciseCarousel;
  final controller = PageController(viewportFraction: 0.8);
  
  bool _firstBuilding = true; //state related to first building
  int _current = 0; //state related to current exercise index
  List _exerciseData = [];  //All exercise data
  int _time = -1;  //state related to timer
  String _exerciseComment = '';  //state related to exercise comment
  bool _playState = true; //state related to playing
  String _stageState = "rest"; //state related to stage
  bool _nightMode = false;//day mode or night mode
  List _workout = []; // exercise List(name, rep, time)

  // final settings = Settings(
  //   sound: globals.sound,
  //   voice: globals.voice,
  //   nightTheme: globals.nightTheme,
  // );

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  /*
    Future<void> _repeatExerciseDialog() async
    Author: Sophie(bolesalavb@gmail.com)
    Created Date & Time: July 24 2020 5:15 AM

    Future<void>: _repeatExerciseDialog

    Description: 'Repeat Exercise' Dialog
  */
  Future<void> _repeatExerciseDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          // backgroundColor: Colors.white,
          title: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Text('Repeat Exercise?'),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Text('Are you sure?',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('No'),
              onPressed: () {
                startTimer();
                setState(() {
                  _playState = true;
                });
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                // _timer.cancel();
                storeExerciseTimeRep(0, true);
                setState(() {
                  _playState = true;
                });
                exerciseRest(_current, false);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /*
    Future<void> _endWorkoutDialog() async
    Author: Sophie(bolesalavb@gmail.com)
    Created Date & Time: June 7 2020 10:48 PM
    Updated Date & Time: July 24 2020 4:41 AM

    Future<void>: _endWorkoutDialog

    Description: 'End Workout' Dialog
  */
  Future<void> _endWorkoutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          // backgroundColor: Colors.white,
          title: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Text('End Workout?'),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Text('Going back will restart the timer. Are you sure to you want to do this?',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).popUntil(ModalRoute.withName('/main'));
              },
            ),
            FlatButton(
              child: Text('No'),
              onPressed: () {
                startTimer();
                setState(() {
                  _playState = true;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /* 
    void playMusic(String title, String method)
    Author: Sophie
    Created Date & Time:  Mar 31 2020 10:23PM

    Function: playMusic

    Description:  Sound or Voice is played.

    Parameters: title(String) - title of Sound or Voice
                method(String)  - type of Music(Sound or Voice)
  */
  void playMusic(String title, String method) {
    Future loadMusic() async {
      advancedPlayer = await AudioCache().play("music/" + title + ".mp3");
    }

    if (method == "sound") {
      if (globals.sound) {
        loadMusic();
      }
    }

    if (method == "voice") {
      if (globals.voice) {
        loadMusic();
      }
    }
  }

  /*
    void playListVoice(List list)
    Author: Sophie
    Created Date & Time:  Mar 31 2020 10:31PM

    Function: playListVoice

    Description:  Voices of list are played at the same time.

    Parameters: list(List)  - Voice title list  
  */
  void playListVoice(List list) {
    if (list != null) {
      for (var i = 0; i < list.length; i++) {
        playMusic(list[i], "voice");
      }
    }
  }

  /* 
    fetchData() async
    Author: Sophie
    Created Date & Time: March 31 2020 12:11 AM
    Updated Date & Time: June 9 2020 6:49 PM

    Function: fetchData

    Description:  Using this function, Data related to 'Exercise 1' can be gotten from firebase. 
  */
  fetchData() async {
    Firestore.instance.collection('exercise' + widget.id.toString()).orderBy('no').snapshots().listen((data) => {
      data.documents.forEach((doc) => _exerciseData.add(doc)),
      setState(() {
        _exerciseData = _exerciseData;
        // _workout = new List(_exerciseData.length);
      }),
    });
  }

  /*
    exerciseRest(index, normal)
    Author: Sophie
    Created Date & Time:  March 31 2020 5:12AM

    Function: exerciseRest

    Description:  Rest stage of every exercise step is carried out by this function

    Parameters: index(int)  - index of current exercise step
                normal(bool)  - Normal rest or rest due to press button
  */
  exerciseRest(index, normal) {
    if (index == 0) {
      setState(() {
        _time = 10;
        _exerciseComment = "";
        _stageState = 'rest';
      });
    } else {
      // if (normal) {
        setState(() {
          _time = int.parse(_exerciseData[index - 1]['restTime']);
          _exerciseComment = "Rest";
          _stageState = 'rest';
        });
      // } else {
      //   setState(() {
      //     _time = int.parse(_exerciseData[index - 1]['restTime']);
      //     // _time = 10;
      //     _exerciseComment = "Rest";
      //     _stageState = 'rest';
      //   });
      // }
    }
    if (!_firstBuilding) {
      exerciseCarousel.animateToPage(_current,
        duration: Duration(milliseconds: 1500),
        curve: Curves.linear);
      controller.animateToPage(_current,
        duration: Duration(milliseconds: 1500),
        curve: Curves.linear);
    }
    startTimer();
  }

  /*
    exerciseTrain(index)
    Author: Sophie
    Created Date & Time:  March 31 2020 6:18AM

    Function: exerciseTrain

    Description: Train stage of every exercise step is carried out by this function.

    Parameters: index(int)  - index of current exercise step 
  */
  exerciseTrain(index) {
    setState(() {
      _time = int.parse(_exerciseData[index]['durationTime']);
      _exerciseComment = _exerciseData[index]['name'];
      _stageState = 'train';
    });
    startTimer();
  }

  /*
    exerciseScore(index)
    Author: Sophie
    Created Date & Time:  March 31 2020 6:40AM

    Function: exerciseScore

    Description: Score stage of every exercise step is carried out by this function.

    Parameters: index(int)  - index of current exercise step 
  */
  exerciseScore(index) {
    txt.text = '';
    _pc.open();
    FocusScope.of(context).requestFocus(myFocusNode);
  }

  /*
    timeProcess(int time, String type)
    Author: sophie
    Created Date & Time:   Mar 31 2020 5:43PM

    Function: timeProcess

    Description:  Process according to current time is carried out.

    Parameters: time(int) - current time
                type(String)  - current stage of exercise step
  */
  timeProcess(int time, String type) {
    print("_time ${_time}");
    switch (type) {
      case "train":
        if (time == (int.parse(_exerciseData[_current]['durationTime']) / 2).round()) {
          playListVoice(_exerciseData[_current]['half']);
        }
        switch (time) {
          case 8:
            setState(() {
              _exerciseComment = "Rest starts in...";
            });
            break;
          case 3:
            playListVoice(_exerciseData[_current]['3s']);
            playMusic("countdown", "sound");
            break;
          case 2:
            playListVoice(_exerciseData[_current]['2s']);
            break;
          case 1:
            playListVoice(_exerciseData[_current]['1s']);
            break;
          case 0:
            playListVoice(_exerciseData[_current]['train0s']);
            break;
          default:
        }
        break;
      case "rest":
        switch (time) {
          case 10:
            playListVoice(_exerciseData[_current]['10s']);
            break;
          case 8:
            playListVoice(_exerciseData[_current]['8s']);
            setState(() {
              _exerciseComment = _exerciseData[_current]['name'] + " starts in...";
            });
            break;
          case 3:
            playListVoice(_exerciseData[_current]['3s']);
            playMusic("countdown", "sound");
            break;
          case 2:
            playListVoice(_exerciseData[_current]['2s']);
            break;
          case 1:
            playListVoice(_exerciseData[_current]['1s']);
            break;
          case 0:
            playListVoice(_exerciseData[_current]['0s']);
            break;
          default:
        }
        break;
      default:
    }
  }

  /*
    void startTimer()
    Author: Sophie
    Created Date & Time:  Mar 31 2020 5:33AM

    Function: startTimer

    Description: Using this function, Timer can be started and all process related to timer is carried out.
  */
  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_time < 1) {
            timer.cancel();
            switch (_stageState) {
              case "rest":
                exerciseTrain(_current);
                break;
              case "train":
                exerciseScore(_current);
                break;
              default:
            }
          } else {
            // print("_time ${_time}");
            timeProcess(_time, _stageState);
            print(_time);
            _time = _time - 1;
          }
        }
      )
    );
  }

  /*
    void startPauseTimer
    Author: Sophie(bolesalavb@gmail.com)
    Created Date & Time:  Jun 7 2020 10:36 PM

    Function: startPauseTimer()

    Description:  Start/Pause Timer
  */
  void startPauseTimer() {
    if (_playState) {
      _timer.cancel();
      setState(() {
        _playState = false;
      });
    } else {
      startTimer();
      setState(() {
        _playState = true;
      });
    }
  }

  /*
    void displayEndWorkoutDialog()
    Author: Sophie(bolesalavb@gmil.com)
    Created Date & Time: Jun 7 2020 10:54 PM

    Function: displayEndWorkoutDialog

    Description: Display 'End Workout' dialog
  */
  void displayEndWorkoutDialog() {
    _endWorkoutDialog();
    _timer.cancel();
    setState(() {
      _playState = false;
    });
  }

  /*
    void displayRepeatExerciseDialog()
    Author: Sophie(bolesalavb@gmil.com)
    Created Date & Time: July 24 2020 5:05 AM

    Function: displayRepeatExerciseDialog

    Description: Display 'Repeat Exercise' dialog
  */
  void displayRepeatExerciseDialog() {
    _repeatExerciseDialog();
    _timer.cancel();
    setState(() {
      _playState = false;
    });
  }

  /*
    void storeExerciseTimeRep(int rep, bool type)
    Author: Sophie(bolesalavb@gmail.com)
    Created Time & Date: June 8 2020 6:08 PM
    Updated Time & Date: July 24 2020 5:58 AM

    Function: storeExerciseTimeRep

    Description:  Add exercise time, rep and store

    Parameters: rep(int)  - exercise rep
                type(bool) - if rep is 0, true, if not false
  */
  void storeExerciseTimeRep(int rep, bool type) {
    int time = type 
      ? int.parse(_exerciseData[_current]['durationTime']) - _time
      : int.parse(_exerciseData[_current]['durationTime']);
    _workout.add(Exercise(
      name: _exerciseData[_current]['name'],
      rep: rep,
      time: time,
    ));
  } 

  @override
  void initState() {
    super.initState();

    fetchData();
    myFocusNode = new FocusNode();
    setState(() {
      Wakelock.enable();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    myFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    print("setting ${globals.nightTheme}");

    exerciseCarousel = CarouselSlider.builder(
      height: 500,
      itemCount: _exerciseData.length,
      itemBuilder: (BuildContext context, int itemIndex) =>
        Container(
          padding: EdgeInsets.all(50.0),
          child: new Image.network(
            _exerciseData[itemIndex]['url'],
            fit: BoxFit.cover,
          ),
        ),
    );

    if(_firstBuilding) {
      exerciseRest(_current, true);
      setState(() {
        _firstBuilding = false;
      });
    }

    var stringTime = _time.toString();
    if (_time < 10) {
      stringTime = "0" + _time.toString();
    }
    
    if (!globals.nightTheme) {
      setState(() {
        _nightMode = false;
      });
    } else {
      setState(() {
        _nightMode = true;
      });
    }
    

    return Container(
      color: _nightMode ? Colors.black : Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: SlidingUpPanel(
            isDraggable: false,
            minHeight: 0.0,
            maxHeight: 370.0,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
            controller: _pc,
            panel: new Container(
              // color: Colors.transparent,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.6), spreadRadius: 2000),
                ],
              ),
              padding: const EdgeInsets.all(10.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text("How many?",
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3A5998),
                    ),
                  ),
                  new Container(
                    width: 200.0,
                    child: new TextField(
                      controller: txt,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 100,
                        fontFamily: 'HK Grotesk',
                      ),
                      focusNode: myFocusNode,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: ButtonTheme(
                      minWidth: 120.0,
                      // height: 100.0,
                      child: CustomFlatButton(
                        title: "Save",
                        fontSize: 20,
                        textColor: Colors.white,
                        onPressed: () {
                          if (txt.text != '') {
                            storeExerciseTimeRep(int.parse(txt.text), false);
                            if (_current == _exerciseData.length - 1) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NascarResultsScreen(
                                    workout: _workout,
                                    name: widget.name,
                                  )),
                              ); 
                            } else {
                              setState(() {
                                _current = _current + 1;
                              });
                              _pc.close();
                              myFocusNode.unfocus();
                              exerciseRest(_current, true);
                            }
                          }
                        },
                        splashColor: Colors.black12,
                        borderColor: Colors.black,
                        borderWidth: 0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              )
            ),
            body: Container(
              color: _nightMode ? Colors.black : Colors.white,
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: IconButton(
                      color: _nightMode ? Colors.white : Colors.grey,
                      icon: Icon(Icons.arrow_back), 
                      onPressed: (){
                        displayEndWorkoutDialog();
                      }),
                    title: Center(
                      child: Text(
                        widget.name.toUpperCase(),
                        style: TextStyle(
                          color: _nightMode ? Colors.white : Colors.grey,
                          fontSize: 12,
                        ),
                      )
                    ),
                    subtitle: Center(
                      child: Text(
                        _exerciseData[_current]['name'],
                        style: TextStyle(
                          color: _nightMode ? Colors.white : Colors.grey.shade800,
                          fontSize: 12,
                        ),
                      )
                    ),
                    trailing:IconButton(
                      color: _nightMode ? Colors.white : Colors.black,
                      icon: Icon(Icons.more_vert), 
                      onPressed: (){
                        globals.exerciseScreen = true;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingsScreen(
                            )),
                        );
                        // _timer.cancel();
                         
                    }),
                  ),
                  // exerciseCarousel,
                  Expanded(
                    child: exerciseCarousel
                  ),
                  Text(
                    _exerciseComment,
                    style: TextStyle(
                      color: _nightMode ? Colors.white : Colors.grey,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  _carouselIndicator(),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    '0:' + stringTime,
                    style: TextStyle(
                      color: _nightMode ? Colors.white : Colors.grey.shade800,
                      fontSize: 40,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(60, 0, 60, 15),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          IconButton(
                            color: _nightMode ? Colors.white : Colors.black,
                            icon: Icon(Icons.refresh,size: 30,), onPressed: (){
                              displayRepeatExerciseDialog();
                          }),
                          IconButton(icon: _prevIcon(), onPressed: (){
                            if (_current != 0){
                              _timer.cancel();
                              storeExerciseTimeRep(0, true);
                              setState(() {
                                _current = _current - 1;
                                _playState = true;
                              });
                              exerciseRest(_current, false);
                            }
                          }),
                          _playPauseButton(),
                          IconButton(icon: _nextIcon(), onPressed: (){
                            if (_current != _exerciseData.length - 1) {
                              _timer.cancel();
                              storeExerciseTimeRep(0, true);
                              setState(() {
                                _current = _current + 1;
                                _playState = true;
                              });
                              exerciseRest(_current, false);
                            }
                          }),
                          IconButton(
                            color: _nightMode ? Colors.black : Colors.white,
                            icon: Icon(Icons.stop,size: 30,), onPressed: (){
                            // displayEndWorkoutDialog();
                          }),
                        ],
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1000),
                        // borderRadius: BorderRadius.circular(10),
                        color: _nightMode ? Colors.black :Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 5,
                            offset: Offset(0, 0), // changes position of shadow
                          ),
                          // BoxShadow(color: Colors.green, spreadRadius: 3),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
            
          ),
        ),
      ),
    );
  }

  /*
    Widget _prevIcon()
    Author: Sophie
    Created Date & Time:  Apr 1 2020 3:25AM

    Widget: _prevIcon

    Description:  This widget is Icon of prev Button.
  */
  Widget _prevIcon() {
    if (_current == 0) {
      return Icon(Icons.fast_rewind, size: 30,
        color: Colors.grey.withOpacity(0.5),
      );
    } else {
      return Icon(Icons.fast_rewind, size: 30,
        color: _nightMode ? Colors.white : Colors.black,
      );
    }
  }

  /*
    Widget _nextIcon()
    Author: Sophie
    Created Date & Time:  Apr 1 2020 3:27AM

    Widget: _nextIcon

    Description:  This widget is Icon of next Button.
  */
  Widget _nextIcon() {
    if (_current == _exerciseData.length - 1) {
      return Icon(Icons.fast_forward,size: 30,
        color: Colors.grey.withOpacity(0.5),
      );
    } else {
      return Icon(Icons.fast_forward,size: 30,
        color: _nightMode ? Colors.white : Colors.black,
      );
    }
  }

  /*
    Widget _playPauseButton()
    Author: Sophie
    Created Date & Time:  Apr 1 2020 4:10 AM
    Updated Date & Time:  Jun 7 2020 10:34 PM
    Widget: _playPauseButton

    Description:  Play/Pause Button
  */
  Widget _playPauseButton() {
    return IconButton(
      icon: Icon(_playState ? Icons.pause_circle_outline : Icons.play_circle_outline,
        size: 30, 
        color: _nightMode ? Colors.white : Colors.black,
      ), 
      onPressed: (){
        startPauseTimer();
    });
  }

  /*
    Widget _carouselIndicator()
    Author: Sophie
    Created Date & Time:  Apr 1 2020 4:56AM

    Widget: _carouselIndicator
  */
  Widget _carouselIndicator() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 0,
          child: PageView(
            controller: controller,
            children: List.generate(
                _exerciseData.length,
                (_) => Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      child: Container(height: 280),
                    )),
          ),
        ),
        Container(
          child: SmoothPageIndicator(
            controller: controller,
            count: _exerciseData.length,
            effect:  WormEffect(
              spacing:  4.0,
              radius:  12.0,
              dotWidth:  9.0,
              dotHeight:  9.0,
              paintStyle:  PaintingStyle.fill,
              strokeWidth:  1.5,
              dotColor:  Colors.grey,
              activeDotColor:  Colors.blue
            ),
          ),
        ),
      ],
    );
  }
}