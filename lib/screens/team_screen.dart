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

  void callConstructor() {
//    matchTeam();
  }
}
// Temporary names for testing team screen
Team jim = new Team("Jim","Other","Wellington","Team1");
Team carl = new Team("Carl","Working","Remotely","Team1");
Team tim = new Team("Tim","Other","NA","Team2");
Team kim = new Team("Kim","Absent","NA","Team2");

void initTeam() {
  jim.callConstructor();
  carl.callConstructor();
  tim.callConstructor();
  kim.callConstructor();
}

// try put team page here
class EditState extends StatefulWidget {
  @override
  EditText createState() => EditText();
}
class EditText extends State<EditState> {
  bool _isEditingText = false;
  TextEditingController _editingController;
  String initialText = "Initial Text";

  @override
  void initState() {
    super.initState();
    _editingController = TextEditingController(text: initialText);
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
        title: Text("'Editable Text"),
      ),
      body: Center(
        child: _editTitleTextField(),
      ),
    );
  }

  Widget _editTitleTextField() {
    if (_isEditingText)
      return Center(
        child: TextField(
          onSubmitted: (newValue){
            setState(() {
              initialText = newValue;
              _isEditingText =false;
            });
          },
          autofocus: true,
          controller: _editingController,
        ),
      );
    return InkWell(
        onTap: () {
      setState(() {
        _isEditingText = true;
      });
    },
      child: Text(
      initialText,
      style: TextStyle(
      color: Colors.black,
      fontSize: 18.0,
      ),
    ));
  }

}

class TeamPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    initTeam();
    print(teamName);
    print(teamAttendance);
    print(teamLocation);
    print(teamNumber);

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
                  onPressed: () { print('$name'); },
              ),
            ]),
            );
          }),
        ),
      );
  }
}















