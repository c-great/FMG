import 'package:flutter/material.dart';
import 'package:fmg_remote_work_tracker/database_interaction/basic_interaction.dart';
import 'package:fmg_remote_work_tracker/models/employee_location.dart';
import 'package:fmg_remote_work_tracker/components/buttons.dart';
import 'location_display.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  EmployeeLocation _location = getLocation();

  void _changeLocation(
      Location location,
      {String additional1, String additional2}) {
    setLocation(EmployeeLocation(
        location: location,
        additionalInfo1: additional1,
        additionalInfo2: additional2));
    this._location = getLocation();
    setState(() {});
  }

  void _changeToOffice({String office}) {
    _changeLocation(Location.OFFICE, additional1: office);
  }

  void _changeToHome() {
    _changeLocation(Location.HOME);
  }

  void _changeToAbsent({String absentType, String additional}) {
    _changeLocation(
        Location.ABSENT,
        additional1: absentType,
        additional2: additional);
  }

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
          RecordedLocationDisplay(
              location: _location,
              date: getDateOfInterest(),
          ),
          LargeButton(title: "Office", callback: _changeToOffice),
          LargeButton(title: "Home", callback: _changeToHome,),
          LargeButton(title: "Absent Options", callback: _changeToAbsent,),
        ],
      ),
    );
  }
}
