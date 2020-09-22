import "package:flutter/material.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:onboarding_flow/ui/screens/nascarresults.dart';
import 'package:onboarding_flow/ui/screens/preview_screen.dart';
import 'package:onboarding_flow/ui/widgets/custom_flat_button.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:onboarding_flow/models/settings.dart';

class Exercise extends StatefulWidget {
  final FirebaseUser firebaseUser;
  final Settings settings;
  final int id;

  Exercise({this.firebaseUser, this.settings, this.id});
  _ExerciseState createState() => _ExerciseState();
}

class _ExerciseState extends State<Exercise> {
  // VoidCallback onBackPress;
  PanelController _pc = new PanelController();
  FocusNode myFocusNode;
  var txt = TextEditingController();
  final controller = PageController(viewportFraction: 0.8);
  AudioPlayer advancedPlayer;

  void playMusic(String title, String method) {
    Future loadMusic() async {
      advancedPlayer = await AudioCache().play("music/" + title + ".mp3");
    }

    if (method == "Sound") {
      if(widget.settings == null) {
        // loadMusic();
      } else if (widget.settings.sound) {
        loadMusic();
      }
    }

    if (method == "voice") {
      if(widget.settings == null) {
        loadMusic();
      } else if (widget.settings.voice) {
        loadMusic();
      }
    }

  }
  
  void playArrayMusic(List list) {
    for (var i = 0; i < list.length; i++) {
      playMusic(list[i], "voice");
    }
  }

  @override
  void initState() {
    super.initState();
    print(widget.settings);
    
    Firestore.instance.collection('exercise' + widget.id.toString()).orderBy('no').snapshots().listen((data) =>
        data.documents.forEach((doc) => _exerciseData.add(doc)));
    myFocusNode = new FocusNode();
  }

  var _basicCarousel;

  List _exerciseData = [];
  
  Timer _timer;
  int _start = 8;
  int _loadingCheck = 0;
  int _trainingcheck = 0;
  int _soccercheck = 0;
  String _exerciseTxt = 'Exercise starts in...';
  int _exerciseNum = 0;
  // int _timerStop = 0;
  String _btnTxt = " Pause ";
  String _exerciseTitle = 'Exercise';

  var now = new DateTime.now();

  void training() {
    setState(() {
      _exerciseTxt = _exerciseData[_exerciseNum]['name'];
      _start = int.parse(_exerciseData[_exerciseNum]['durationTime']);
      _trainingcheck = 1;
      _exerciseTitle = _exerciseData[_exerciseNum]['name'];
    });
    _basicCarousel.animateToPage(_exerciseNum,
      duration: Duration(milliseconds: 1500),
      curve: Curves.linear);
    controller.animateToPage(_exerciseNum,
      duration: Duration(milliseconds: 1500),
      curve: Curves.linear);
    startTimer();
  }

  void rest() {
    setState(() {
      _exerciseTxt = 'Rest';
      _start = int.parse(_exerciseData[_exerciseNum]['restTime']);
      _trainingcheck = 0;
      _exerciseNum ++;
      _exerciseTitle = _exerciseData[_exerciseNum]['name'];
      _soccercheck = 0;
      _btnTxt = " Pause ";
    });
    _basicCarousel.animateToPage(_exerciseNum,
      duration: Duration(milliseconds: 1500),
      curve: Curves.linear);
    controller.animateToPage(_exerciseNum,
      duration: Duration(milliseconds: 1500),
      curve: Curves.linear);
    startTimer();
  }
 
  void score() {
    setState(() {
      _btnTxt = " Save ";
      _soccercheck = 1;
    });
    txt.text = "";
    _pc.open();
    FocusScope.of(context).requestFocus(myFocusNode);
  }

  void changeComment() {
    if (_trainingcheck != 0) {
      setState(() {
        _exerciseTxt = 'Rest starts in...';
      });
    } else {
      setState(() {
        _exerciseTxt = _exerciseData[_exerciseNum]['name'] + ' starts in...';
      });
    }
  }

