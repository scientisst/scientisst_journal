part of 'report_entry.dart';

class TextEntry extends ReportEntry {
  TextEntry.fromDocument(DocumentSnapshot doc)
      : super(
          reference: doc.reference,
          timestamp: doc.data["timestamp"],
          text: doc.data["text"],
          type: "text",
        );

  String get text => _text;
}
