import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onboarding_flow/ui/widgets/custom_flat_button.dart';

class WelcomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    //preloading images...
    Firestore.instance.collection('workout').orderBy('workoutID').snapshots().listen((data) => {
      data.documents.forEach((doc) {
        precacheImage(NetworkImage(doc['image']), context);
        Firestore.instance.collection('exercise' + doc['workoutID'].toString()).orderBy('no').snapshots().listen((data) => {
          data.documents.forEach((doc) {
            if (doc['url'] != null) precacheImage(NetworkImage(doc['url']), context);
          }),
        });
      }),
    });

    return Scaffold(
      body: new ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 60.0),
            child: new Container(
              height: 80.0,
              child: new Image.asset('assets/images/ball.png', fit: BoxFit.fitHeight),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 0.0),
            child: new Center(
              child: new Text(
                    'Brave Fit',
                    style: TextStyle(
                      color: Color(0xFF83BFE6),
                      fontSize: 52,  
                      fontFamily: 'Xbka',
                    ),
                  ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 0.0),
            child: new Container(
              height: 25.0,
              child: new Image.asset('assets/images/logo.png', fit: BoxFit.fitHeight),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25.0, right: 15.0, left: 15.0),
            child: Text(
              "Hi there,",
              softWrap: true,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                decoration: TextDecoration.none,
                fontSize: 26.0,
                fontWeight: FontWeight.w700,
                fontFamily: "Comic",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0.0, right: 15.0, left: 15.0),
            child: Text(
              "Welcome to Brave Fit",
              softWrap: true,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                decoration: TextDecoration.none,
                fontSize: 26.0,
                fontWeight: FontWeight.w700,
                fontFamily: "Comic",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0.0, right: 15.0, left: 15.0),
            child: Text(
              "Your personal assistance to soccer excellence",
              softWrap: true,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                decoration: TextDecoration.none,
                fontSize: 22.0,
                fontWeight: FontWeight.w300,
                fontFamily: "Comic",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100.0, right: 15.0, left: 15.0),
            child: CustomFlatButton(
              title: "I'm ready to sign up",
              fontSize: 20,
              fontWeight: FontWeight.w700,
              textColor: Colors.black,
              onPressed: () {
                Navigator.of(context).pushNamed("/signup");
              },
              splashColor: Colors.black12,
              borderColor: Colors.white,
              borderWidth: 0,
              color: Color.fromRGBO(220, 226, 237, 1.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, right: 15.0, left: 15.0),
            child: CustomFlatButton(
              title: "I ALREADY HAVE AN ACCOUNT",
              fontSize: 20,
              fontWeight: FontWeight.w700,
              textColor: Colors.grey,
              onPressed: () {
                Navigator.of(context).pushNamed("/signin");
              },
              splashColor: Colors.white,
              borderColor: Colors.white,
              borderWidth: 2,
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(top: 140.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, "/main");
          },
          child: Text("Skip",
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
            )
          ),
          backgroundColor: Colors.green,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}
