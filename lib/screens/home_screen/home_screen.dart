import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fmg_remote_work_tracker/data/login_info.dart';
import 'package:fmg_remote_work_tracker/data/user_details.dart';
import 'package:fmg_remote_work_tracker/screens/home_screen/manage_defaults.dart';
import 'package:fmg_remote_work_tracker/screens/list_screen/absent_options_list_screen.dart';
import 'package:fmg_remote_work_tracker/screens/list_screen/office_list_screen.dart';
import 'package:fmg_remote_work_tracker/screens/login_screen/login_screen.dart';
import 'package:fmg_remote_work_tracker/screens/profile_screen/profile_screen.dart';
import 'package:fmg_remote_work_tracker/screens/schedule_future_screen/schedule_future_screen.dart';
import 'package:fmg_remote_work_tracker/screens/team_screen/team_screen.dart';
import 'package:fmg_remote_work_tracker/server_interaction/basic_interaction.dart';
import 'package:fmg_remote_work_tracker/server_interaction/push_notifications.dart';
import 'package:fmg_remote_work_tracker/models/employee_location.dart';
import 'package:fmg_remote_work_tracker/components/buttons.dart';
import 'location_display.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  Future<EmployeeLocation> _location;
  Future<EmployeeAtOffice> defaultOfficeFuture;
  Future<EmployeeAbsent> defaultAbsenceFuture;
  Future<DateTime> dateOfInterestFuture;

  EmployeeAtOffice selectedOfficeLocation;
  EmployeeAbsent selectedAbsenceType;

  StreamSubscription dateListener;
  StreamSubscription locationListener;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    defaultAbsenceFuture = getDefaultAbsence();
    defaultOfficeFuture = getDefaultOffice();

    _location = getLocation();
    dateOfInterestFuture = getDateOfInterest();

    // listen to date stream for push data messages
    dateListener = relevantDateStream.listen((date) {
      setState(() {
        dateOfInterestFuture = Future.value(date);
      });
    });

    // listen to employee location stream for push data messages
    locationListener = employeeLocationStream.listen((employeeLocation) {
      setState(() {
        _location = Future.value(employeeLocation);
      });
    });
  }

  // recheck location and date on resume
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed){
      setState(() {
        _location = getLocation();
        dateOfInterestFuture = getDateOfInterest();
      });
    }
  }

  @override
  void dispose() {
    locationListener.cancel();
    dateListener.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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
            leading: Icon(Icons.account_circle),
            title: Text('Profile'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                            employee: user,
                          )));
            },
          ),
          ListTile(
            leading: Icon(Icons.location_city),
            title: Text("Change Default Office Location"),
            subtitle: defaultOffice.additionalInfo == null
                ? Text(defaultOffice.officeLocation)
                : Text(defaultOffice.officeLocation +
                    " - " +
                    defaultOffice.additionalInfo),
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
            subtitle: defaultAbsence.additionalInfo == null
                ? Text(defaultAbsence.absenceType.asString())
                : Text(defaultAbsence.absenceType.asString() +
                    " - " +
                    defaultAbsence.additionalInfo),
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

  Widget _getTeamScreenButton({@required EmployeeAtOffice defaultOffice,
  @required EmployeeAbsent defaultAbsence}) {
    if (user.manager) {
      return _expandedRow(children: [
        LargeButton(
          child: Row(children: [
            Expanded(
              child: Center(child: Text("My Team")),
            ),
            Icon(Icons.people),
          ]),
          callback: () {
            Navigator.push(context, MaterialPageRoute( builder: (context) {
              return TeamPage(defaultOffice: defaultOffice, defaultAbsence: defaultAbsence,);
            }));
          },
        ),
      ]);
    } else {
      return SizedBox();
    }
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
            date: dateOfInterestFuture,
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
          _getTeamScreenButton(defaultAbsence: defaultAbsence, defaultOffice: defaultOffice),
          _expandedRow(children: [
            LargeButton(
                child: Row(children: [
                  Expanded(
                    child: Center(child: Text("Schedule Future Locations")),
                  ),
                  Icon(Icons.date_range),
                ]),
                callback: () {
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                    return ScheduleFutureScreen(
                      defaultAbsence: defaultAbsence,
                      defaultOffice: defaultOffice,
                      dateOfInterestFuture: dateOfInterestFuture
                    );
                  }));
                }),
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
