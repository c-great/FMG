import 'package:flutter/material.dart';
import 'package:fmg_remote_work_tracker/server_interaction/basic_interaction.dart';

class ScheduleFutureScreen extends StatefulWidget {


  @override
  _ScheduleFutureScreenState createState() {
    return _ScheduleFutureScreenState();
  }

}

class _ScheduleFutureScreenState extends State<ScheduleFutureScreen> {
  final context;
  Future<List<Widget>> futures;

  _ScheduleFutureScreenState({this.context});

  @override
  Widget build(BuildContext context) {
    getFutureLocations();

    return Scaffold(
      appBar: AppBar(
        title: Text("Schedule Future Locations"),
      ),

      body: ListView(
        children: [

        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: null,
      ),
    );
  }

}