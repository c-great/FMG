import 'package:flutter/material.dart';
import 'package:fmg_remote_work_tracker/screens/home_screen/manage_defaults.dart';
import 'package:fmg_remote_work_tracker/server_interaction/basic_interaction.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:fmg_remote_work_tracker/data/office_list.dart';
import 'package:fmg_remote_work_tracker/screens/list_screen/office_list_screen.dart';
import 'package:fmg_remote_work_tracker/models/employee_location.dart';


class CalendarScreen extends StatefulWidget {
  CalendarScreen({Key key, this.title}) : super(key: key);
  final String title;
  Future<EmployeeAtOffice> defaultOfficeFuture;

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

  class _CalendarScreenState extends State<CalendarScreen> {

    CalendarView _calendarView;

    Future<EmployeeAtOffice> defaultOfficeFuture;


    @override
    void initState() {
      _calendarView = CalendarView.month;
      defaultOfficeFuture = getDefaultOffice();

      super.initState();
    }


    @override
    Widget build(BuildContext context) {
      return Scaffold(
          body: SfCalendar(
            view: _calendarView,
            firstDayOfWeek: 1,
            dataSource: _getDataSource(),
            onTap:
          )
      );
    }

    Widget _getAppointmentEditor(BuildContext context, defaultOffice) {
      return Container(
          child: ListView(
              padding: const EdgeInsets.all(0),
              children: <Widget>[
                ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                  leading: Icon(Icons.location_city),
                  title: Text("Choose your Office Location"),
                  subtitle: Text(defaultOffice.officeLocation),
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      // Create the SelectionScreen in the next step.
                      MaterialPageRoute(
                          builder: (context) => OfficeListScreen()),
                    );
                    if (result != null) {
                      setDefaultOffice(result);
                      setState(() {
                        defaultOfficeFuture = Future.value(result);
                        defaultOffice = result;
                      });
                    }
                  },


                )
              ]
          )
      );
    }
  }

  void onCalendarTapped (CalendarTapDetails calendarTapDetails){
    if (calendarTapDetails.targetElement != CalendarElement.calendarCell &&
        calendarTapDetails.targetElement != CalendarElement.appointment) {
      return;
  }
    MaterialPageRoute(builder: (BuildContext context) => AppointmentEditor()),
    );
  }



DataSource _getDataSource() {
 final List <Appointment> OfficeLocation = <Appointment>[];
 OfficeLocation.add(Appointment(getDefaultOffice().toString()));
    }


class DataSource extends CalendarDataSource{
  DataSource(List<Appointment> source){
    appointments = source;
  }

}




