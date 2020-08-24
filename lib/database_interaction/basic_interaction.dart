import 'package:fmg_remote_work_tracker/models/employee_location.dart';

LocationData locationData = LocationData();
DateData dateData = DateData();

EmployeeLocation getLocation() {
  return locationData.location;
}

void setLocation(EmployeeLocation location) {
  locationData.location = location;
}

DateTime getDateOfInterest() {
  return dateData.date;
}

// TODO: implement an actual connection to an actual database.
class LocationData {
  EmployeeLocation location = EmployeeLocation(location: Location.UNDEFINED);
}

// TODO: implement an actual connection to an actual database.
class DateData {
  DateTime date;

  DateData() {
    date = DateTime.now();
  }
}