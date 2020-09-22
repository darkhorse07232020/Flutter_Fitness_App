import 'package:flutter/material.dart';
// import 'package:fit_kit/fit_kit.dart';
import 'package:onboarding_flow/models/settings.dart';
import 'package:onboarding_flow/ui/screens/main_screen.dart';

class Report extends StatefulWidget {
  Settings settings;
  
  Report({this.settings});
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  // void read() async {
  //   final results = await FitKit.read(
  //     DataType.HEART_RATE,
  //     dateFrom: DateTime.now().subtract(Duration(days: 5)),
  //     dateTo: DateTime.now(),
  //   );
  //   print(results);
  // }

  AppBar appBar = AppBar(
    automaticallyImplyLeading: false,
    centerTitle: true,
    title: new Text("NASCAR Results",
      style: TextStyle(
        fontSize: 24.0,
      ),
    ),
  );

  TextStyle tableStyle = TextStyle(
    fontSize: 20.0,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // read();
    return new Scaffold(
      appBar: appBar,
      body: new Column(
        children: <Widget>[
          new Container(
            padding: EdgeInsets.fromLTRB(30.0, 50.0, 30.0, 0),
            child: new Table(
              border: TableBorder.all(
                  color: Colors.black26, width: 1, style: BorderStyle.none),
              children: [
                TableRow(children: [
                  TableCell(child: Center(child: _tableCell('Burpees'))),
                  TableCell(child: Center(child: _tableCell('35 reps'))),
                ]),
                TableRow(children: [
                  TableCell(child: Center(child: _tableCell('High Knees'))),
                  TableCell(child: Center(child: _tableCell('12 reps'))),
                ]),
                TableRow(children: [
                  TableCell(child: Center(child: _tableCell('Skaters'))),
                  TableCell(child: Center(child: _tableCell('22 reps'))),
                ]),
                TableRow(children: [
                  TableCell(child: Center(child: _tableCell('Squats'))),
                  TableCell(child: Center(child: _tableCell('24 reps'))),
                ]),
              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Container(
                height: 500.0,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    _timeContainer(),
                    new Container(
                      height: 80.0,
                      child: new Row(
                        children: <Widget>[
                          _expandedBtn("FINISH", Colors.black, "/main"),
                          _expandedBtn("SHARE", Colors.green, "#"),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableCell(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: tableStyle,
      )
    );
  }

  Widget _expandedBtn(String text, Color color, String url) {
    return Expanded(
      flex: 5,
      child: InkWell(
        child: Container(
          height: 80.0,
          color: color,
          child: Center(
            child: Text(text,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        onTap: () {
          switch (url) {
            case "/main":
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainScreen(
                    settings: widget.settings,
                  )),
              );
              break;
            default:
          }
        },
      ),
    );
  }

  Widget _timeContainer() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(40.0),
        child: Column(
          children: <Widget>[
            Text("27:50",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 80.0,
              ),
            ),
            Text("Workout Time",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
