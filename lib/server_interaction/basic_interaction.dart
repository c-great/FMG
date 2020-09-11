import 'dart:convert';

import 'package:fmg_remote_work_tracker/models/employee_location.dart';
import 'package:http/http.dart' as http;

var serverURL = "https://fmg-server.azurewebsites.net/FMG_REST_service/fmg-api/";

LocationData locationData = LocationData();
DateData dateData = DateData();

EmployeeLocation getLocation() {
  return locationData.location;
}

void setLocation(EmployeeLocation location) {
  locationData.location = location;
}

Future<DateTime> getDateOfInterest() async {
  DateTime date;
  var response = await http.get(serverURL + "getDate");
  if (response.statusCode == 200) {
    date = DateTime.parse(json.decode(response.body)['date']);
  } else {
    throw Exception("server interaction failed");
  }
  return date;
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