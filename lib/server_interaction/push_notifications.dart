import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fmg_remote_work_tracker/models/employee_location.dart';


// these streams will be used to pass information from push messages to listeners
StreamController<EmployeeLocation> employeeLocationDataStreamController = StreamController<EmployeeLocation>.broadcast();
Stream employeeLocationStream = employeeLocationDataStreamController.stream;

StreamController<DateTime> relevantDateDataStreamController = StreamController<DateTime>.broadcast();
Stream relevantDateStream = relevantDateDataStreamController.stream;

Future<dynamic> handleMessage(Map<String, dynamic> message) async {
  // ignore notifications, only handle data messages
  if (message.containsKey('data')) {
    final Map data = message['data'];

    // stream employee location data message
    if (data.containsKey('location')) {
      var castMap = data.cast<String, dynamic>();
      EmployeeLocation employeeLocation = EmployeeLocation.fromJSON(castMap);
      employeeLocationDataStreamController.add(employeeLocation);
    }

    // stream date data message
    if (data.containsKey('date')) {
      relevantDateDataStreamController.add(DateTime.parse(data['date']));
    }

  }
}

class PushNotificationsManager {

  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance = PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;

  Future<void> init() async {
    if (!_initialized) {
      // For iOS request permission first.
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.configure(
        onMessage: handleMessage,
        onBackgroundMessage: handleMessage,
      );

      _initialized = true;
    }
  }

   Future<String> getToken() async {
    String token = await _firebaseMessaging.getToken();
    return token;
  }
}