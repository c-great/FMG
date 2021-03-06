import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fmg_remote_work_tracker/models/employee_location.dart';

class RecordedLocationDisplay extends StatelessWidget {
  final Future<EmployeeLocation> location;
  final Future<DateTime> date;

  RecordedLocationDisplay({this.location, this.date});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        FutureBuilder<DateTime>(
            future: date,
            builder: (BuildContext context, AsyncSnapshot<DateTime> snapshot) {
              if (snapshot.hasData) {
                return FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                        "Your recorded location for ${relativeDay(snapshot.data)} "
                        "(${new DateFormat.MMMMEEEEd().format(snapshot.data)}) "
                        "is:"));
              } else {
                return Text("Waiting for data...");
              }
            }),
        FutureBuilder<EmployeeLocation>(
            future: location,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return snapshot.data.display();
              } else {
                return displayBox(Text(""));
              }
            })
      ],
    );
  }
}

String relativeDay(DateTime date) {
  var todayDate = new DateTime.now();
  var tomorrowDate = todayDate.add(Duration(days: 1));
  if (todayDate.year == date.year &&
      todayDate.month == date.month &&
      todayDate.day == date.day) {
    return "TODAY";
  } else if (tomorrowDate.year == date.year &&
      tomorrowDate.month == date.month &&
      tomorrowDate.day == date.day)
    return "TOMORROW";
  else
    return "THE DATE";
}
