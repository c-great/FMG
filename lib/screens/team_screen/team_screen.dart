import 'package:flutter/material.dart';
import 'package:fmg_remote_work_tracker/models/employee_location.dart';
import 'dart:core';

import 'package:fmg_remote_work_tracker/screens/list_screen/team_edit_options_list.dart';
// fixme: Clean up all the useless comments when done.
// Screen for displaying team information.

// Init empty lists to use for tracking and display information
List<String> teamList =  [];
List<String> teamName =  [];
List<String> teamAttendance =  [];
List<String> teamLocation =  [];
List<String> teamNumber =  [];
String chosenEdit;

class Team { //extends EmployeeInfo
  String name, attendance, location, team;
  Team(this.name, this.attendance, this.location, this.team) {
    matchTeam();
    teamList.add(name+","+attendance+","+location+","+team);
    teamName.add(name);
    teamAttendance.add(attendance);
    teamLocation.add(location);
    teamNumber.add(team);
  }

  void matchTeam() {
    if (team == "Team1") {
//      print("Team1");
    } else if (team == "Team2") {
//      print("Team2");
    } else {
//      print("NotEqual");
    }
  }
  // So that teamList addition in the constructor actually get added
  void callConstructor() {
//    matchTeam();
  }
}
// Temporary names for testing team screen
Team jim = new Team("Jim","Other","Wellington","Team1");
Team carl = new Team("Carl","Working","Remotely","Team1");
Team tim = new Team("Tim","Other","NA","Team2");
Team kim = new Team("Kim","Absent","NA","Team2");

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

// Team Page state
class TeamPage extends StatefulWidget {
  @override
  EditText createState() => EditText();
}
class EditText extends State<TeamPage> {
  bool _isEditingLocation = false;
  bool _isEditingAttendance = false;
  TextEditingController _editingController;
  // Used for when changing values within the team lists
  int nameNumber = 0;
  @override
  void initState() {
    super.initState();
    _editingController = TextEditingController(text: "InitialText");
  }
  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  initTeam();
    return Scaffold(
//      appBar: AppBar(
//        title: Text("Editable Text"),
//      ),
      body: Center(
        child: _editTitleTextField(),
      ),
    );
  }

  Widget _editTitleTextField() {
    if (_isEditingLocation)
      return Center(
        child: TextField(
          onSubmitted: (newValue){
            teamLocation[nameNumber] = newValue;
            setState(() {
              _isEditingLocation =false;
            });
          },
          autofocus: true,
          controller: _editingController,
        ),
      );
    if (_isEditingAttendance)
      return Center(
        child: TextField(
          onSubmitted: (newValue){
            teamAttendance[nameNumber] = newValue;
            setState(() {
              _isEditingAttendance =false;
            });
          },
          autofocus: true,
          controller: _editingController,
        ),
      );
    return Scaffold(
      appBar: AppBar(
        title: Text("My Teams"),
      ),
      body: Column ( //GridView.count
        // Generate widgets that display a team member name, attendance and location.
        children: List.generate(teamName.length, (index) {
          var name = teamName[index];
          var attendance = teamAttendance[index];
          var location = teamLocation[index];
          var number = teamNumber[index];
          return SizedBox(
            width: double.infinity,
            height: 50,
            child: Wrap(runSpacing: 10, children: <Widget>[
              RaisedButton(
                child: Row(children: <Widget>[
                  Expanded(child: Text('$name , $attendance , $location'))
                ]),
                onPressed: () async {
                  // Update nameNumber so we know which person to update
                  nameNumber = index;
                  // Path to attendance/location options, the choice is returned as result.
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TeamEditOptionsScreen()),
                  );
                    if (result == "Attendance") {
                      // Set the shown text to what it is currently. Then start editing.
                      _editingController.text = teamAttendance[nameNumber];
                      setState(() {
                        _isEditingAttendance = true;
                      });
                    } else if (result == "Location") {
                      _editingController.text = teamLocation[nameNumber];
                      setState(() {
                        _isEditingLocation = true;
                      });
                    }
                  },
              ),
            ]),
          );
        }),
      ),
    );
  }
}
















