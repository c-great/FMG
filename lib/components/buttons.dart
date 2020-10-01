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
    return RaisedButton(
      onPressed: this.callback,
      child: this.child,
    );
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
    return _makeSelectScreenButton(
        context,
        _makeSelectScreenButtonLabel(location.officeLocation, location.additionalInfo, context),
        _navigateToOfficeSelection);
  }
}

class AbsenceTypeSelectButton extends StatefulWidget {
  final Function update;
  final EmployeeAbsent starting;

  AbsenceTypeSelectButton({Key key, this.update, this.starting})
      : super(key: key);

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
    return _makeSelectScreenButton(
        context,
        _makeSelectScreenButtonLabel(location.absenceType.asString(), location.additionalInfo, context),
        _navigateToOfficeSelection);
  }
}

Widget _makeSelectScreenButton(
    BuildContext context, Widget label, Function onPress) {
  return RaisedButton(
    child: Row(
      children: [
        Expanded(
          child: label,
        ),
        Icon(Icons.menu)
      ],
    ),
    color: Theme.of(context).primaryColorLight,
    onPressed: () {
      onPress(context);
    },
  );
}

Widget _makeSelectScreenButtonLabel(String main, String sub, BuildContext context) {
  if (sub == null) {
    return Center(child: Text(main));
  } else {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
      Text(main),
      Text(sub, style: Theme.of(context).primaryTextTheme.subtitle1),
    ],);
  }
}
