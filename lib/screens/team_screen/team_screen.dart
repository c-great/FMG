import 'package:flutter/material.dart';
import 'package:fmg_remote_work_tracker/models/employee.dart';
import 'package:fmg_remote_work_tracker/models/employee_location.dart';
import 'dart:core';
import 'package:fmg_remote_work_tracker/server_interaction/basic_interaction.dart';

import 'employee_cards.dart';

// fixme: Clean up all the useless comments when done. Most likely also the Team class itself
// Screen for displaying team information.
class TeamPage extends StatefulWidget {
  final EmployeeAbsent defaultAbsence;
  final EmployeeAtOffice defaultOffice;

  TeamPage({@required this.defaultAbsence, @required this.defaultOffice});

  @override
  _TeamPageState createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  Future<List<Employee>> reportingEmployeesFuture;
  Future<Map<String, EmployeeLocation>> reportingEmployeeLocationsFuture;

  List<Widget> employeeWidgets;

  @override
  void initState() {
    super.initState();

    reportingEmployeesFuture = getDirectReports();
    reportingEmployeeLocationsFuture = getDirectReportLocations();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Manager View"),
        ),
        body: FutureBuilder(
          future: Future.wait(
              [reportingEmployeesFuture, reportingEmployeeLocationsFuture]),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              List<Employee> reportingEmployees = snapshot.data[0];
              Map<String, EmployeeLocation> reportingEmployeeLocations =
                  snapshot.data[1];

              List<Widget> employeeCards = createEmployeeCards(
                  context, reportingEmployees, reportingEmployeeLocations,
                  defaultOffice: widget.defaultOffice,
                  defaultAbsence: widget.defaultAbsence,
                  update: () {
                    setState(() {
                      reportingEmployeesFuture = getDirectReports();
                      reportingEmployeeLocationsFuture = getDirectReportLocations();
                    });
                  });

              return ListView(
                children: employeeCards,
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
