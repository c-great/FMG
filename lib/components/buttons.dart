import 'package:flutter/material.dart';
import 'package:fmg_remote_work_tracker/models/employee_location.dart';
import 'package:fmg_remote_work_tracker/screens/list_screen/absent_options_list_screen.dart';
import 'package:fmg_remote_work_tracker/screens/list_screen/office_list_screen.dart';

class LargeButton extends StatelessWidget {
  final Widget child;
  final VoidCallback callback;

  LargeButton({this.child, this.callback});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 50,
        child: RaisedButton(
          onPressed: this.callback,
          child: this.child,
        ));
  }
}

class OfficeDropDownButton extends StatefulWidget {
  OfficeDropDownButton({Key key}) : super(key: key);

  @override
  _OfficeDropDownButtonState createState() => _OfficeDropDownButtonState();
}

class _OfficeDropDownButtonState extends State<OfficeDropDownButton> {
  OfficeLocation dropdownValue = OfficeLocation.WELLINGTON;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<OfficeLocation>(
      value: dropdownValue,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (OfficeLocation newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: OfficeLocation.values
          .map<DropdownMenuItem<OfficeLocation>>((OfficeLocation value) {
        return DropdownMenuItem<OfficeLocation>(
          value: value,
          child: Text(value.asString()),
        );
      }).toList(),
    );
  }
}

class OfficeSelectButton extends StatefulWidget {
  final Function update;

  OfficeSelectButton({Key key, this.update}) : super(key: key);

  @override
  _OfficeSelectButtonState createState() => _OfficeSelectButtonState(update: update);
}

class _OfficeSelectButtonState extends State<OfficeSelectButton> {
  final Function update;

  _OfficeSelectButtonState({this.update});

  EmployeeAtOffice location =
      EmployeeAtOffice(officeLocation: OfficeLocation.WELLINGTON);

  _navigateToOfficeSelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) => OfficeListScreen()),
    );
    if (result != null) {
      location = result;
      setState(() {});
      update(location);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 50,
        child: RaisedButton(
          child: Row(children: [
            //fixme: something slightly wrong with this, gives a warning I think
            Expanded(child: Center(child: Text(location.officeLocation.asString())),),
            Icon(Icons.menu)
          ],),
          color: Theme.of(context).primaryColorLight,
          onPressed: () {
            _navigateToOfficeSelection(context);
          },
        ));
  }
}

class AbsenceTypeSelectButton extends StatefulWidget {
  final Function update;

  AbsenceTypeSelectButton({Key key, this.update}) : super(key: key);

  @override
  _AbsenceTypeSelectButtonState createState() => _AbsenceTypeSelectButtonState(update: update);
}

class _AbsenceTypeSelectButtonState extends State<AbsenceTypeSelectButton> {
  final Function update;

  _AbsenceTypeSelectButtonState({this.update});

  EmployeeAbsent location =
  EmployeeAbsent(absenceType: AbsentOptions.ANNUAL_LEAVE);

  _navigateToOfficeSelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) => AbsenceTypeListScreen()),
    );
    if (result != null) {
      setState(() {
        location = result;
      });
      update(location);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 50,
        child: RaisedButton(
          child: Row(children: [
            //fixme: something slightly wrong with this, gives a warning I think
            Expanded(child: Center(child: Text(location.absenceType.asString())),),
            Icon(Icons.menu)
          ],),
          color: Theme.of(context).primaryColorLight,
          onPressed: () {
            _navigateToOfficeSelection(context);
          },
        ));
  }
}
