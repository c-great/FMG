import 'package:flutter/material.dart';
import 'file:///C:/Users/nmcku/AndroidStudioProjects/fmg_remote_work_tracker/lib/settings/office_list.dart';
import 'package:fmg_remote_work_tracker/models/employee_location.dart';
import 'package:fmg_remote_work_tracker/screens/list_screen/list_entry.dart';
import 'package:fmg_remote_work_tracker/screens/list_screen/select_from_list_screen.dart';

import 'other_dialog.dart';

List<Widget> getOfficeList(BuildContext context) {
  List<Widget> widgets = new List();
  getRawOfficeList().forEach((office) {
    var tile = getRegularListItem(
        context,
        office,
        EmployeeAtOffice(officeLocation: office));
    widgets.add(tile);
  });

  // add other option
  widgets.add(Divider());
  var otherTile = getOtherListItem(otherOfficeDialog(context));
  widgets.add(otherTile);
  return widgets;
}

Function otherOfficeDialog(BuildContext context) {
  return () {
    showDialog<EmployeeLocation>(
        context: context,
        builder: (BuildContext context) {
          return createOtherAdditionalInfoDialog(context, (additionalInfo) {
            return EmployeeAtOffice(
                officeLocation: "Other",
                additionalInfo: additionalInfo);
          },
          "Enter the Name of the City",
          "City Name");
        }
    );
  };
}

class OfficeListScreen extends SelectFromListScreen {
  OfficeListScreen() : super(
      title: "Choose the Correct Office",
      listGenFunction: (context) {
        return getOfficeList(context);
      }
  );
}