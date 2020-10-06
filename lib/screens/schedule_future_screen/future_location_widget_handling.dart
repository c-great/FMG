import 'package:flutter/material.dart';
import 'package:fmg_remote_work_tracker/models/location_date_range.dart';
import 'package:fmg_remote_work_tracker/theme/style.dart';
import 'package:intl/intl.dart';

Future<List<Widget>> getLocationDateRangeDisplayWidgets(
    Future<List<LocationDateRange>> futureLocations) async {
  List<Widget> widgetList = [];
  List<LocationDateRange> scheduledLocations = await futureLocations;

  scheduledLocations.forEach((element) {
    widgetList.add(getLocationDateRangeDisplayWidget(element));
  });

  return widgetList;
}

Widget getLocationDateRangeDisplayWidget(LocationDateRange locationDateRange) {
  return Card(
      color: appTheme().primaryColorLight,
      child: Column(
        children: [
          locationDateRange.employeeLocation.display(),
          ListTile(
            title: Text("From"),
            subtitle: Text(new DateFormat.yMMMMEEEEd().format(locationDateRange.startDate)),
          ),
          ListTile(
            title: Text("To"),
            subtitle: Text(new DateFormat.yMMMMEEEEd().format(locationDateRange.endDate)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
                children: <Widget>[
              IconButton(icon: Icon(Icons.delete_forever),),
              IconButton(icon: Icon(Icons.edit),),
            ]),
          ),
        ],
      ));
}
