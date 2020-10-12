import 'package:flutter/material.dart';
import 'package:fmg_remote_work_tracker/models/employee.dart';
import 'package:fmg_remote_work_tracker/models/employee_location.dart';
import 'package:fmg_remote_work_tracker/screens/schedule_future_screen/future_location_dialog.dart';

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
                showDialog(context: context,
                builder: (BuildContext context) {
                  return editLocationDialog(context, EmployeeAbsent(absenceType: AbsentOptions.SICK_LEAVE), EmployeeAtOffice(officeLocation: "something"), EmployeeAbsent(absenceType: AbsentOptions.SICK_LEAVE));
                },);
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