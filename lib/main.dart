import 'package:flutter/material.dart';
import 'package:fmg_remote_work_tracker/screens/login_screen/login_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:fmg_remote_work_tracker/theme/style.dart';
import 'package:fmg_remote_work_tracker/screens/home_screen/home_screen.dart';

void main() {
  // ensure all dates are formatted for NZ.
  initializeDateFormatting('en_NZ', null).then((_) => runApp(FmgApp()));
}

class FmgApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FMG Remote Work Tracker App',
      theme: appTheme(),
      home: LoginScreen(title: 'FMG - Remote Work Tracker'),
    );
  }
}
