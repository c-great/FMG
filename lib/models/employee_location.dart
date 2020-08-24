import 'package:flutter/material.dart';
import 'package:fmg_remote_work_tracker/theme/style.dart';

enum Location { OFFICE, HOME, ABSENT, UNDEFINED }

extension LocationText on Location {
  // ignore: missing_return
  String asString() {
    switch(this) {
      case Location.OFFICE: return "Office";
      break;

      case Location.HOME: return "Home";
      break;

      case Location.ABSENT: return "Absent";
      break;

      case Location.UNDEFINED: return "Location Undefined";
    }
  }

  Text asText() {
    return Text(this.asString(), style: locationTitle(),);
  }
}

enum OfficeLocation { WELLINGTON, PALMERSTON_NORTH, OTHER }

extension OfficeText on OfficeLocation {
  // ignore: missing_return
  String asString() {
    switch(this) {
      case OfficeLocation.WELLINGTON: return "Wellington";
      break;

      case OfficeLocation.PALMERSTON_NORTH: return "Palmerston North";
      break;

      case OfficeLocation.OTHER: return "Other";
    }
  }

  Text asText() {
    return Text(this.asString(), style: subTitle(),);
  }
}

enum AbsentOptions { SICK_LEAVE, ANNUAL_LEAVE, OTHER }

extension AbsentText on AbsentOptions {
  // ignore: missing_return
  String asString() {
    switch(this) {
      case AbsentOptions.SICK_LEAVE: return "Sick Leave";
      break;

      case AbsentOptions.ANNUAL_LEAVE: return "Annual Leave";
      break;

      case AbsentOptions.OTHER: return "Other";
    }
  }

  Text asText() {
    return Text(this.asString(), style: subTitle(),);
  }
}

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
      children: <Widget>[location.asText()],
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
        location.asText(),
        if (officeLocation != null) officeLocation.asText(),
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
          location.asText(),
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
