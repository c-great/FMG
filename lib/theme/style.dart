import 'package:flutter/material.dart';

ThemeData appTheme() {
  return ThemeData(
    // matched FMG color for primary
    primaryColor: Color(0xFF006938),
    primaryColorLight: Color(0xFF419863),
    primaryColorDark: Color(0xFF003d11),
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