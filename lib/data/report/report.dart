import 'package:flutter/material.dart';
import 'package:scientisst_db/scientisst_db.dart';
import 'package:scientisst_journal/data/history_entry.dart';

class Report extends HistoryEntry {
  Report({@required id, @required title, @required timestamp})
      : super(id: id, type: "report", title: title, timestamp: timestamp);

  Report.fromDocument(DocumentSnapshot doc)
      : super(
          id: doc.id,
          type: "report",
          title: doc.data["title"],
          timestamp: doc.data["timestamp"],
        );
}
