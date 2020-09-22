import 'package:flutter/material.dart';
import 'package:onboarding_flow/ui/screens/main_screen.dart';
import 'package:onboarding_flow/models/settings.dart';


class ProfileScreen extends StatefulWidget {
  final Settings settings;

  ProfileScreen({this.settings});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String sex = '';
  String h1 = '';
  String h2 = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MainScreen(
                  settings: widget.settings,
                )),
            )),
        title: Text(
          'PROFILE',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'HEALTH',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          ListTile(
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey,
                ),
              ),
              child: Icon(
                Icons.favorite,
                color: Colors.red,
              ),
            ),
            title: Text(
              'Connect to Apple Health',
            ),
            subtitle: Text(
              'Pre-fill your profile and track your workouts on Apple Health for morerobust health tracking.',
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(80, 8, 0, 8),
            child: Text(
              'Connect',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Text(
              'PERSONAL',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey,
                ),
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '  Name',
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey,
                ),
              ),
              child: DropdownButton<String>(
                elevation: 0,
                isExpanded: true,
                underline: Divider(
                  color: Colors.transparent,
                  thickness: 0,
                ),
                items: <String>[
                  'Male',
                  'Female',
                ].map((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Column(
                      children: <Widget>[
                        Text(value),
                        Divider(
                          color: Theme.of(context).primaryColor,
                          thickness: 1,
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    sex = value;
                  });
                },
                hint: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(sex),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey,
                ),
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '  Age',
                ),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey,
                      ),
                    ),
                    child: DropdownButton<String>(
                      elevation: 0,
                      isExpanded: true,
                      underline: Divider(
                        color: Colors.transparent,
                        thickness: 0,
                      ),
                      items: <String>[
                        '0\'',
                        '1\'',
                        '2\'',
                        '3\'',
                        '4\'',
                        '5\'',
                        '6\'',
                        '7\'',
                        '8\'',
                        '9\'',
                      ].map((value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Column(
                            children: <Widget>[
                              Text(value),
                              Divider(
                                color: Theme.of(context).primaryColor,
                                thickness: 1,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          h1 = value;
                        });
                      },
                      hint: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(h1),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey,
                      ),
                    ),
                    child: DropdownButton<String>(
                      elevation: 0,
                      isExpanded: true,
                      underline: Divider(
                        color: Colors.transparent,
                        thickness: 0,
                      ),
                      items: <String>[
                        '0\'\'',
                        '1\'\'',
                        '2\'\'',
                        '3\'\'',
                        '4\'\'',
                        '5\'\'',
                        '6\'\'',
                        '7\'\'',
                        '8\'\'',
                        '9\'\'',
                      ].map((value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Column(
                            children: <Widget>[
                              Text(value),
                              Divider(
                                color: Theme.of(context).primaryColor,
                                thickness: 1,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          h2 = value;
                        });
                      },
                      hint: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(h2),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey,
                ),
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '  Weight 123lb',
                ),
              ),
            ),

          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              
              decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '  prepaid4ever@yahoo.com',
                    ),
                  ),
            ),
          ),
           Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Text(
              'CHANGE PASSWORD',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              
              decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '  New Password',
                    ),
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              
              decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '  Repeat Password',
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
