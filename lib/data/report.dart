import 'package:flutter/material.dart';
import 'package:scientisst_db/scientisst_db.dart';

class Report {
  String id;
  String title = "Experiência sem título";
  DateTime timestamp;

  Report({@required this.id, title, @required this.timestamp}) {
    if (title != null) this.title = title;
  }

  Report.fromDocument(DocumentSnapshot doc) {
    id = doc.id;
    if (doc.data["title"]?.isNotEmpty ?? false) title = doc.data["title"];

    timestamp = DateTime.parse(doc.data["timestamp"]);
  }
}
