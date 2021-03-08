part of '../history_entry.dart';

class Study extends HistoryEntry {
  Study({@required id, title, @required created})
      : super(id: id, type: "study", title: title, created: created);

  Study.fromDocument(DocumentSnapshot doc)
      : super(
          id: doc.id,
          type: "study",
          title: doc.data["title"],
          created: doc.data["created"],
        );
}
