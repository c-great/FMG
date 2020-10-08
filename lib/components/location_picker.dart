import 'package:flutter/material.dart';
import 'package:fmg_remote_work_tracker/components/buttons.dart';
import 'package:fmg_remote_work_tracker/models/employee_location.dart';

class LocationPicker extends StatefulWidget {
  final EmployeeAbsent defaultAbsence;
  final EmployeeAtOffice defaultOffice;
  final EmployeeLocation startingLocation;
  final Function updateLocation;

  LocationPicker({this.defaultAbsence, this.defaultOffice, this.startingLocation, this.updateLocation});


  @override
  State<StatefulWidget> createState() {
    return _LocationPickerState(
      employeeLocation: startingLocation,
      selectedAbsenceType: defaultAbsence,
      selectedOfficeLocation: defaultOffice,
      updateLocation: updateLocation,
    );
  }
}

class _LocationPickerState extends State<LocationPicker> {
  EmployeeLocation employeeLocation;

  EmployeeAtOffice selectedOfficeLocation;
  EmployeeAbsent selectedAbsenceType;

  Function updateLocation;

  _LocationPickerState({this.employeeLocation, this.selectedAbsenceType, this.selectedOfficeLocation, this.updateLocation});

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
                updateLocation(selectedOfficeLocation);
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
                var home = new EmployeeAtHome();
                updateLocation(home);
                setState(() {
                  employeeLocation = home;
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
            updateLocation(selectedAbsenceType);
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
