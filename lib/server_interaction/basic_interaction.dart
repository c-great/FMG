import 'dart:convert';
import 'dart:io';

import 'package:fmg_remote_work_tracker/models/employee.dart';
import 'package:fmg_remote_work_tracker/models/employee_location.dart';
import 'package:fmg_remote_work_tracker/data/login_info.dart';
import 'package:fmg_remote_work_tracker/server_interaction/push_notifications.dart';
import 'package:http/http.dart' as http;

var employeeURL =
    "https://fmg-server.azurewebsites.net/FMG_REST_service/employee/";
var managerURL =
    "https://fmg-server.azurewebsites.net/FMG_REST_service/manager/";

// set device registration token on server so it can send push notifications
Future<bool> setRegistrationToken() async {
  String token = await PushNotificationsManager().getToken();
  Map<String, String> parameters = Map();
  parameters.putIfAbsent("registrationToken", () => token);
  var tokenSetJSON = await postRequest("setToken", parameters: parameters);
  return tokenSetJSON['success'];
}

Future<EmployeeLocation> getLocation() async {
  var employeeLocationJSON = await postRequest("getLocation");
  return EmployeeLocation.fromJSON(employeeLocationJSON);
}

Future<bool> setLocation(EmployeeLocation location) async {
  var employeeLocationSetBoolJSON =
      await postRequest("setLocation", parameters: location.toMap());
  return employeeLocationSetBoolJSON['success'];
}

Future<Employee> getEmployee() async {
  var employeeJSON = await postRequest("getEmployee");
  return Employee.fromJSON(employeeJSON);
}

Future<Map<String, dynamic>> postRequest(String functionURL,
    {Map<String, String> parameters}) async {
  Map<String, dynamic> output;
  var response = await http.post(
    employeeURL + functionURL,
    headers: {
      HttpHeaders.authorizationHeader: "BASIC ${LoginInfo.getEncodedLogin()}"
    },
    body: parameters,
  );
  if (response.statusCode == 200) {
    output = json.decode(response.body);
  } else if (response.statusCode == 401){
    throw Exception("Invalid Username/Password");
  } else {
    throw Exception("Server Interaction Failed");
  }
  return output;
}

Future<DateTime> getDateOfInterest() async {
  DateTime date;
  var response = await http.get(employeeURL + "getDate");
  if (response.statusCode == 200) {
    date = DateTime.parse(json.decode(response.body)['date']);
  } else {
    throw Exception("server interaction failed");
  }
  return date;
}

// Gets Team Members. Named this way because it decides who members are by the manager_id they're assigned.
Future<List<Employee>> getDirectReports() async {
  var teamMembers = new List<Employee>();
  var employeeJSON = await postRequestManager("getDirectReports");
  for (var i=0; i<employeeJSON.length; i++) {
    teamMembers.add(Employee.fromJSON(employeeJSON[i]));
  }
  return teamMembers;
}

// For manager servlet.
Future<List> postRequestManager(String functionURL) async {
  List output;
  var response = await http.post(
    managerURL + functionURL,
    headers: {
      HttpHeaders.authorizationHeader: "BASIC ${LoginInfo.getEncodedLogin()}"
    },
//    body: parameters,
  );
  if (response.statusCode == 200) {
    output = json.decode(response.body);
  } else if (response.statusCode == 401){
    throw Exception("Invalid Username/Password");
  } else {
    throw Exception("Server Interaction Failed");
  }
  return output;
}