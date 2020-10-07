import 'package:flutter/material.dart';
import 'package:fmg_remote_work_tracker/components/buttons.dart';
import 'package:intl/intl.dart';

class DateRangePicker extends StatefulWidget {
  final Function updateDateRange;

  final DateTime initialStart;
  final DateTime initialEnd;

  DateRangePicker({this.updateDateRange, this.initialStart, this.initialEnd});

  @override
  State<StatefulWidget> createState() {
    return _DateRangePickerState(
        updateDateRange: updateDateRange,
        initialStart: initialStart,
        initialEnd: initialEnd);
  }
}

class _DateRangePickerState extends State<DateRangePicker> {
  Future<DateTimeRange> futureDateRange;
  DateTimeRange dateRange;
  DateFormat dateFormat = DateFormat("d/M/y");

  Function updateDateRange;

  DateTime initialStart;
  DateTime initialEnd;

  _DateRangePickerState(
      {@required this.updateDateRange, this.initialStart, this.initialEnd});

  @override
  initState() {
    super.initState();
    if (initialStart != null && initialEnd != null) {
      dateRange = DateTimeRange(start: initialStart, end: initialEnd);
      futureDateRange = Future.value(dateRange);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LargeButton(
          child: Text("Select/Edit Date Range"),
          callback: () {
            setState(() {
              futureDateRange = showDateRangePicker(
                context: context,
                firstDate: DateTime.now(),
                initialDateRange: (dateRange != null)
                    ? dateRange
                    : null,
                lastDate: DateTime.now().add(Duration(days: 400)),
              );
            });
          },
        ),
        FutureBuilder(
          future: futureDateRange,
          builder:
              (BuildContext context, AsyncSnapshot<DateTimeRange> snapshot) {
            if (snapshot.hasData) {
              dateRange = snapshot.data;
              updateDateRange(dateRange);
              return Text(
                  "${dateFormat.format(dateRange.start)} - ${dateFormat.format(dateRange.end)}");
            } else {
              return Text("No Dates Set");
            }
          },
        )
      ],
    );
  }
}
