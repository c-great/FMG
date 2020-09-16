import 'dart:convert';
import 'dart:io';

import 'package:fmg_remote_work_tracker/models/employee.dart';
import 'package:fmg_remote_work_tracker/models/employee_location.dart';
import 'file:///C:/Users/nmcku/AndroidStudioProjects/fmg_remote_work_tracker/lib/data/login_info.dart';
import 'package:http/http.dart' as http;

var serverURL =
    "https://fmg-server.azurewebsites.net/FMG_REST_service/fmg-api/";

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
    serverURL + functionURL,
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
  var response = await http.get(serverURL + "getDate");
  if (response.statusCode == 200) {
    date = DateTime.parse(json.decode(response.body)['date']);
  } else {
    throw Exception("server interaction failed");
  }
  return date;
}