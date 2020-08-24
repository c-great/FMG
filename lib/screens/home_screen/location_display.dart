import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fmg_remote_work_tracker/models/employee_location.dart';

class RecordedLocationDisplay extends StatelessWidget {
  final EmployeeLocation location;
  final DateTime date;

  RecordedLocationDisplay({this.location, this.date});

  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        Text(
            "Your recorded location for TODAY "
                "(${new DateFormat.MMMMEEEEd().format(date)}) "
                "is:"
        ),
        Text(location.location.toString())
      ],
    );
  }

}