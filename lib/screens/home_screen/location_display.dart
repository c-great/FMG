import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fmg_remote_work_tracker/models/employee_location.dart';

class RecordedLocationDisplay extends StatelessWidget {
  final EmployeeLocation location;
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
                return Text(
                    "Your recorded location for ${relativeDay(snapshot.data)} "
                    "(${new DateFormat.MMMMEEEEd().format(snapshot.data)}) "
                    "is:");
              } else {
                return Text("Waiting for data...");
              }
            }),
        // Text(
        //     "Your recorded location for TODAY "
        //         "(${new DateFormat.MMMMEEEEd().format(date)}) "
        //         "is:"
        // ),
        SizedBox(
          height: 10,
        ),
        location.display(),
      ],
    );
  }
}

String relativeDay(DateTime date) {
  var todayDate = new DateTime.now();
  if (todayDate.year == date.year && todayDate.month == date.month) {
    if (todayDate.day == date.day) return "TODAY";
    else if (todayDate.day + 1 == date.day) return "TOMORROW";
  }
  return "THE DATE";
}
