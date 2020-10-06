import 'package:fmg_remote_work_tracker/models/employee_location.dart';

class LocationDateRange {
  EmployeeLocation employeeLocation;
  DateTime startDate;
  DateTime endDate;

  LocationDateRange({this.employeeLocation, this.startDate, this.endDate});
}