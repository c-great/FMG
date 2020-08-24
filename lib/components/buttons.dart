import 'package:flutter/material.dart';
import 'package:fmg_remote_work_tracker/models/employee_location.dart';

class LargeButton extends StatelessWidget {
  final Widget child;
  final VoidCallback callback;

  LargeButton({this.child, this.callback});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: 50,
        child: RaisedButton(
          onPressed: this.callback,
          child: this.child,
        )
    );
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
      items: OfficeLocation
          .values
          .map<DropdownMenuItem<OfficeLocation>>((OfficeLocation value) {
        return DropdownMenuItem<OfficeLocation>(
          value: value,
          child: Text(value.asString()),
        );
      }).toList(),
    );
  }
}
