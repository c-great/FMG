import 'package:flutter/material.dart';
import 'package:fmg_remote_work_tracker/data/login_info.dart';
import 'package:fmg_remote_work_tracker/data/user_details.dart';
import 'package:fmg_remote_work_tracker/screens/login_screen/login_screen.dart';
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

  Drawer _getDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Text(
              "Signed in as:\n"
              "${user.lastName}, ${user.firstName}",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.message),
            title: Text('Messages'),
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Profile'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.power_settings_new),
            title: Text('Sign Out'),
            onTap: () {
              LoginInfo.clear();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        LoginScreen(title: 'FMG - Remote Work Tracker')),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
        ],
      ),
      endDrawer: _getDrawer(context),
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
