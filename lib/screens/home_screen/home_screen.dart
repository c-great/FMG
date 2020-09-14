import 'package:flutter/material.dart';
import 'package:fmg_remote_work_tracker/server_interaction/basic_interaction.dart';
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
  Future<EmployeeLocation> _location = getLocation();

  Future<void> _updateLocation(EmployeeLocation employeeLocation) async {
    if (await setLocation(employeeLocation)) {
      this._location = getLocation();
      setState(() {});
    }
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
      absenceType: absentType,
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
            LargeButton(
                child: Row(children: <Widget>[
                  Expanded(child: OfficeDropDownButton()),
                  Expanded(child: Text("Office")),
                ]),
                callback: _changeToOffice),
            LargeButton(
              child: Text("Home"),
              callback: _changeToHome,
            ),
            // TODO: Implement this properly
            LargeButton(
              child: Text("Absent Options"),
              callback: _changeToAbsent,
            ),
            RaisedButton( // Will be changed to large button
              child: Text("My Teams"),
              onPressed: () {
                Navigator.pushNamed(context, '/TeamScreen');
              },
            )
          ]),
          Spacer(),
          // TODO: Implement this
          LargeButton(child: Text("Schedule Future Locations")),
        ],
      ),
    );
  }
}

Widget selectLocationText(Future<EmployeeLocation> location) {
  return FutureBuilder<EmployeeLocation>(
    future: location,
    builder: (context, snapshot) {
      String text;
      if (snapshot.hasData) {
        if (snapshot.data.location == Location.UNDEFINED)
          text = "Choose your location:";
        else
          text = "Change your location:";
      } else {
        text = "";
      }
      return Align(
          child: Text(
            text,
          ),
          alignment: Alignment.bottomLeft);
    },
  );
}
