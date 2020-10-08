import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fmg_remote_work_tracker/screens/schedule_future_screen/schedule_future_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:fmg_remote_work_tracker/theme/style.dart';
import 'package:fmg_remote_work_tracker/screens/login_screen/login_screen.dart';
import 'package:fmg_remote_work_tracker/screens/home_screen/home_screen.dart';
import 'package:fmg_remote_work_tracker/screens/team_screen/team_screen.dart';
import 'package:fmg_remote_work_tracker/screens/calendar_screen/calendar_screen.dart';
import 'package:fmg_remote_work_tracker/server_interaction/push_notifications.dart';

void main() {
  // ensure all dates are formatted for NZ.
  initializeDateFormatting('en_NZ', null).then((_) => runApp(FmgApp()));
}

class FmgApp extends StatelessWidget {
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    // it looks really hideous in landscape, so this stops that
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    PushNotificationsManager().init();

    return MaterialApp(
      title: 'FMG Remote Work Tracker App',
      theme: appTheme(),
      home: LoginScreen(),
      // Routes are ways to navigate between screens.
      routes: <String, WidgetBuilder>{
        '/TeamScreen': (BuildContext context) => TeamPage(),
        '/HomeScreen': (BuildContext context) =>
            HomePage(title: 'FMG - Remote Work Tracker'),
        '/LoginScreen': (BuildContext context) => LoginScreen(),
        '/CalendarScreen': (BuildContext context) => CalendarScreen(),
        '/ScheduleFutureScreen': (BuildContext context) => ScheduleFutureScreen(),
      },
    );
  }
}
