import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fmg_remote_work_tracker/models/employee.dart';

// Widget to display info about a specific employee passed in
class ProfileScreen extends StatelessWidget {
  final Employee employee;

  ProfileScreen({@required this.employee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${employee.firstName} ${employee.lastName}'s Profile"),
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: <Widget>[
          ListTile(
            title: Text("First Name"),
            subtitle: Text(employee.firstName),
          ),
          ListTile(
            title: Text("Last Name"),
            subtitle: Text(employee.lastName),
          ),
          ListTile(
            title: Text("Login Name"),
            subtitle: Text(employee.loginName),
          ),
          ListTile(
            title: Text("Employee ID"),
            subtitle: Text(employee.employeeID),
          ),
          Divider(),
          ListTile(
            title: Text("Is a Manager"),
            subtitle: Text(employee.manager.toString()),
          ),
          ListTile(
            title: Text("Manager's ID"),
            subtitle: Text(employee.managerID != null ? employee.managerID : "N/A"),
          ),
          Divider(),
          ListTile(
            title: Text("Is an Admin"),
            subtitle: Text(employee.admin.toString()),
          ),
        ],
      ),
    );
  }
}
