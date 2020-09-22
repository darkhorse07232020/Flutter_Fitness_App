import 'package:flutter/material.dart';
import 'package:onboarding_flow/ui/screens/settings_screen.dart';
import "package:onboarding_flow/ui/screens/walk_screen.dart";
import 'package:onboarding_flow/ui/screens/root_screen.dart';
import 'package:onboarding_flow/ui/screens/sign_in_screen.dart';
import 'package:onboarding_flow/ui/screens/sign_up_screen.dart';
import 'package:onboarding_flow/ui/screens/main_screen.dart';
import 'package:onboarding_flow/ui/screens/preview_screen.dart';
import 'package:onboarding_flow/ui/screens/exercise_screen.dart';
import 'package:onboarding_flow/ui/screens/inout.dart';
import 'package:onboarding_flow/ui/screens/report_screen.dart';
import 'package:onboarding_flow/ui/screens/reset_password_screen.dart';
import 'package:onboarding_flow/ui/screens/ready_screen.dart';
import 'package:onboarding_flow/ui/screens/video_screen.dart';
import 'package:onboarding_flow/ui/screens/activity.dart';
import 'package:onboarding_flow/ui/screens/insideoutside.dart';
import 'package:onboarding_flow/ui/screens/nascarresults.dart';
import 'package:onboarding_flow/ui/screens/profile.dart';
import 'package:onboarding_flow/ui/screens/totalworkouts.dart';
// import 'package:onboarding_flow/ui/screens/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firestore.instance.settings(persistenceEnabled: true);
  // Firestore.instance.settings(timestampsInSnapshotsEnabled: true);
  SharedPreferences.getInstance().then((prefs) {
    runApp(MyApp(prefs: prefs));
  });
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  MyApp({this.prefs});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/walkthrough': (BuildContext context) => new WalkthroughScreen(),
        '/root': (BuildContext context) => new RootScreen(),
        '/signin': (BuildContext context) => new SignInScreen(),
        '/signup': (BuildContext context) => new SignUpScreen(),
        '/main': (BuildContext context) => new MainScreen(),
        '/preview': (BuildContext context) => new Preview(),
        '/exercise': (BuildContext context) => new Exercise(),
        '/report': (BuildContext context) => new Report(),
        '/resetpassword': (BuildContext context) => new ResetPassword(),
        '/ready': (BuildContext context) => new Ready(),
        '/settings': (BuildContext context) => new SettingsScreen(),
        '/video': (BuildContext context) => new VideoPlayerScreen(),
        '/activity': (BuildContext context) => new ActivityScreen(),
        '/insideoutside': (BuildContext context) => new InsideOutside(),
        '/nascarresults': (BuildContext context) => new NascarResultsScreen(),
        '/profile': (BuildContext context) => new ProfileScreen(),
        '/totalworkouts': (BuildContext context) => new TotalWorkouts(),
        '/inout': (BuildContext context) => new InOut(),
      },
      theme: ThemeData(
        primaryColor: Colors.white,
        // primarySwatch: Colors.grey,
        primarySwatch: Colors.green,
        accentColor: Colors.white,
      ),
      home: _handleCurrentScreen(),
    );
  }

  Widget _handleCurrentScreen() {
    // bool seen = (prefs.getBool('seen') ?? false);
    // if (true) {
      return new RootScreen();
    // } else {
    //   return new WalkthroughScreen(prefs: prefs);
    // }
  }
}
