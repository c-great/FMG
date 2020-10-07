import 'package:flutter/material.dart';
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
    EmployeeLocation startingLocation,
    {DateTime initialStart,
    DateTime initialEnd}) {

  DateTimeRange dateRange;
  EmployeeLocation employeeLocation = startingLocation;

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
        initialStart: initialStart,
        initialEnd: initialEnd,
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
            if (employeeLocation.location != Location.UNDEFINED && dateRange != null) {
              LocationDateRange futureLocations = LocationDateRange(
                  employeeLocation: employeeLocation,
                  startDate: dateRange.start,
                  endDate: dateRange.end);

              // wait for both clears to finish (they run simultaneously)
              if (initialStart != null && initialEnd != null) {
                await Future.wait([
                  clearFutureLocations(initialStart, initialEnd),
                  clearFutureLocations(futureLocations.startDate, futureLocations.endDate)]);
              }
              // otherwise, just wait to clear the dates we are trying to set
              else {
                await clearFutureLocations(
                    futureLocations.startDate, futureLocations.endDate);
              }
              await setFutureLocations(futureLocations);
            }
            Navigator.pop(context);
            update();
          }),
    ],
  );
}
