import 'package:flutter/material.dart';
import 'package:fmg_remote_work_tracker/components/buttons.dart';
import 'package:fmg_remote_work_tracker/models/employee_location.dart';

class LocationPicker extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LocationPickerState();
  }
}

class _LocationPickerState extends State<LocationPicker> {
  EmployeeLocation employeeLocation =
      EmployeeLocation(location: Location.UNDEFINED);

  EmployeeAtOffice selectedOfficeLocation =
      EmployeeAtOffice(officeLocation: "flies");
  EmployeeAbsent selectedAbsenceType =
      EmployeeAbsent(absenceType: AbsentOptions.SICK_LEAVE);

  _LocationPickerState();

  Widget _expandedRow({List<Widget> children}) {
    var expandedChildren = children.map((e) => Expanded(
          child: e,
        ));
    return Expanded(
        child: Row(
      children: expandedChildren.toList(),
    ));
  }

  List<Widget> _getButtons() {
    return [
      _expandedRow(
        children: [
          OfficeSelectButton(
            starting: selectedOfficeLocation,
            update: (newOfficeSelected) {
              selectedOfficeLocation = newOfficeSelected;
            },
          ),
          LargeButton(
              child: Row(children: [
                Expanded(
                  child: Center(child: Text("Office")),
                ),
                Icon(Icons.location_city),
              ]),
              callback: () {
                setState(() {
                  employeeLocation = selectedOfficeLocation;
                });
              }),
        ],
      ),
      _expandedRow(
        children: [
          Container(),
          LargeButton(
              child: Row(children: [
                Expanded(
                  child: Center(child: Text("Home")),
                ),
                Icon(Icons.home),
              ]),
              callback: () {
                setState(() {
                  employeeLocation = new EmployeeAtHome();
                });
              }),
        ],
      ),
      _expandedRow(children: [
        AbsenceTypeSelectButton(
          starting: selectedAbsenceType,
          update: (newAbsenceSelected) {
            selectedAbsenceType = newAbsenceSelected;
          },
        ),
        LargeButton(
          child: Row(children: [
            Expanded(
              child: Center(child: Text("Absent")),
            ),
            Icon(Icons.beach_access),
          ]),
          callback: () {
            setState(() {
              employeeLocation = selectedAbsenceType;
            });
          },
        ),
      ]),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.max, children: [
      employeeLocation.display(),
      SizedBox(height: 200, child: Column(children: _getButtons()))
    ]);
  }
}
