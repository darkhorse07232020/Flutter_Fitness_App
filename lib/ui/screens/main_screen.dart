/*
  Main Screen file
  Updated on June 9 2020 by Sophie(bolesalavb@gmail.com)
*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onboarding_flow/business/auth.dart';
import 'package:onboarding_flow/models/settings.dart';
import 'package:onboarding_flow/ui/screens/root_screen.dart';
import 'package:onboarding_flow/ui/screens/settings_screen.dart';
import 'package:onboarding_flow/ui/screens/activity.dart';
import 'package:onboarding_flow/ui/screens/profile.dart';
import 'package:onboarding_flow/ui/screens/preview_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class MainScreen extends StatefulWidget {
  final FirebaseUser firebaseUser;
  final Settings settings;

  MainScreen({this.firebaseUser, this.settings});

  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List _workoutData = [];  //All exercise data

  /* 
    fetchWorkoutData() async
    Author: Sophie(bolesalavb@gmail.com)
    Created Date & Time: JUne 9 2020 12:05 PM

    Function: fetchWorkoutData

    Description:  Using this function, Data related to 'workout' can be gotten from firebase. 
  */
  fetchWorkoutData() async {
    Firestore.instance.collection('workout').orderBy('workoutID').snapshots().listen((data) => {
      data.documents.forEach((doc) {
        _workoutData.add(doc);
      }),
      setState(() {
        _workoutData = _workoutData;
      }),
    });
  }

  @override
  void initState() {
    super.initState();
    fetchWorkoutData();
  
    print(widget.firebaseUser);
  }

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 2, 
      child: new Scaffold(
          key: _scaffoldKey,
          appBar: new AppBar(
            elevation: 0.5,
            leading: new IconButton(
                icon: new Icon(Icons.menu),
                onPressed: () => _scaffoldKey.currentState.openDrawer()),
            title: new Text(
              'Brave Fit',
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,  
                fontFamily: 'Xbka',
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('SHOP'),
                    ],
                  ),
                )
              ),
            ],
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                Container(
                  height: 130.0,
                  child: DrawerHeader(
                    decoration: BoxDecoration(
                      color: Color(0xFF85C1E9),
                    ),
                    child: Text(
                        'Brave Fit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,  
                          fontFamily: 'Xbka',
                        ),
                      ),
                  ),
                ),
                _signList(),
                ListTile(
                  leading: Icon(Icons.contacts),
                  title: _menuText('Profile'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                          settings: widget.settings,
                        )),
                    ); 
                    _scaffoldKey.currentState.openEndDrawer();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.brush),
                  title: _menuText('Activity'),
                  onTap: () {
                     Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ActivityScreen(
                          settings: widget.settings,
                        )),
                    ); 
                    _scaffoldKey.currentState.openEndDrawer();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.school),
                  title: _menuText('Learn'),
                  onTap: () {
                    // Navigator.pushNamed(context, '/totalworkouts');
                    _scaffoldKey.currentState.openEndDrawer();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: _menuText('Settings'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsScreen(
                        )),
                    ); 
                    // Navigator.pushNamed(context, '/settings');
                    _scaffoldKey.currentState.openEndDrawer();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.directions_railway),
                  title: _menuText('Follow Us'),
                  onTap: () {
                    // _scaffoldKey.currentState.openEndDrawer();
                  },
                ),
                ListTile(
                  title: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 20.0,
                      ),
                      _followUsBtn("facebook", "https://www.facebook.com/bravefitsoccer/"),
                      _followUsBtn("instagram", "https://www.instagram.com/braveboyjoy_/"),
                      _followUsBtn("youtube", "https://www.youtube.com/channel/UCSBiV37GBqxRVdjGM_f18Mw/"),
                    ],
                  ),
                  onTap: () {
                    _scaffoldKey.currentState.openEndDrawer();
                  },
                ),
              ],
            ),
          ),
          body: new TabBarView(children: [
            new SingleChildScrollView(
              child: new Stack(
                children: <Widget>[
                  new Center(
                    child: new Container(
                      color: Colors.white,
                      child: getWorkoutListWidgets(_workoutData),
                    ),
                  ),
                ]
              ),
            ),
            new Container(
              color: Colors.lightGreen,
            ),
          ]), 
          bottomNavigationBar: new TabBar(
            tabs: [
              Tab(
                icon: new Text("WORKOUTS"),
              ),
              Tab(
                icon: new Text("CHALLENGES"),
              ),
            ],
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: EdgeInsets.all(5.0),
            indicatorColor: Colors.black,
          ),
          backgroundColor: Colors.white,
        ),
      );
    
  }

  Widget _signList() {
    if (widget.firebaseUser == null) {
      return ListTile(
        leading: Icon(Icons.home),
        title: _menuText('To First Screen'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RootScreen(
                // settings: widget.settings,
              )),
          ); 
          _scaffoldKey.currentState.openEndDrawer();
        },
      );
    } else {
      return ListTile(
        leading: Icon(Icons.power_settings_new),
        title: _menuText('Sign Out'),
        onTap: () {
          _logOut();
          _scaffoldKey.currentState.openEndDrawer();
        },
      );
    }
  }

  /*
    Widget _followUsBtn(String icon, String url)
    Author: Sophie(bolesalavb@gmail.com)
    Created Date & Time:  Jun 7 2020 8:31 PM

    Widget: _followUsBtn

    Description:  Button for following social website such as facebook, instagram, and youtube

    Parameters: icon(String)  - social website name
                url(String)   - following link

    Return: Padding - 'Follow Us' Button
  */ 
  Widget _followUsBtn(String icon, String url) {
    return Padding(
      padding: EdgeInsets.only(left: 0.0),
      child: IconButton(
        icon: ImageIcon(
          AssetImage("assets/images/" + icon + ".png"),
          size: 30.0,
        ),
        tooltip: 'Increase volume by 10',
        onPressed: () {
          try { 
            launch(url);
          }  
          catch(e) { 
            print(e); 
          } 
        },
      )
    );
  }

  void _logOut() async {
    Auth.signOut();
  }

  /*
    Widget _menuText(String txt)
    Author: Sophie(bolesalavb@gmail.com)
    Created Date & Time: July 23 10:40 PM

    Widget _menuText

    Description: Text at menu

    Parameters: txt(String)  -  text of menu
  */
  Widget _menuText(String txt)
  {
    return Text(txt,
      style: TextStyle(
        fontSize: 19.0
      ),
    );
  }

  /*
    Widget getWorkoutListWidgets(List workout)
    Author: Sophie(bolesalavb@gmail.com)
    Created Date & Time:  June 9 2020 12:40 PM

    Widget: getWorkoutListWidgets

    Description:  List of Workouts

    Parameters: workout(List) - workout List(name,image, createdDate, & workoutID)
  */
  Widget getWorkoutListWidgets(List workout)
  {
    var now = new DateTime.now();

    List<Widget> list = new List<Widget>();
    if (workout != null) {
      for(var i = 0; i < workout.length; i++){
        list.add(
          InkWell(
            child: Stack(
              children: <Widget> [
                Padding(
                  padding: i == 0 
                    ? EdgeInsets.fromLTRB(15.0, 0, 15.0, 0)
                    : EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width - 30.0,
                      child: new Image.network(workout[i]['image'],
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 35,
                  bottom: 20,
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(new DateFormat.yMMMd('en_US').format(now),
                        style: TextStyle(color: Colors.white),
                      ),
                      new Text(workout[i]['name'].toUpperCase(),
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Preview(
                    settings: widget.settings,
                    id: workout[i]['workoutID'],
                    name: workout[i]['name'],
                    image: workout[i]['image'],
                  )),
              ); 
            },
          ),
        );
      }
    }
    return new Column(children: list);
  }
}
