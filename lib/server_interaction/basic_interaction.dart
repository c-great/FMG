import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';

import 'package:fmg_remote_work_tracker/models/employee.dart';
import 'package:fmg_remote_work_tracker/models/employee_location.dart';
import 'package:fmg_remote_work_tracker/data/login_info.dart';
import 'package:fmg_remote_work_tracker/models/location_date_range.dart';
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

Future<EmployeeLocation> getLocationFromID(String id) async {
  //String id
  var employeeLocationIDJSON =
      await postRequest("getLocationFromID" + "?employee_id=" + id);
  return EmployeeLocation.fromJSON(employeeLocationIDJSON);
}

Future<EmployeeLocation> getLocation() async {
  var employeeLocationJSON = await postRequest("getLocation");
  return EmployeeLocation.fromJSON(employeeLocationJSON);
}

Future<List<LocationDateRange>> getFutureLocations() async {
  List<LocationDateRange> futureLocationDateRanges = [];

  List<dynamic> futureLocationsJSON = await postRequest("getFutureLocations");
  if (futureLocationsJSON[0].length > 0) {
    futureLocationsJSON.forEach((element) {
      DateTime startDate = DateTime.parse(element['startDate']);
      DateTime endDate = DateTime.parse(element['endDate']);
      EmployeeLocation employeeLocation =
          EmployeeLocation.fromJSON(element['employeeLocation']);
      var locationDateRange = LocationDateRange(
          employeeLocation: employeeLocation,
          startDate: startDate,
          endDate: endDate);
      futureLocationDateRanges.add(locationDateRange);
    });
  }

  return futureLocationDateRanges;
}

Future<bool> setLocation(EmployeeLocation location) async {
  var employeeLocationSetBoolJSON =
      await postRequest("setLocation", parameters: location.toMap());
  return employeeLocationSetBoolJSON['success'];
}

Future<bool> setLocationFromID(EmployeeLocation location, String id) async {
  var employeeLocationSetBoolJSON = await postRequest(
      "setLocationFromID" + "?employee_id=" + id,
      parameters: location.toMap());
  return employeeLocationSetBoolJSON['success'];
}

DateFormat acceptedFormat = new DateFormat("yyyy-MM-dd");

Future<bool> clearFutureLocations(DateTime startDate, DateTime endDate) async {
  Map<String, String> dateParameters = {
    "startDate": acceptedFormat.format(startDate),
    "endDate": acceptedFormat.format(endDate),
  };

  var clearFutureLocationsBoolJSON =
      await postRequest("clearFutureLocations", parameters: dateParameters);
  return clearFutureLocationsBoolJSON['success'];
}

Future<bool> setFutureLocations(LocationDateRange locationDateRange) async {
  Map<String, String> locationDateParameters = {
    "startDate": acceptedFormat.format(locationDateRange.startDate),
    "endDate": acceptedFormat.format(locationDateRange.endDate),
  };
  locationDateParameters.addAll(locationDateRange.employeeLocation.toMap());

  var futureEmployeeLocationsSetBoolJSON = await postRequest(
      "setFutureLocations",
      parameters: locationDateParameters);
  return futureEmployeeLocationsSetBoolJSON['success'];
}

Future<Employee> getEmployee() async {
  var employeeJSON = await postRequest("getEmployee");
  return Employee.fromJSON(employeeJSON);
}

Future<dynamic> postRequest(String functionURL,
    {Map<String, String> parameters}) async {
  dynamic output;
  var response = await http.post(
    employeeURL + functionURL,
    headers: {
      HttpHeaders.authorizationHeader: "BASIC ${LoginInfo.getEncodedLogin()}"
    },
    body: parameters,
  );
  if (response.statusCode == 200) {
    output = json.decode(response.body);
  } else if (response.statusCode == 401) {
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
  var reportingEmployees = new List<Employee>();
  var employeeJSON = await postRequestManager("getDirectReports");
  for (var i = 0; i < employeeJSON.length; i++) {
    reportingEmployees.add(Employee.fromJSON(employeeJSON[i]));
  }
  return reportingEmployees;
}

Future<Map<String, EmployeeLocation>> getDirectReportLocations() async {
  Map<String, EmployeeLocation> reportingEmployeeLocations = new Map();
  Map<String, dynamic> employeeLocationsJSON =
      await postRequestManager("getLocations");
  employeeLocationsJSON.forEach((employeeID, locationJSON) {
    EmployeeLocation employeeLocation = EmployeeLocation.fromJSON(locationJSON);
    reportingEmployeeLocations.putIfAbsent(employeeID, () {
      return employeeLocation;
    });
  });

  return reportingEmployeeLocations;
}

Future<bool> setDirectReportLocation(EmployeeLocation employeeLocation) async {
  var successJSON = await postRequestManager(
      "setLocation",
      parameters: employeeLocation.toMap());

  return successJSON['success'];
}

// For manager servlet.
Future<dynamic> postRequestManager(String functionURL, {Map<String, String> parameters}) async {
  dynamic output;
  var response = await http.post(
    managerURL + functionURL,
    headers: {
      HttpHeaders.authorizationHeader: "BASIC ${LoginInfo.getEncodedLogin()}"
    },
   body: parameters,
  );
  if (response.statusCode == 200) {
    output = json.decode(response.body);
  } else if (response.statusCode == 401) {
    throw Exception("Invalid Username/Password");
  } else {
    throw Exception("Server Interaction Failed");
  }
  return output;
}
