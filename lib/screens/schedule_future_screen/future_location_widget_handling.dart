import 'package:flutter/material.dart';
import 'package:fmg_remote_work_tracker/models/location_date_range.dart';
import 'package:fmg_remote_work_tracker/server_interaction/basic_interaction.dart';
import 'package:fmg_remote_work_tracker/theme/style.dart';
import 'package:intl/intl.dart';

Future<List<Widget>> getLocationDateRangeDisplayWidgets(
    Future<List<LocationDateRange>> futureLocations,
    Function update,
    Function edit) async {
  List<Widget> widgetList = [];
  List<LocationDateRange> scheduledLocations = await futureLocations;

  scheduledLocations.forEach((element) {
    widgetList.add(getLocationDateRangeDisplayWidget(element, update, edit));
  });

  return widgetList;
}

Widget getLocationDateRangeDisplayWidget(
    LocationDateRange locationDateRange, Function update, Function edit) {
  return Card(
      color: appTheme().primaryColorLight,
      child: Column(
        children: [
          locationDateRange.employeeLocation.display(),
          ListTile(
            title: Text("From"),
            subtitle: Text(new DateFormat.yMMMMEEEEd()
                .format(locationDateRange.startDate)),
          ),
          ListTile(
            title: Text("To"),
            subtitle: Text(
                new DateFormat.yMMMMEEEEd().format(locationDateRange.endDate)),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
              IconButton(
                icon: Icon(Icons.delete_forever),
                onPressed: () async {
                  await clearFutureLocations(
                      locationDateRange.startDate, locationDateRange.endDate);
                  update();
                },
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  edit(locationDateRange.employeeLocation,
                      locationDateRange.startDate, locationDateRange.endDate);
                },
              ),
            ]),
          ),
        ],
      ));
}
