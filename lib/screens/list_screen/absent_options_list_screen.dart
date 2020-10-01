import 'package:flutter/material.dart';
import 'package:fmg_remote_work_tracker/models/employee_location.dart';
import 'package:fmg_remote_work_tracker/screens/list_screen/list_entry.dart';
import 'package:fmg_remote_work_tracker/screens/list_screen/other_dialog.dart';
import 'package:fmg_remote_work_tracker/screens/list_screen/select_from_list_screen.dart';

List<Widget> getAbsentOptionsList(BuildContext context) {
  List<Widget> widgets = new List();
  AbsentOptions.values.forEach((element) {
    // ignore other because it is treated specially
    if (element != AbsentOptions.OTHER) {
      var tile = getRegularListItem(
          context,
          element.asString(),
          EmployeeAbsent(absenceType: element));
      widgets.add(tile);
    }
  });
  // add other option
  widgets.add(Divider());
  var otherTile = getOtherListItem(otherAbsentDialog(context));
  widgets.add(otherTile);
  return widgets;
}

Function otherAbsentDialog(BuildContext context) {
  return () {
    showDialog<EmployeeLocation>(
        context: context,
        builder: (BuildContext context) {
          return createOtherAdditionalInfoDialog(context, (additionalInfo) {
            return EmployeeAbsent(
                absenceType: AbsentOptions.OTHER,
                additionalInfo: additionalInfo);
          },
          "Enter the Type of Absence",
          "e.g. Bereavement");
        }
    );
  };
}

class AbsenceTypeListScreen extends SelectFromListScreen {
  AbsenceTypeListScreen() : super(
      title: "Choose the Type of Absence",
      listGenFunction: (context) {
        return getAbsentOptionsList(context);
      }
  );
}