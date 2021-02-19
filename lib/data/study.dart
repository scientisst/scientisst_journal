import 'package:flutter/material.dart';
import 'package:scientisst_db/scientisst_db.dart';
import 'package:scientisst_journal/data/historyEntry.dart';

class Study extends HistoryEntry {
  Study({@required id, title, @required timestamp})
      : super(id: id, type: "study", title: title, timestamp: timestamp);

  Study.fromDocument(DocumentSnapshot doc)
      : super(
          id: doc.id,
          type: "study",
          title: doc.data["title"],
          timestamp: DateTime.parse(doc.data["timestamp"]),
        );
}
