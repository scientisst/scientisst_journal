part of '../history_entry.dart';

class Report extends HistoryEntry {
  Report({@required id, @required title, @required created})
      : super(id: id, type: "report", title: title, created: created);

  Report.fromDocument(DocumentSnapshot doc)
      : super(
          id: doc.id,
          type: "report",
          title: doc.data["title"],
          created: doc.data["created"],
        );
}
