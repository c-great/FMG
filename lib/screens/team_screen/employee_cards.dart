import 'package:flutter/material.dart';
import 'package:fmg_remote_work_tracker/models/employee.dart';
import 'package:fmg_remote_work_tracker/models/employee_location.dart';
import 'package:fmg_remote_work_tracker/screens/profile_screen/profile_screen.dart';

import 'edit_location_dialog.dart';

List<Widget> createEmployeeCards(
    BuildContext context,
    List<Employee> reportingEmployees,
    Map<String, EmployeeLocation> reportingEmployeeLocations,
    {@required EmployeeAtOffice defaultOffice,
    @required EmployeeAbsent defaultAbsence,
    @required Function update}) {
  List<Widget> widgetList = [];

  reportingEmployees.forEach((employee) {
    EmployeeLocation employeeLocation =
        reportingEmployeeLocations[employee.employeeID];

    Card employeeCard = new Card(
      child: Column(
        key: Key(employee.employeeID),
        children: [
          employeeLocation.display(),
          ListTile(
            title: Text(
              "${employee.firstName} ${employee.lastName}",
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.person),
                  // edit location
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return ProfileScreen(employee: employee);
                      }
                    ));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  // edit location
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return editLocationDialog(context, employee.employeeID,
                            defaultAbsence, defaultOffice, employeeLocation,
                            update: update,
                            title:
                                "Edit ${employee.firstName} ${employee.lastName}'s location");
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      color: Theme.of(context).primaryColorLight,
    );
    widgetList.add(employeeCard);
  });

  return widgetList;
}
