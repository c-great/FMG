import 'package:flutter/material.dart';
import 'package:fmg_remote_work_tracker/screens/list_screen/select_from_list_screen.dart';

List<String> teamEditOptions = ["Attendance", "Location"];

List<Widget> getTeamEditOptionsList(BuildContext context) {
  List<Widget> widgets = new List();
  teamEditOptions.forEach((element) {
    var tile = Card(
        child: ListTile(
          title: Center(child: Text(element)),
          onTap: () {
            // Store the result (Attendance or Location)
            String result = element;
            Navigator.pop(context, result);
          },
        )
    );
    widgets.add(tile);
  });
  return widgets;
  }

class TeamEditOptionsScreen extends SelectFromListScreen {
  TeamEditOptionsScreen() : super(
      title: "Choose what to change",
      listGenFunction: (context) {
        return getTeamEditOptionsList(context);
      }
  );
}