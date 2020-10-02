import 'package:flutter/material.dart';
import 'package:fmg_remote_work_tracker/models/employee_location.dart';

SimpleDialog createOtherAdditionalInfoDialog(
    BuildContext context,
    Function createLocation,
    String title,
    String hintText) {
  TextEditingController controller = TextEditingController();

  return SimpleDialog(
    title: Text(title),
    children: <Widget>[
      TextField(
        maxLength: 35,
        controller: controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: hintText,
        ),
      ),
      SizedBox(height: 10,),
      IconButton(
        icon: Icon(Icons.check_circle_outline, color: Theme.of(context).primaryColor,),
        onPressed: () {
          String details = controller.text;
          if (details != "") {
            EmployeeLocation location = createLocation(details);
            // pop twice to get back to screen before list screen
            Navigator.pop(context, location);
            Navigator.pop(context, location);
          }
        },
      ),
    ],
  );
}