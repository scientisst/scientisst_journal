import 'package:flutter/material.dart';
import 'package:scientisst_db/scientisst_db.dart';

class HistoryEntry {
  String id;
  String title;
  DateTime timestamp;
  String type;

  HistoryEntry(
      {@required this.id,
      @required this.type,
      @required this.title,
      @required this.timestamp}) {
    if (title != null) this.title = title;
  }

  HistoryEntry.fromDocument(DocumentSnapshot doc)
      : id = doc.id,
        type = doc.data["type"],
        title = doc.data["title"],
        timestamp = DateTime.parse(doc.data["timestamp"]);

  bool get isReport => type == "report";
  bool get isStudy => type == "study";
}
