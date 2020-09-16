import 'package:flutter/material.dart';
import 'package:fmg_remote_work_tracker/models/employee_location.dart';
import 'package:fmg_remote_work_tracker/screens/list_screen/list_entry.dart';
import 'package:fmg_remote_work_tracker/screens/list_screen/select_from_list_screen.dart';

List<Widget> getAbsentOptionsList(BuildContext context) {
  List<Widget> widgets = new List();
  AbsentOptions.values.forEach((element) {
    var tile = getRegularListItem(
        context,
        element.asString(),
        EmployeeAbsent(absenceType: element));
    widgets.add(tile);
  });
  return widgets;
}

class AbsenceTypeListScreen extends SelectFromListScreen {
  AbsenceTypeListScreen() : super(
      title: "Choose the Type of Absence",
      listGenFunction: (context) {
        return getAbsentOptionsList(context);
      }
  );
}