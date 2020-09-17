import 'package:fmg_remote_work_tracker/models/employee_location.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<EmployeeAbsent> getDefaultAbsence() async {
  final prefs = await SharedPreferences.getInstance();

  final absenceType = prefs.getString('defaultAbsenceType') ?? "Annual Leave";
  final additionalInfo = prefs.getString('defaultAbsenceAdditionalInfo') ?? null;
  return EmployeeAbsent(
      absenceType: getAbsenceType(absenceType),
      additionalInfo: additionalInfo);
}

Future<EmployeeAtOffice> getDefaultOffice() async {
  final prefs = await SharedPreferences.getInstance();

  final office = prefs.getString('defaultOffice') ?? "Wellington";
  final additionalInfo = prefs.getString('defaultOfficeAdditionalInfo') ?? null;
  return EmployeeAtOffice(
      officeLocation: office,
      additionalInfo: additionalInfo);
}

setDefaultAbsence(EmployeeAbsent defaultAbsence) async {
  final prefs = await SharedPreferences.getInstance();

  prefs.setString('defaultAbsenceType', defaultAbsence.absenceType.asString());
  prefs.setString('defaultAbsenceAdditionalInfo', defaultAbsence.additionalInfo);
}

setDefaultOffice(EmployeeAtOffice defaultOffice) async {
  final prefs = await SharedPreferences.getInstance();

  prefs.setString('defaultOffice', defaultOffice.officeLocation);
  prefs.setString('defaultOfficeAdditionalInfo', defaultOffice.additionalInfo);
}