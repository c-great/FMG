import 'package:flutter/material.dart';
import 'package:fmg_remote_work_tracker/screens/home_screen/manage_defaults.dart';
import 'package:fmg_remote_work_tracker/server_interaction/basic_interaction.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:fmg_remote_work_tracker/data/office_list.dart';
import 'package:fmg_remote_work_tracker/screens/list_screen/office_list_screen.dart';
import 'package:fmg_remote_work_tracker/models/employee_location.dart';


class CalendarScreen extends StatefulWidget {
  CalendarScreen({Key key}) : super(key: key);

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

        body: Container(
          child: SfCalendar(
              view: _calendarView,
              firstDayOfWeek: 1,
              dataSource: _getDataSource(),
              onTap: onCalendarTapped

          ),
        ),
      );
    }



    void onCalendarTapped(CalendarTapDetails calendarTapDetails) {
      if (calendarTapDetails.targetElement == CalendarElement.calendarCell) {
        setState(() {
          final result = Navigator.push(context, MaterialPageRoute(
              builder: (context) => OfficeListScreen()),);
        }
        );
      }
    }

  }

DataSource _getDataSource() {
 final List <Appointment> OfficeLocation = <Appointment>[];


    }


class DataSource extends CalendarDataSource{
  DataSource(List<Appointment> source){
    appointments = source;
  }

}




