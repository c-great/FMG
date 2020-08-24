import 'package:flutter/material.dart';

ThemeData appTheme() {
  return ThemeData(
    // made green because it is FMG's colour. But I haven't tried to match
    // the exact shade yet.
    primarySwatch: Colors.green,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}