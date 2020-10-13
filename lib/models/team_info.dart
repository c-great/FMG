import 'package:fmg_remote_work_tracker/import/import_excel.dart';

class TeamInfo {
  var teamExcel = ImportExcel();

  void teamName() {
    var data = teamExcel.readExcel();
    print(data);
  }

}