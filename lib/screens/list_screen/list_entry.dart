import 'package:flutter/material.dart';
import 'package:fmg_remote_work_tracker/models/employee_location.dart';

Card getRegularListItem(
    BuildContext context,
    String name,
    EmployeeLocation location)
{
  return Card(
    child: ListTile(
    title: Center(child: Text(name)),
    onTap: () {
      Navigator.pop(context, location);
    },
    )
  );
}

Card getOtherListItem(Function callback)
{
  return Card(
      child: ListTile(
        title: Center(child: Text("Other")),
        onTap: () {
          callback();
        },
      )
  );
}