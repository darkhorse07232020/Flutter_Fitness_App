/*
  Result Screen file
  Updated on June 8 2020 by Sophie(bolesalavb@gmail.com)
*/
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onboarding_flow/models/settings.dart';
import 'package:onboarding_flow/models/exercise.dart';
import 'package:onboarding_flow/ui/screens/main_screen.dart';

class NascarResultsScreen extends StatefulWidget {
  Settings settings;
  List workout;
  String name;
  
  NascarResultsScreen({this.settings, this.workout, this.name});
  @override
  _NascarResultsScreenState createState() => _NascarResultsScreenState();
}

class _NascarResultsScreenState extends State<NascarResultsScreen> {
  int totalSteps = 0;
  int totalTime = 0;
  String workoutTime;

  /*
    void getTotalStep()
    Author: Sophie(bolesalavb@gmail.com)
    Created Date & Time:  June 8 2020 7:51 PM

    Function: getTotalStep

    Description: Getting total step
  */
  void getTotalStep() {
    if (widget.workout != null) {
      for(var i = 0; i < widget.workout.length; i++){
        totalSteps += widget.workout[i].rep;
      }
    }
  }
  
  /*
    void getTotalTime()
    Author: Sophie(bolesalavb@gmail.com)
    Created Date & Time: June 8 2020 8:26 PM

    Function: getTotalTime

    Description: Get total time and convert to MM:SS format
  */
  void getTotalTime() {
    if (widget.workout != null) {
      for(var i = 0; i < widget.workout.length; i++){
        totalTime += widget.workout[i].time;
      }
    }
    print('totalTime ${totalTime}');
    workoutTime = (totalTime ~/ 60).toString() + ':' + (totalTime % 60).toString();
  }

  @override
  void initState() {
    super.initState();

    getTotalStep();
    getTotalTime();
  }

  @override
  Widget build(BuildContext context) {
    
    print('workoutTime ${workoutTime}');
    return Scaffold(
      body: Builder(
        builder: (context) => 
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children:[
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.name.toUpperCase() + ' Results',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      getExerciseListWidgets(widget.workout),
                      Center(
                        child: Text(
                          'Total Reps',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          totalSteps.toString(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: Divider(
                          thickness: 1,
                        ),
                      ),
                      Center(
                        child: Text(
                          workoutTime,
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          'Workout Time',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:[
                    Expanded(
                      child: RaisedButton(
                        onPressed: (){
                          Navigator.of(context).popUntil(ModalRoute.withName('/main'));
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => MainScreen(
                          //       settings: widget.settings,
                          //     )),
                          // );
                        },
                        child: Text(
                          'FINISH',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      color: Colors.black,
                      ),
                    ),
                    Expanded(child: RaisedButton(
                      onPressed: (){
                        String clipboard = '';
                        for(var i = 0; i < widget.workout.length; i++){
                          clipboard += widget.workout[i].name + ' ' + widget.workout[i].rep.toString() + 'rep\n';
                        }
                        clipboard += 'Total Rep ' + totalSteps.toString() + 'rep\n';
                        clipboard += 'Workout Time ' + ' ' + workoutTime;
                        print(clipboard);
                        Clipboard.setData(ClipboardData(text: clipboard)).then((result) {
                          final snackBar = SnackBar(
                            content: Text('Copied to Clipboard'),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () {},
                            ),
                          );
                          Scaffold.of(context).showSnackBar(snackBar);
                        });
                      },
                      child: Text(
                        'SHARE',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      color: Colors.greenAccent,
                      ),
                    ),
                  ]
                ),
              ]
            )
          ),
      ),
    );
  }

  /*
    Widget getExerciseListWidgets(List workout)
    Author: Sophie(bolesalavb@gmail.com)
    Created Date & Time:  June 8 2020 7:17 PM

    Widget: getExerciseListWidget

    Description:  List of exercise name and rep

    Parameters: workout(List) - exercise List(name, rep & time)
  */
  Widget getExerciseListWidgets(List workout)
  {
    List<Widget> list = new List<Widget>();
    if (workout != null) {
      for(var i = 0; i < workout.length; i++){
        list.add(
          ListTile(
            dense: true,
            leading: Text(workout[i].name),
            trailing: Text(workout[i].rep.toString() + ' reps'),
          )
        );
      }
    }
    return new Column(children: list);
  }
}