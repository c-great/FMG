import 'package:flutter/material.dart';
import 'package:fmg_remote_work_tracker/import/import_excel.dart';
import 'package:fmg_remote_work_tracker/models/employee_location.dart';

class TeamInfo {
  var teamExcel = ImportExcel();

  void teamName() {
    var data = teamExcel.readExcel();
    print(data);
  }

}