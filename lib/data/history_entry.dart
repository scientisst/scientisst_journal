import 'package:flutter/material.dart';
import 'package:scientisst_db/scientisst_db.dart';

part 'report/report.dart';
part 'study/study.dart';

abstract class HistoryEntry {
  String id;
  String title;
  DateTime created;
  String type;

  HistoryEntry(
      {@required this.id,
      @required this.type,
      @required this.title,
      @required this.created});

  static HistoryEntry fromDocument(DocumentSnapshot doc) {
    final String type = doc.data["type"];
    if (type == "report") {
      return Report.fromDocument(doc);
    } else if (type == "study") {
      return Study.fromDocument(doc);
    } else {
      throw Exception("Invalid history entry type");
    }
  }
}
