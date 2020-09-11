import 'dart:convert';
import 'dart:io';

import 'package:fmg_remote_work_tracker/models/employee_location.dart';
import 'package:fmg_remote_work_tracker/models/login_info.dart';
import 'package:http/http.dart' as http;

var serverURL =
    "https://fmg-server.azurewebsites.net/FMG_REST_service/fmg-api/";

LocationData locationData = LocationData();

Future<EmployeeLocation> getLocation() async {
  var employeeLocationJSON = await postRequest("getLocation");
  return EmployeeLocation.fromJSON(employeeLocationJSON);
}

void setLocation(EmployeeLocation location) {
  locationData.location = location;
}

Future<Map<String, dynamic>> postRequest (String functionURL,
    {Map<String, String> parameters}) async {
  Map<String, dynamic> output;
  var response = await http.post(
      serverURL + functionURL,
    headers: {HttpHeaders.authorizationHeader: "BASIC ${LoginInfo.getEncodedLogin()}"},
    body: parameters,
  );
  if (response.statusCode == 200) {
    output = json.decode(response.body);
  } else {
    throw Exception("server interaction failed");
  }
  return output;
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
