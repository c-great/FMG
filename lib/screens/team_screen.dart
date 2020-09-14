import 'package:flutter/material.dart';
import 'package:fmg_remote_work_tracker/screens/home_screen/home_screen.dart';

// Screen for displaying team information.
class TeamPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("My Teams"),
        ),
        body: Center(
            child: RaisedButton(
                child: Text("Home"),
                onPressed: () {
                  Navigator.pop(context);
                }
            )
        )
    );
  }
}