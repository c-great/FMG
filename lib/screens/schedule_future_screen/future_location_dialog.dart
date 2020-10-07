import 'package:flutter/material.dart';
import 'package:fmg_remote_work_tracker/components/buttons.dart';
import 'package:fmg_remote_work_tracker/components/location_picker.dart';
import 'package:fmg_remote_work_tracker/models/employee_location.dart';
import 'package:fmg_remote_work_tracker/models/location_date_range.dart';
import 'package:fmg_remote_work_tracker/screens/schedule_future_screen/date_range_picker.dart';
import 'package:fmg_remote_work_tracker/server_interaction/basic_interaction.dart';

SimpleDialog createFutureLocationDialog(
    BuildContext context,
    Function update,
    EmployeeAbsent defaultAbsence,
    EmployeeAtOffice defaultOffice,
    EmployeeLocation startingLocation) {
  DateTimeRange dateRange;
  EmployeeLocation employeeLocation;

  return SimpleDialog(
    children: <Widget>[
      LocationPicker(
        defaultAbsence: defaultAbsence,
        defaultOffice: defaultOffice,
        startingLocation: startingLocation,
        updateLocation: (data) {
          employeeLocation = data;
        },
      ),
      DateRangePicker(
        updateDateRange: (data) {
          dateRange = data;
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
            if (employeeLocation != null && dateRange != null) {
              LocationDateRange futureLocations = LocationDateRange(
                  employeeLocation: employeeLocation,
                  startDate: dateRange.start,
                  endDate: dateRange.end);
              await clearFutureLocations(futureLocations.startDate, futureLocations.endDate);
              await setFutureLocations(futureLocations);
            }
            Navigator.pop(context);
            update();
          }),
    ],
  );
}
