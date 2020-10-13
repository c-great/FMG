import 'package:flutter/material.dart';
import 'package:fmg_remote_work_tracker/models/employee.dart';
import 'package:fmg_remote_work_tracker/models/employee_location.dart';
import 'package:fmg_remote_work_tracker/screens/home_screen/manage_defaults.dart';
import 'dart:core';

import 'package:fmg_remote_work_tracker/screens/list_screen/team_edit_options_list.dart';
import 'package:fmg_remote_work_tracker/screens/schedule_future_screen/future_location_dialog.dart';
import 'package:fmg_remote_work_tracker/screens/schedule_future_screen/schedule_future_screen.dart';
import 'package:fmg_remote_work_tracker/server_interaction/basic_interaction.dart';
import 'package:fmg_remote_work_tracker/theme/style.dart';

import 'employee_cards.dart';

// fixme: Clean up all the useless comments when done. Most likely also the Team class itself
// Screen for displaying team information.

// Init empty lists to use for tracking and display information
List<String> teamList = [];
List<String> teamName = [];
List<String> teamAttendance = [];
List<String> teamLocation = [];
List<String> teamNumber = [];
String chosenEdit;
// Inits so we can use variables from Future functions outside of Future functions.
List<Employee> teamMembers = [];
Location thisMemberLocation;
EmployeeLocation thisMemberEmployeeLocation;
EmployeeAbsent thisMemberAbsent = new EmployeeAbsent();
EmployeeAtOffice thisMemberOffice = new EmployeeAtOffice();

class Team {
  //extends EmployeeInfo
  String name, attendance, location, team;

  Team(this.name, this.attendance, this.location, this.team) {
    teamList.add(name + "," + attendance + "," + location + "," + team);
    teamName.add(name);
    teamAttendance.add(attendance);
    teamLocation.add(location);
    teamNumber.add(team);
  }

  // So that teamList addition in the constructor actually get added
  void callConstructor() {
//    matchTeam();
  }
}

// Temporary names for testing team screen
Team jim = new Team("Jim", "Other", "Wellington", "Team1");
Team carl = new Team("Carl", "Working", "Remotely", "Team1");
Team tim = new Team("Tim", "Other", "NA", "Team2");
Team kim = new Team("Kim", "Absent", "NA", "Team2");

// Must be called from a widget build/elsewhere so Team class members are added to lists.
void initTeam() {
  jim.callConstructor();
  carl.callConstructor();
  tim.callConstructor();
  kim.callConstructor();
}

// Purpose is to return the value the user wants to edit. e.g. Attendance or Location
_navigateTeamEditOptionsScreen(BuildContext context) async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => TeamEditOptionsScreen()),
  );
  chosenEdit = ('$result');
  print(chosenEdit);
}

// Gets the location (actually attendance) of an individual by ID. And the office.
void getMemberLocation(String id) async {
  var _location = await getLocationFromID(id);
  try {
    thisMemberOffice = _location;
  } catch (e) {
    print(e);
    thisMemberOffice.officeLocation = "No Office";
  }
  try {
    thisMemberAbsent = _location;
  } catch (e1) {
    print(e1);
//    thisMemberAbsent = _location;
  }
  thisMemberLocation = _location.location;
  thisMemberEmployeeLocation = _location;
}

// Initialise all team members.
void initTeamMembers() async {
  thisMemberAbsent = await getDefaultAbsence();
  thisMemberOffice = await getDefaultOffice(); //.officeLocation = "No Office";
  List<Employee> getTeam = await getDirectReports();
  teamMembers = getTeam;
}

class TeamPage extends StatefulWidget {
  @override
  _TeamPageState createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  bool _isEditingLocation = false;
  bool _isEditingAttendance = false;
  TextEditingController _editingController;

  // Used for when changing values within the team lists
  int nameNumber = 0;

  Future<List<Employee>> reportingEmployeesFuture;
  Future<Map<String, EmployeeLocation>> reportingEmployeeLocationsFuture;

  @override
  void initState() {
    super.initState();
    reportingEmployeesFuture = getDirectReports();
    reportingEmployeeLocationsFuture = getDirectReportLocations();

    _editingController = TextEditingController(text: "InitialText");
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Manager View"),
        ),
        body: FutureBuilder(
          future: Future.wait(
              [reportingEmployeesFuture, reportingEmployeeLocationsFuture]),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              List<Employee> reportingEmployees = snapshot.data[0];
              Map<String, EmployeeLocation> reportingEmployeeLocations =
                  snapshot.data[1];

              List<Widget> employeeCards = createEmployeeCards(
                  context,
                  reportingEmployees,
                  reportingEmployeeLocations);

              return ListView(
                children: employeeCards,
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }

  Widget _editTitleTextField() {
    if (_isEditingLocation)
      return Center(
        child: TextField(
          onSubmitted: (newValue) {
            teamLocation[nameNumber] = newValue;
            setState(() {
              _isEditingLocation = false;
            });
          },
          autofocus: true,
          controller: _editingController,
        ),
      );
    if (_isEditingAttendance)
      return Center(
        child: TextField(
          onSubmitted: (newValue) {
            teamAttendance[nameNumber] = newValue;
            setState(() {
              _isEditingAttendance = false;
            });
          },
          autofocus: true,
          controller: _editingController,
        ),
      );
    return Scaffold(
      appBar: AppBar(
        title: Text("My Team"),
      ),
      body: Column(
        // Generate widgets that display a team member name, attendance and location.
        children: List.generate(teamMembers.length, (index) {
          getMemberLocation(teamMembers[index].employeeID);
          var firstName = teamMembers[index].firstName;
          var attendance = thisMemberLocation.asString();
          var location = thisMemberOffice.officeLocation;
          return SizedBox(
            width: double.infinity,
            height: 50,
            child: Wrap(runSpacing: 10, children: <Widget>[
              RaisedButton(
                child: Row(children: <Widget>[
                  Expanded(child: Text('$firstName, $attendance, $location'))
                ]),
                onPressed: () async {
                  // Dialog box for changing a specific members information. Returns new info when finished
                  final result = await showDialog(
                    context: context,
                    builder: (BuildContext context) => editLocationDialog(
                        context,
                        teamMembers[index].employeeID,
                        thisMemberAbsent,
                        thisMemberOffice,
                        thisMemberEmployeeLocation),
                  );
                  if (result != null) {
                    await setLocationFromID(
                        result,
                        teamMembers[index]
                            .employeeID); //Manual setLocationFromID(result, "1984") does update nmckubre as it should
                    print("should set location of: " +
                        teamMembers[index].employeeID);
                  }
//                    if (result is EmployeeAtOffice) {
//                      print("office");
//                    } else if (result is EmployeeAbsent) {
//                      print("absent");
//                    } else if (result is EmployeeAtHome) {
//                      print("home");
//                    }
                },
              ),
            ]),
          );
        }),
      ),
    );
  }
}


