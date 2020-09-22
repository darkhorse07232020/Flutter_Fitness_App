import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:onboarding_flow/models/settings.dart';
import 'package:onboarding_flow/ui/screens/ready_screen.dart';
import 'package:onboarding_flow/ui/screens/main_screen.dart';
import 'package:onboarding_flow/ui/screens/video_screen.dart';
import 'package:onboarding_flow/ui/widgets/custom_circle_button.dart';
import 'package:onboarding_flow/ui/widgets/custom_flat_button.dart';

class Preview extends StatefulWidget {
  final FirebaseUser firebaseUser;
  final Settings settings;
  final int id;
  final String name;
  final String image;

  Preview({this.firebaseUser, this.settings, this.id, this.name, this.image});
  _PreviewState createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {

  VoidCallback onBackPress;

  /*
    Future<void> _getReadyDialog() async
    Author: Sophie(bolesalavb@gmail.com)
    Created Date & Time: July 24 2020 4:51 AM

    Future<void>: _getReadyDialog

    Description: 'Get Ready' Dialog
  */
  Future<void> _getReadyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Text('Get Ready?'),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Text('Turn on the music and get ready to start your workout.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('I am ready!'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Ready(
                      settings: widget.settings,
                      id: widget.id,
                      name: widget.name,
                      image: widget.image,
                    )),
                ); 
              },
            ),
            FlatButton(
              child: Text('Need more time',
                style: TextStyle(
                  fontSize: 13.0
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {

    super.initState();
    print(widget.settings);
  }

  @override
  void dispose() {

    super.dispose();
  }

  var now = new DateTime.now();

  Widget _buildList(BuildContext context, DocumentSnapshot document) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
      child: Row(
        children: <Widget>[
          new Image.network(
            document['url'],
            height: 100.0,
          ),
          
          Expanded(
            flex: 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(
                  document['name'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                new Text("Rest"),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(document['durationTime'] + "s"),
                new Text(document['restTime'] + "s"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).popUntil(ModalRoute.withName('/main')),
          ),
        title: Text(
          'Preview',
          textAlign: TextAlign.center,  
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      body: new Center(
        child: new Column(
          children: <Widget>[
            new Flexible(
              child: StreamBuilder(
                stream: Firestore.instance.collection('exercise' + widget.id.toString()).orderBy('no').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text("Loading...");
                  }
                  return new ListView.builder(
                    itemCount: snapshot.data.documents.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Container(
                          child: Column(
                            children: <Widget>[
                              InkWell(
                                child: Stack(
                                  children: <Widget> [
                                    new Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: new Image.network(widget.image, fit: BoxFit.fitWidth),
                                    ),
                                    Positioned(
                                      left: 20,
                                      bottom: 20,
                                      child: new Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          new Text(new DateFormat.yMMMd('en_US').format(now),
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          new Text(widget.name.toUpperCase(),
                                            style: TextStyle(
                                              color: Colors.white, 
                                              fontSize: 23, 
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          new Text("16Mins. | HIIT | Beginner",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      )
                                    ),
                                  ]
                                ),
                                onTap: () {
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.all(20.0),
                                child: new Text("Warm-ups to use",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  _warmupButton(Colors.black45, "3 min", 'https://www.youtube.com/watch?v=HDfvWrGUkC8'),
                                  // _warmupButton(Colors.black45, "test", 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4'),
                                  _warmupButton(Colors.black, "12 min", 'https://www.youtube.com/watch?v=iqbbwFYXjFc&t=617s'),
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                                child: Divider(
                                  thickness: 1,
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                            ],
                          ),
                        );
                      } else {
                        if(snapshot.data.documents[index - 1]['url'] != null) return _buildList(context, snapshot.data.documents[index - 1]);
                      }
                    },
                  ); 
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _getReadyDialog();
        },
        label: new Text("  Start Workout  ",
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

  Widget _warmupButton(Color color, String txt, String url) {
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
          child: new CircleButton(
            onTap: () {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoPlayerScreen(
                    settings: widget.settings,
                    url: url,
                  )),
              );
            },
            color: color,
            size: 22.0,
          ),
        ),
        new Text(txt,
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}