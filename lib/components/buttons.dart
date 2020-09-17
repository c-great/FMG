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
        height: 70,
        child: RaisedButton(
          onPressed: this.callback,
          child: this.child,
        ));
  }
}

class OfficeSelectButton extends StatefulWidget {
  final Function update;
  final EmployeeAtOffice starting;

  OfficeSelectButton({Key key, this.update, this.starting}) : super(key: key);

  @override
  _OfficeSelectButtonState createState() =>
      _OfficeSelectButtonState(update: update, location: starting);
}

class _OfficeSelectButtonState extends State<OfficeSelectButton> {
  final Function update;
  EmployeeAtOffice location;

  _OfficeSelectButtonState({this.update, this.location});

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
    return _makeSelectScreenButton(context, location.officeLocation, _navigateToOfficeSelection);
  }
}

class AbsenceTypeSelectButton extends StatefulWidget {
  final Function update;
  final EmployeeAbsent starting;

  AbsenceTypeSelectButton({Key key, this.update, this.starting}) : super(key: key);

  @override
  _AbsenceTypeSelectButtonState createState() =>
      _AbsenceTypeSelectButtonState(update: update, location: starting);
}

class _AbsenceTypeSelectButtonState extends State<AbsenceTypeSelectButton> {
  final Function update;
  EmployeeAbsent location;

  _AbsenceTypeSelectButtonState({this.update, this.location});

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
    return _makeSelectScreenButton(context, location.absenceType.asString(), _navigateToOfficeSelection);
  }
}

Widget _makeSelectScreenButton(BuildContext context, String label, Function onPress) {
  return SizedBox(
      height: 70,
      child: RaisedButton(
        child: Row(children: [
          Expanded(child: Center(child: Text(label)),),
          Icon(Icons.menu)
        ],),
        color: Theme.of(context).primaryColorLight,
        onPressed: () {
          onPress(context);
        },
      ));
}