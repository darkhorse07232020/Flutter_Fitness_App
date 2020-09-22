import 'package:flutter/material.dart';
import 'package:onboarding_flow/models/settings.dart';
import 'package:onboarding_flow/ui/screens/exercise_screen.dart';
import 'package:onboarding_flow/ui/screens/main_screen.dart';
import '../../globals.dart' as globals;

class SettingsScreen extends StatefulWidget {
  SettingsScreen();

  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final settings = Settings(
    sound: globals.sound,
    voice: globals.voice,
    nightTheme: globals.nightTheme,
  );

  bool checked = false;
  // String switchTextSound = "OFF";
  // String switchTextVoice = "ON";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // if (!checked && widget.settings != null) {
    //   if (!widget.settings.sound) {
    //     setState(() {
    //       settings.sound = false;
    //       switchTextSound = "OFF";
    //       checked = true;
    //     });
    //   }
    //   if (!widget.settings.voice) {
    //     setState(() {
    //       settings.voice = false;
    //       switchTextVoice = "OFF";
    //       checked = true;
    //     });
    //   }
    // }
    return DefaultTabController(
      length: 2, 
      child: new Scaffold(
          key: _scaffoldKey,
          appBar: new AppBar(
            centerTitle: true,
            elevation: 0.5,
            leading: new IconButton(
                icon: new Icon(Icons.arrow_back),
                onPressed: () {
                  _scaffoldKey.currentState.openDrawer();
                  Navigator.of(context).pop();
                }),
            title: new Text("SETTINGS",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22.0,
              ),
            ),
          ),
          body: new Container(
            padding: EdgeInsets.all(30.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text("SOUND",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                  child: Row(
                    children: <Widget>[
                      Text(settings.sound ? "ON" : "OFF", 
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      Switch(
                        onChanged: toggleSwitchSound,
                        value: settings.sound,
                        activeColor: Colors.white,
                        activeTrackColor: Colors.green,
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.grey,
                      ),
                    ],
                  ),
                ),
                new Text("VOICE",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                  child: Row(
                    children: <Widget>[
                      Text(settings.voice ? "ON" : "OFF", 
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      Switch(
                        onChanged: toggleSwitchVoice,
                        value: settings.voice,
                        activeColor: Colors.white,
                        activeTrackColor: Colors.green,
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.grey,
                      ),
                    ],
                  ),
                ),
                new Text("Theme",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RadioListTile<bool>(
                          activeColor: Colors.black,
                          title: const Text('Light'),
                          value: false,
                          groupValue: settings.nightTheme,
                          onChanged: (value) {
                            globals.nightTheme = value;
                            setState(() {
                              settings.nightTheme = value;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<bool>(
                          activeColor: Colors.black ,
                          title: const Text('Dark'),
                          value: true,
                          groupValue: settings.nightTheme,
                          onChanged: (value) {
                            globals.nightTheme = value;
                            setState(() {
                              settings.nightTheme = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.white,
        ),
      );
    
  }


  void toggleSwitchSound(bool value) {
    if(settings.sound == false)
    {
      globals.sound = true;
      setState(() {
        settings.sound = true;
      });
    }
    else
    {
      globals.sound = false;
      setState(() {
        settings.sound = false;
      });
    }
  }

  void toggleSwitchVoice(bool value) {
    if(settings.voice == false)
    {
      globals.voice =true;
      setState(() {
        settings.voice = true;
      });
    }
    else
    {
      globals.voice = false;
      setState(() {
        settings.voice = false;
      });
    }
  }
}
