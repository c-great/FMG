import 'package:flutter/material.dart';

ThemeData appTheme() {
  return ThemeData(
    // made green because it is FMG's colour. But I haven't tried to match
    // the exact shade yet.
    primarySwatch: Colors.green,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

// style for main location text on home page.
TextStyle locationTitle() {
  return TextStyle(
    fontSize: 40
  );
}

// style for sub location text on home page.
TextStyle subTitle() {
  return TextStyle(
      fontSize: 20
  );
}

// style for date information at top of home page.
TextStyle dateDisplay() {
  return TextStyle(
    fontSize: 20
  );
}