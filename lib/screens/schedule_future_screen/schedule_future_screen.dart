import 'package:flutter/material.dart';
import 'package:fmg_remote_work_tracker/models/employee_location.dart';
import 'package:fmg_remote_work_tracker/screens/schedule_future_screen/future_location_dialog.dart';
import 'package:fmg_remote_work_tracker/screens/schedule_future_screen/future_location_widget_handling.dart';
import 'package:fmg_remote_work_tracker/server_interaction/basic_interaction.dart';

class ScheduleFutureScreen extends StatefulWidget {
  final EmployeeAbsent defaultAbsence;
  final EmployeeAtOffice defaultOffice;

  ScheduleFutureScreen({this.defaultAbsence, this.defaultOffice});

  @override
  _ScheduleFutureScreenState createState() {
    return _ScheduleFutureScreenState(
        defaultAbsence: defaultAbsence,
        defaultOffice: defaultOffice);
  }
}

class _ScheduleFutureScreenState extends State<ScheduleFutureScreen> {
  Future<List<Widget>> futureLocationWidgets;

  final EmployeeAbsent defaultAbsence;
  final EmployeeAtOffice defaultOffice;

  _ScheduleFutureScreenState({this.defaultAbsence, this.defaultOffice});

  @override
  void initState() {
    super.initState();
    updateFutureLocations();
  }

  updateFutureLocations() {
    var futureLocations = getFutureLocations();
    setState(() {
      futureLocationWidgets = getLocationDateRangeDisplayWidgets(
          futureLocations, updateFutureLocations);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Schedule Future Locations"),
      ),
      body: FutureBuilder<List<Widget>>(
        future: futureLocationWidgets,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: snapshot.data,
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {showDialog(context: context,
        builder: (BuildContext context) {
          return createFutureLocationDialog(
              context,
                  () {
                updateFutureLocations();
                },
              defaultAbsence,
              defaultOffice,
              EmployeeLocation(location: Location.UNDEFINED));
        });}
      ),
    );
  }
}
