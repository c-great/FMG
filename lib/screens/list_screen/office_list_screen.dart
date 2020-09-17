import 'package:flutter/material.dart';
import 'package:fmg_remote_work_tracker/data/office_list.dart';
import 'package:fmg_remote_work_tracker/models/employee_location.dart';
import 'package:fmg_remote_work_tracker/screens/list_screen/list_entry.dart';
import 'package:fmg_remote_work_tracker/screens/list_screen/select_from_list_screen.dart';

List<Widget> getOfficeList(BuildContext context) {
  List<Widget> widgets = new List();
  getRawOfficeList().forEach((office) {
    var tile = getRegularListItem(
        context,
        office,
        EmployeeAtOffice(officeLocation: office));
    widgets.add(tile);
  });
  return widgets;
}

class OfficeListScreen extends SelectFromListScreen {
  OfficeListScreen() : super(
      title: "Choose the Correct Office",
      listGenFunction: (context) {
        return getOfficeList(context);
      }
  );
}