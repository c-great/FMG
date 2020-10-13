import 'package:flutter/material.dart';
import 'package:fmg_remote_work_tracker/components/location_picker.dart';
import 'package:fmg_remote_work_tracker/models/employee_location.dart';
import 'package:fmg_remote_work_tracker/server_interaction/basic_interaction.dart';

SimpleDialog editLocationDialog(
    BuildContext context,
    String employeeID,
    EmployeeAbsent defaultAbsence,
    EmployeeAtOffice defaultOffice,
    EmployeeLocation startingLocation,
    {@required Function update,
    String title}) {
  EmployeeLocation employeeLocation = startingLocation;

  return SimpleDialog(
    title: Center(child: Text(title)),
    children: <Widget>[
      LocationPicker(
        defaultAbsence: defaultAbsence,
        defaultOffice: defaultOffice,
        startingLocation: startingLocation,
        updateLocation: (data) {
          employeeLocation = data;
        },
      ),
      SizedBox(
        height: 10,
      ),
      IconButton(
          icon: Icon(
            Icons.check_circle_outline,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () async {
            if (employeeLocation != startingLocation) {
              // wait until the server finishes processing
              await setDirectReportLocation(employeeID, employeeLocation);
              update();
            }
            Navigator.pop(context);
          }),
    ],
  );
}
