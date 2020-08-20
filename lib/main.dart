import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

void main() {
  // ensure all dates are formatted for NZ
  initializeDateFormatting('en_NZ', null).then((_) => runApp(FmgApp()));
}

class FmgApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FMG Remote Work Tracker App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(title: 'FMG - Remote Work Tracker'),
    );
  }
}

enum Location {
  OFFICE, HOME, ABSENT, UNDEFINED
}

class EmployeeLocation {
  Location location;
  String additionalInfo;

  EmployeeLocation({this.location, this.additionalInfo});
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  EmployeeLocation _location = EmployeeLocation(location: Location.UNDEFINED);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            // TODO: make button open an options menu
            onPressed: null,
          )
        ],
      ),
      body: Column(
        children: [
          RecordedLocationDisplay(location: _location, date: DateTime.now()),
          HomePageButton(title: "Office"),
          HomePageButton(title: "Home"),
          HomePageButton(title: "Absent Options"),
        ],
      ),
    );
  }
}

class RecordedLocationDisplay extends StatelessWidget {
  final EmployeeLocation location;
  final DateTime date;

  RecordedLocationDisplay({this.location, this.date});

  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        Text(
            "Your recorded location for TODAY ("
            + new DateFormat.MMMMEEEEd().format(date)
            + ") is:"
        ),
        Text("Recorded Location Data")
      ],
    );
  }

}

class HomePageButton extends StatelessWidget {
  final String title;

  HomePageButton({this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
        child: RaisedButton(
          // TODO: do something when pressed, should be provided to constructor
          onPressed: null,
          child: Text(this.title),
      )
    );
  }

}
