import 'package:flutter/material.dart';
import 'package:fmg_remote_work_tracker/theme/style.dart';

enum Location { OFFICE, HOME, ABSENT, UNDEFINED }

enum OfficeLocation { WELLINGTON, PALMERSTON_NORTH, OTHER }

enum AbsentOptions { SICK_LEAVE, ANNUAL_LEAVE, OTHER }

class EmployeeLocation {
  Location location;
  bool working;

  EmployeeLocation({this.location = Location.UNDEFINED, this.working});

  Widget display() {
    return displayBox(Column(
    children: <Widget>[Text("Location Undefined")],
    ));
  }
}

class EmployeeAtHome extends EmployeeLocation {
  EmployeeAtHome() : super(location: Location.HOME, working: true);

  Widget display() {
    return displayBox(Column(
      children: <Widget>[Text("Home", style: locationTitle())],
    ));
  }
}

class EmployeeAtOffice extends EmployeeLocation {
  OfficeLocation officeLocation;
  String additionalInfo;

  EmployeeAtOffice({this.officeLocation, this.additionalInfo})
      : super(location: Location.OFFICE, working: true);

  Widget display() {
    return displayBox(Column(
      children: <Widget>[
        Text("Office", style: locationTitle()),
        if (additionalInfo != null) Text(additionalInfo),
      ],
    ));
  }
}

class EmployeeAbsent extends EmployeeLocation {
  AbsentOptions absentOptions;
  String additionalInfo;

  EmployeeAbsent({this.absentOptions, this.additionalInfo})
      : super(location: Location.ABSENT, working: false);

  Widget display() {
    return displayBox(
      Column(
        children: <Widget>[
          Text("Absent", style: locationTitle()),
          if (additionalInfo != null) Text(additionalInfo),
        ],
      ),
    );
  }
}

Widget displayBox(Widget child) {
  return SizedBox(
    height: 150,
    child: child,
  );
}
