import 'package:flutter/material.dart';
import 'package:fmg_remote_work_tracker/models/employee.dart';
import 'package:fmg_remote_work_tracker/models/employee_location.dart';

List<Widget> createEmployeeCards(BuildContext context, List<Employee> reportingEmployees,
    Map<String, EmployeeLocation> reportingEmployeeLocations) {
  List<Widget> widgetList = [];

  reportingEmployees.forEach((employee) {
    Card employeeCard = new Card(
      child: Column(
        children: [
          reportingEmployeeLocations[employee.employeeID].display(),
          ListTile(
            title: Text("${employee.firstName} ${employee.lastName}",),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              // edit location
              onPressed: () {

              },),
          ),
        ],
      ),
      color: Theme.of(context).primaryColorLight,
    );
    widgetList.add(employeeCard);
  });

  return widgetList;
}