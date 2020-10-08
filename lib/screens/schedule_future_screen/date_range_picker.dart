import 'package:flutter/material.dart';
import 'package:fmg_remote_work_tracker/components/buttons.dart';
import 'package:intl/intl.dart';

class DateRangePicker extends StatefulWidget {
  final Function updateDateRange;

  final DateTime initialStart;
  final DateTime initialEnd;
  final Future<DateTime> dateOfInterestFuture;

  DateRangePicker(
      {this.updateDateRange,
      this.initialStart,
      this.initialEnd,
      this.dateOfInterestFuture});

  @override
  State<StatefulWidget> createState() {
    return _DateRangePickerState(
      updateDateRange: updateDateRange,
      initialStart: initialStart,
      initialEnd: initialEnd,
      dateOfInterestFuture: dateOfInterestFuture,
    );
  }
}

class _DateRangePickerState extends State<DateRangePicker> {
  Future<DateTimeRange> futureDateRange;
  DateTimeRange dateRange;
  DateFormat dateFormat = DateFormat("d/M/y");

  Function updateDateRange;

  DateTime initialStart;
  DateTime initialEnd;
  final Future<DateTime> dateOfInterestFuture;

  _DateRangePickerState(
      {@required this.updateDateRange,
      this.initialStart,
      this.initialEnd,
      this.dateOfInterestFuture});

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
          child: Row(children: [
            Expanded(child: Center(child: Text("Select/Edit Date Range"))),
            Icon(Icons.date_range),
          ]),
          callback: () async {
            DateTime dayOfInterest = await dateOfInterestFuture;
            setState(() {
              futureDateRange = showDateRangePicker(
                context: context,
                cancelText: "Discard",
                confirmText: "Confirm",
                // ensure the user can only select days starting from tomorrow
                firstDate: dayOfInterest.add(Duration(days: 1)),
                initialDateRange: (dateRange != null) ? dateRange : null,
                lastDate: dayOfInterest.add(Duration(days: 400)),
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
              dateRange = null;
              updateDateRange(dateRange);
              return Text("No Dates Set");
            }
          },
        )
      ],
    );
  }
}
