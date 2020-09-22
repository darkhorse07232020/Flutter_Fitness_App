import "package:flutter/material.dart";
import 'dart:async';
import 'package:onboarding_flow/models/settings.dart';
import 'package:onboarding_flow/ui/screens/inout.dart';

class Ready extends StatefulWidget {
  final Settings settings;
  final int id;
  final String name;
  final String image;

  Ready({this.settings, this.id, this.name, this.image});

  _ReadyState createState() => _ReadyState();
}

class _ReadyState extends State<Ready> {
  VoidCallback onBackPress;

  @override
  void initState() {
    super.initState();
  }

  
  Timer _timer;
  int _start = 3;
  bool _timeCheck =false;

  var now = new DateTime.now();

  void startTimer() {
    _timeCheck = true;
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start == 1) {
            timer.cancel();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InOut(
                  id: widget.id,
                  name: widget.name,
                  image: widget.image,
                )),
            ); 
          } else {
            print(_start);
            _start = _start - 1;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if (!_timeCheck) startTimer();

    return Scaffold(
      backgroundColor: Color(0xFF85C1E9),
      body: new Center(
        child: new Text(_start.toString(),
          style: TextStyle(
            fontSize: 360,
            fontFamily: 'HK Grotesk',
            color: Colors.white,
          ),
        ),
      ),
    );
  }

}
