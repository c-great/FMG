import 'package:flutter/material.dart';
import 'package:fmg_remote_work_tracker/data/login_info.dart';
import 'package:fmg_remote_work_tracker/data/user_details.dart';
import 'package:fmg_remote_work_tracker/screens/home_screen/manage_defaults.dart';
import 'package:fmg_remote_work_tracker/screens/list_screen/absent_options_list_screen.dart';
import 'package:fmg_remote_work_tracker/screens/list_screen/office_list_screen.dart';
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

  Future<EmployeeAtOffice> defaultOfficeFuture;
  Future<EmployeeAbsent> defaultAbsenceFuture;

  EmployeeAtOffice selectedOfficeLocation;
  EmployeeAbsent selectedAbsenceType;

  @override
  void initState() {
    super.initState();

    defaultAbsenceFuture = getDefaultAbsence();
    defaultOfficeFuture = getDefaultOffice();
  }

  Future<void> _updateLocation(EmployeeLocation employeeLocation) async {
    if (await setLocation(employeeLocation)) {
      setState(() {
        this._location = getLocation();
      });
    }
  }

  void _changeToOffice({String office, String additionalInfo}) {
    _updateLocation(selectedOfficeLocation);
  }

  void _changeToHome() {
    EmployeeLocation location = EmployeeAtHome();
    _updateLocation(location);
  }

  void _changeToAbsent() {
    _updateLocation(selectedAbsenceType);
  }

  Drawer _getDrawer(BuildContext context, EmployeeAtOffice defaultOffice,
      EmployeeAbsent defaultAbsence) {
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
          ListTile(
            leading: Icon(Icons.location_city),
            title: Text("Change Default Office Location"),
            subtitle: Text(defaultOffice.officeLocation),
            onTap: () async {
              final result = await Navigator.push(
                context,
                // Create the SelectionScreen in the next step.
                MaterialPageRoute(builder: (context) => OfficeListScreen()),
              );
              if (result != null) {
                setDefaultOffice(result);
                setState(() {
                  defaultOfficeFuture = Future.value(result);
                  defaultOffice = result;
                });
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.beach_access),
            title: Text("Change Default Absence Type"),
            subtitle: Text(defaultAbsence.absenceType.asString()),
            onTap: () async {
              final result = await Navigator.push(
                context,
                // Create the SelectionScreen in the next step.
                MaterialPageRoute(
                    builder: (context) => AbsenceTypeListScreen()),
              );
              if (result != null) {
                setDefaultAbsence(result);
                setState(() {
                  defaultAbsenceFuture = Future.value(result);
                  defaultAbsence = result;
                });
              }
            },
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

  Widget _expandedRow({List<Widget> children}) {
    var expandedChildren = children.map((e) => Expanded(
          child: e,
        ));
    return Flexible(
      fit: FlexFit.tight,
      flex: 1,
      child: Row(
        children: expandedChildren.toList(),
      ),
    );
  }

  Scaffold _getMainScaffold(BuildContext context,
      EmployeeAtOffice defaultOffice, EmployeeAbsent defaultAbsence) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[],
      ),
      endDrawer: _getDrawer(context, defaultOffice, defaultAbsence),
      body: Column(
        children: [
          RecordedLocationDisplay(
            location: _location,
            date: getDateOfInterest(),
          ),
          selectLocationText(_location),
          _expandedRow(children: [
            OfficeSelectButton(
              starting: selectedOfficeLocation,
              update: (newOfficeSelected) {
                selectedOfficeLocation = newOfficeSelected;
              },
            ),
            LargeButton(
                child: Row(children: [
                  Expanded(
                    child: Center(child: Text("Office")),
                  ),
                  Icon(Icons.location_city),
                ]),
                callback: _changeToOffice),
          ]),
          _expandedRow(children: [
            SizedBox(),
            LargeButton(
              child: Row(children: [
                Expanded(
                  child: Center(child: Text("Home")),
                ),
                Icon(Icons.home),
              ]),
              callback: _changeToHome,
            ),
          ]),
          _expandedRow(children: [
            AbsenceTypeSelectButton(
              starting: selectedAbsenceType,
              update: (newAbsenceSelected) {
                selectedAbsenceType = newAbsenceSelected;
              },
            ),
            LargeButton(
              child: Row(children: [
                Expanded(
                  child: Center(child: Text("Absent")),
                ),
                Icon(Icons.beach_access),
              ]),
              callback: _changeToAbsent,
            ),
          ]),
          Spacer(
            flex: 1,
          ),
          _expandedRow(children: [
            LargeButton(
              // TODO: Only show up if you're a manager?
              child: Row(children: [
                Expanded(
                  child: Center(child: Text("My Team")),
                ),
                Icon(Icons.people),
              ]),
              callback: () {
                Navigator.pushNamed(context, '/TeamScreen');
              },
            ),
          ]),
          _expandedRow(children: [
            LargeButton(
              child: Row(children: [
                Expanded(
                  child: Center(child: Text("Schedule Future Locations")),
                ),
                Icon(Icons.date_range),
              ]),
            ),
          ])
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // this FutureBuilder is used to wait for the default values to be loaded
    return FutureBuilder<List>(
        future: Future.wait([defaultOfficeFuture, defaultAbsenceFuture]),
        // stream data to listen for change
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var defaultOffice = snapshot.data[0];
            var defaultAbsence = snapshot.data[1];

            if (selectedOfficeLocation == null) {
              selectedOfficeLocation = defaultOffice;
            }
            if (selectedAbsenceType == null) {
              selectedAbsenceType = defaultAbsence;
            }
            return _getMainScaffold(context, defaultOffice, defaultAbsence);
          } else {
            // just get a progress indicator if they have not loaded
            return Center(child: CircularProgressIndicator());
          }
        });
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
