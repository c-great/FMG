import 'package:flutter/material.dart';
import 'package:fmg_remote_work_tracker/theme/style.dart';

enum Location { OFFICE, HOME, ABSENT, UNDEFINED }

extension LocationText on Location {
  // ignore: missing_return
  String asString() {
    switch (this) {
      case Location.OFFICE:
        return "Office";
        break;

      case Location.HOME:
        return "Home";
        break;

      case Location.ABSENT:
        return "Absent";
        break;

      case Location.UNDEFINED:
        return "Undefined";
    }
  }

  Text asText() {
    return Text(
      this.asString(),
      style: locationTitle(),
    );
  }
}

// enum OfficeLocation { WELLINGTON, PALMERSTON_NORTH, OTHER }
//
// extension OfficeText on OfficeLocation {
//   // ignore: missing_return
//   String asString() {
//     switch(this) {
//       case OfficeLocation.WELLINGTON: return "Wellington";
//       break;
//
//       case OfficeLocation.PALMERSTON_NORTH: return "Palmerston North";
//       break;
//
//       case OfficeLocation.OTHER: return "Other";
//     }
//   }
//
//   Text asText() {
//     return Text(this.asString(), style: subTitle(),);
//   }
// }

enum AbsentOptions { SICK_LEAVE, ANNUAL_LEAVE, OTHER }

AbsentOptions getAbsenceType(String string) {
  var lowerString = string.toLowerCase();
  if (lowerString == "sick leave")
    return AbsentOptions.SICK_LEAVE;
  else if (lowerString == "annual leave")
    return AbsentOptions.ANNUAL_LEAVE;
  else if (lowerString == "other")
    return AbsentOptions.OTHER;
  else
    return null;
}

extension AbsentText on AbsentOptions {
  // ignore: missing_return
  String asString() {
    switch (this) {
      case AbsentOptions.SICK_LEAVE:
        return "Sick Leave";
        break;

      case AbsentOptions.ANNUAL_LEAVE:
        return "Annual Leave";
        break;

      case AbsentOptions.OTHER:
        return "Other";
    }
  }

  Text asText() {
    return Text(
      this.asString(),
      style: subTitle(),
    );
  }
}

class EmployeeLocation {
  Location location;
  bool working;

  EmployeeLocation({this.location = Location.UNDEFINED, this.working});

  factory EmployeeLocation.fromJSON(Map<String, dynamic> json) {
    var location = json['location'].toLowerCase();
    if (location == "office") {
      return new EmployeeAtOffice(
          officeLocation: json['office'],
          additionalInfo: json['additionalInfo']);
    } else if (location == "home") {
      return new EmployeeAtHome();
    } else if (location == "absent") {
      return new EmployeeAbsent(
          absenceType: getAbsenceType(json['absenceType']),
          additionalInfo: json['additionalInfo']);
    }
    return new EmployeeLocation();
  }

  Map<String, String> toMap() {
    Map<String, String> map = new Map();
    map.putIfAbsent("location", () => location.asString());
    map.putIfAbsent("working", () => working ? "true" : "false");
    return map;
  }

  Widget display() {
    return displayBox(Column(
      children: <Widget>[location.asText()],
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

  Map<String, String> toMap() {
    var map = super.toMap();
    return map;
  }
}

class EmployeeAtOffice extends EmployeeLocation {
  String officeLocation;
  String additionalInfo;

  EmployeeAtOffice({this.officeLocation, this.additionalInfo})
      : super(location: Location.OFFICE, working: true);

  Widget display() {
    return displayBox(Column(
      children: <Widget>[
        location.asText(),
        if (officeLocation != null)
          Text(
            officeLocation,
            style: subTitle(),
          ),
        if (additionalInfo != null) Text(additionalInfo),
      ],
    ));
  }

  Map<String, String> toMap() {
    var map = super.toMap();
    if (officeLocation != null) {
      map.putIfAbsent("office", () => officeLocation);
    }
    if (additionalInfo != null) {
      map.putIfAbsent("additionalInfo", () => additionalInfo);
    }
    return map;
  }
}

class EmployeeAbsent extends EmployeeLocation {
  AbsentOptions absenceType;
  String additionalInfo;

  EmployeeAbsent({this.absenceType, this.additionalInfo})
      : super(location: Location.ABSENT, working: false);

  Widget display() {
    return displayBox(
      Column(
        children: <Widget>[
          location.asText(),
          if (absenceType != null) absenceType.asText(),
          if (additionalInfo != null) Text(additionalInfo),
        ],
      ),
    );
  }

  Map<String, String> toMap() {
    var map = super.toMap();
    if (absenceType != null) {
      map.putIfAbsent("absenceType", () => absenceType.asString());
    }
    if (additionalInfo != null) {
      map.putIfAbsent("additionalInfo", () => additionalInfo);
    }
    return map;
  }
}

Widget displayBox(Widget child) {
  return SizedBox(
    height: 130,
    child: Center(
        child: Card(
            // color: appTheme().accentColor,
            child: Center(
                child: Column(
              children: <Widget>[Spacer(), child, Spacer()],
            )))),
  );
}
