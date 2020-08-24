enum Location {
  OFFICE, HOME, ABSENT, UNDEFINED
}

class EmployeeLocation {
  Location location;
  String additionalInfo1;
  String additionalInfo2;

  EmployeeLocation({this.location, this.additionalInfo1, this.additionalInfo2});
}