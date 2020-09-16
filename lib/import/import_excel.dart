import 'package:excel/excel.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;



//var file = "teams.xlsx";
//var bytes =  File(file) .readAsBytesSync();
//var excel = Excel.decodeBytes(bytes);

class ImportExcel {

  readExcel() async {
    ByteData data = await rootBundle.load("assets/teams.xlsx");
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);

    for (var table in excel.tables.keys) {
      print(table); //sheet Name
      print(excel.tables[table].maxCols);
      print(excel.tables[table].maxRows);
      for (var row in excel.tables[table].rows) {
        print("$row");
      }
    }

  }

}
