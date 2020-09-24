import 'package:flutter/material.dart';
import 'package:fmg_remote_work_tracker/models/employee_location.dart';
import 'dart:core';

// Screen for displaying team information.

// Init empty lists to use for tracking and display information
List<String> teamList =  [];
List<String> teamName =  [];
List<String> teamAttendance =  [];
List<String> teamLocation =  [];
List<String> teamNumber =  [];

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

// Team Page state
class TeamPage extends StatefulWidget {
  @override
  EditText createState() => EditText();
}
class EditText extends State<TeamPage> {
  bool _isEditingText = false;
  TextEditingController _editingController;
//  String initialText = "Initial Text";
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
//    int counter = 0;
    if (_isEditingText)
      return Center(
        child: TextField(
//          onChanged: (test) => {"newText"},
          onSubmitted: (newValue){
//            initialText = teamName[nameNumber];
            teamLocation[nameNumber] = newValue;
            setState(() {
//              initialText = newValue; // Sets value to whatever is typed
              _isEditingText =false;
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
                onPressed: () {
                  // Update nameNumber so we know which person to update
                  nameNumber = index;
                  // Set the text value that appears to be equal to the current name.
                  _editingController.text = teamLocation[nameNumber]; // THIS WAS SOMETIMES CAUSING ERRORS. IDK WHY.
                  setState(() {
                    _isEditingText = true;
                  });
                  print(teamName[index]+" "+teamAttendance[index]+" "+teamLocation[index]+" counter is at: "+nameNumber.toString());
                  },
              ),
            ]),
          );
        }),
      ),
    );
  }
}
















