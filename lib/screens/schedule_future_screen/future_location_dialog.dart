import 'package:flutter/material.dart';
import 'package:fmg_remote_work_tracker/components/location_picker.dart';
import 'package:fmg_remote_work_tracker/models/employee_location.dart';

SimpleDialog createFutureLocationDialog(
    BuildContext context, Function update, String title) {

  return SimpleDialog(
    children: <Widget>[
      LocationPicker(),
      SizedBox(height: 10,),
      IconButton(
          icon: Icon(
            Icons.check_circle_outline,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {}),
    ],
  );
}