  void startTimer() {
    _basicCarousel = CarouselSlider.builder(
      height: 250,
      itemCount: _exerciseData.length,
      itemBuilder: (BuildContext context, int itemIndex) =>
        Container(
          padding: EdgeInsets.all(0.0),
          child: new Image.network(
            _exerciseData[itemIndex]['url'],
          ),
        ),
    );
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
          
            if (_trainingcheck == 0) {
              training();
            } else {
              score();
              // else score();
            }
          } else {
            print(_start);
            _start = _start - 1;
          }
          if (_start <= 8) {
            changeComment();
          } 
          if (_start == 3) {
            playMusic("countdown", "sound");
          }
          if (_trainingcheck == 0) {
            switch (_start) {
              case 8:
                playArrayMusic(_exerciseData[_exerciseNum]['8s']);
                break;
              case 3:
                playArrayMusic(_exerciseData[_exerciseNum]['3s']);
                break;
              case 2:
                playArrayMusic(_exerciseData[_exerciseNum]['2s']);
                break;
              case 1:
                playArrayMusic(_exerciseData[_exerciseNum]['1s']);
                break;
              case 0:
                playArrayMusic(_exerciseData[_exerciseNum]['0s']);
                break;
              default:
            }
          } else {
            if (_start == (int.parse(_exerciseData[_exerciseNum]['durationTime']) / 2).round()) {
              playArrayMusic(_exerciseData[_exerciseNum]['half']);
            }
          }
        },
      ),
    );
  }

  

  void timerPauseStart() {
    if ( _soccercheck == 1) {
      if (_exerciseNum < _exerciseData.length ) rest();
      if (_exerciseNum == _exerciseData.length ) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NascarResultsScreen(
              settings: widget.settings,
            )),
        ); 
        _timer.cancel();  
      }
      _pc.close();
      myFocusNode.unfocus();
    } else {

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return _exercisePopUp(); 
        }
      );
      _timer.cancel();
      setState(() {
        _btnTxt = " Resume ";
      });
    }
  }

  void backPress() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Preview(
          settings: widget.settings,
        )),
    ); 
    // Navigator.pushNamed(context, "/soccerbasics");
    _timer.cancel();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _timer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if ( _loadingCheck == 0) {
      _loadingCheck = 1;
      startTimer();
    }

    var stringTime = _start.toString();
    if (_start < 10) {
      stringTime = "0" + _start.toString();
    }

    return Scaffold(
      backgroundColor: Color(0xFF85C1E9),
      appBar: AppBar(
        centerTitle: true,
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () => 
              backPress()
            ),
        title: Text(
          _exerciseTitle,
          textAlign: TextAlign.center,  
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF85C1E9),
      ),
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
              new Text("How many reps?",
                style: TextStyle(
                  fontSize: 36.0,
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
                    fontSize: 120,
                    fontFamily: 'HK Grotesk',
                  ),
                  focusNode: myFocusNode,
                  keyboardType: TextInputType.number,
                ),
              ),
              
            ],
          )
        ),
        body: StreamBuilder(
          stream: Firestore.instance.collection('exercise1').orderBy('no').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text("Loading...");
            }
            return new ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                
                return new Center(
                  child: new Column(
                    children: <Widget>[
                      new Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(10.0),
                        child:  new Column(
                          children: <Widget>[
                            _basicCarousel,
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
                            Padding(
                              padding: const EdgeInsets.only(top: 16, bottom: 8),
                            ),
                            Container(
                              child: SmoothPageIndicator(
                                controller: controller,
                                count: _exerciseData.length,
                                effect:  WormEffect(
                                  spacing:  8.0,
                                  radius:  12.0,
                                  dotWidth:  12.0,
                                  dotHeight:  12.0,
                                  paintStyle:  PaintingStyle.fill,
                                  strokeWidth:  1.5,
                                  dotColor:  Colors.grey,
                                  activeDotColor:  Colors.indigo
                                ),
                                // effect: WormEffect(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      new Container(
                        padding: EdgeInsets.all(30.0),
                        width: MediaQuery.of(context).size.width,
                        color: Color(0xFF85C1E9),
                        child: new Center(
                          child: new Column(
                            children: <Widget>[
                              new Container(
                                padding: EdgeInsets.all(10.0),
                                child: new Text(_exerciseTxt,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,  
                                  ),
                                ),
                              ),
                              new Text("0:" + stringTime,
                                style: TextStyle(
                                  fontSize: 120,
                                  fontFamily: 'HK Grotesk',
                                ),
                              ),
                            ]
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ); 
        }),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          timerPauseStart();
        },
        label: new Text(" " + _btnTxt + " ",
          style: TextStyle(
            color: Colors.white,
            fontSize: 15.0,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
  
  Widget _exercisePopUp() {
    return Dialog(
      backgroundColor: Colors.white,
      elevation: 16,
      child: Container(
        height: 280.0,
        width: 360.0,
        child: new Center(
          child: new Container(
            child: new Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: new Text("End Workout?",
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text("Going back will restart the", style: TextStyle(fontSize: 18.0),),
                Text("timer. Are you sure you", style: TextStyle(fontSize: 18.0),),
                Text("want to do this?", style: TextStyle(fontSize: 18.0),),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: ButtonTheme(
                    minWidth: 260.0,
                    // height: 100.0,
                    child: CustomFlatButton(
                      title: "No",
                      fontSize: 20,
                      textColor: Colors.black,
                      onPressed: () {
                        startTimer();
                        setState(() {
                          _btnTxt = " Pause ";
                        });
                        Navigator.pop(context);
                      },
                      splashColor: Colors.black12,
                      borderColor: Color(0xFFDCE2ED),
                      borderWidth: 0,
                      color: Color(0xFFDCE2ED),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: ButtonTheme(
                    minWidth: 260.0,
                    // height: 100.0,
                    child: CustomFlatButton(
                      title: "Yes",
                      fontSize: 20,
                      textColor: Colors.white,
                      onPressed: () {
                        if (_trainingcheck != 0) {
                          if (_exerciseNum == 0) {
                            setState(() {
                              _exerciseTxt = 'Rest';
                              _start = 8;
                              _trainingcheck = 0;
                              _exerciseTitle = "Exercise";
                              _soccercheck = 0;
                              _btnTxt = " Pause ";
                            });
                            startTimer();
                          } else {
                            setState(() {
                              _exerciseNum --;
                            });
                            rest();
                          }
                        } else {
                          if (_exerciseTitle == "Exercise") {
                            setState(() {
                              _exerciseTxt = 'Rest';
                              _start = 8;
                              _trainingcheck = 0;
                              _exerciseTitle = "Exercise";
                              _soccercheck = 0;
                              _btnTxt = " Pause ";
                            });
                            startTimer();
                          } else {
                            rest();
                          }
                        }
                        Navigator.pop(context);
                      },
                      splashColor: Colors.black12,
                      borderColor: Color(0xFF3A5998),
                      borderWidth: 0,
                      color: Color(0xFF3A5998),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ), 
      ),
    );
  } 
}
