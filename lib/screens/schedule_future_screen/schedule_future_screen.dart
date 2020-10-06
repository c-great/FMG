import 'package:flutter/material.dart';
import 'package:fmg_remote_work_tracker/screens/schedule_future_screen/future_location_widget_handling.dart';
import 'package:fmg_remote_work_tracker/server_interaction/basic_interaction.dart';

class ScheduleFutureScreen extends StatefulWidget {


  @override
  _ScheduleFutureScreenState createState() {
    return _ScheduleFutureScreenState();
  }

}

class _ScheduleFutureScreenState extends State<ScheduleFutureScreen> {
  final context;
  Future<List<Widget>> futureLocationWidgets;

  _ScheduleFutureScreenState({this.context});

  updateFutureLocations() {
    var futureLocations = getFutureLocations();
    setState(() {
      futureLocationWidgets = getLocationDateRangeDisplayWidgets(futureLocations);
    });
  }

  @override
  Widget build(BuildContext context) {
    updateFutureLocations();

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
        onPressed: null,
      ),
    );
  }

}