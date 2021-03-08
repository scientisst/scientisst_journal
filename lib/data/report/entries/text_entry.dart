part of 'report_entry.dart';

class TextEntry extends ReportEntry {
  TextEntry.fromDocument(DocumentSnapshot doc, String reportID)
      : super(
          id: doc.id,
          reportID: reportID,
          created: doc.data["created"],
          modified: doc.data["modified"],
          text: doc.data["text"],
        );

  String get text => _text;
}
