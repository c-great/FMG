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

  void _updateLocation(EmployeeLocation employeeLocation) {
    setLocation(employeeLocation);
    this._location = getLocation();
    setState(() {});
  }

  void _changeToOffice({OfficeLocation office, String additionalInfo}) {
    EmployeeLocation location = EmployeeAtOffice(
      officeLocation: office,
      additionalInfo: additionalInfo,
    );
    _updateLocation(location);
  }

  void _changeToHome() {
    EmployeeLocation location = EmployeeAtHome();
    _updateLocation(location);
  }

  void _changeToAbsent({AbsentOptions absentType, String additionalInfo}) {
    EmployeeLocation location = EmployeeAbsent(
      absentOptions: absentType,
      additionalInfo: additionalInfo,
    );
    _updateLocation(location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            // TODO: make button open an settings menu
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
          Wrap(runSpacing: 10, children: <Widget>[
            selectLocationText(_location),
            LargeButton(title: "Office", callback: _changeToOffice),
            LargeButton(
              title: "Home",
              callback: _changeToHome,
            ),
            // TODO: Implement this properly
            LargeButton(
              title: "Absent Options",
              callback: _changeToAbsent,
            ),
          ]),
          Spacer(),
          // TODO: Implement this
          LargeButton(title: "Schedule Future Locations"),
        ],
      ),
    );
  }
}

Widget selectLocationText(EmployeeLocation location) {
  String text;
  if (location.location == Location.UNDEFINED)
    text = "Choose your location:";
  else
    text = "Change your location:";

  return Align(child: Text(text,), alignment: Alignment.bottomLeft);
}
