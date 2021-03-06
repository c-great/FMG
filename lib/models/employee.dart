class Employee {
  String employeeID;
  String firstName;
  String lastName;
  String loginName;
  bool manager;
  String managerID;
  bool admin;

  Employee();

  factory Employee.fromJSON(Map<String, dynamic> json) {
    Employee employee = new Employee();
    employee.employeeID = json['employeeID'];
    employee.firstName = json['firstName'];
    employee.lastName = json['lastName'];
    employee.loginName = json['loginName'];
    employee.manager = json['manager'];
    employee.managerID = json['managerID'];
    employee.admin = json['admin'];

    return employee;
  }
}