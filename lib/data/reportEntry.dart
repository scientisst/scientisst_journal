import 'package:scientisst_db/scientisst_db.dart';

class ReportEntry {
  DateTime timestamp;
  String text;

  ReportEntry.fromDocument(DocumentSnapshot doc)
      : timestamp = DateTime.parse(doc.data["timestamp"]),
        text = doc.data["text"];
}
