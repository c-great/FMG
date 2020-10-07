import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fmg_remote_work_tracker/components/buttons.dart';
import 'package:intl/intl.dart';

class DateRangePicker extends StatefulWidget {
  Function updateDateRange;

  DateRangePicker({this.updateDateRange});

  @override
  State<StatefulWidget> createState() {
    return _DateRangePickerState(updateDateRange: updateDateRange);
  }

}

class _DateRangePickerState extends State<DateRangePicker> {
  Future<DateTimeRange> dateRange;
  DateFormat dateFormat = DateFormat("d/M/y");

  Function updateDateRange;

  _DateRangePickerState({this.updateDateRange});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LargeButton(
          child: Text("Select/Edit Date Range"),
          callback: () {
            setState(() {
              dateRange = showDateRangePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(Duration(days: 400)),
              );
            });
          },),
        FutureBuilder(
          future: dateRange,
          builder: (BuildContext context, AsyncSnapshot<DateTimeRange> snapshot) {
            if (snapshot.hasData) {
              DateTimeRange dates = snapshot.data;
              updateDateRange(dates);
              return Text(
                  "${dateFormat.format(dates.start)} - ${dateFormat.format(dates.end)}");
            } else {
              return Text("No Dates Set");
            }
          },

        )
      ],
    );
  }
}
