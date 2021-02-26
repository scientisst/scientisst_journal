part of 'report_entry.dart';

class ImageEntry extends ReportEntry {
  String imagePath;

  ImageEntry.fromDocument(DocumentSnapshot doc)
      : imagePath = doc.data["path"],
        super(
          reference: doc.reference,
          timestamp: doc.data["timestamp"],
          text: doc.data["text"],
          type: "image",
        );

  String get legend => _text;

  Future<File> getImage() async => await Database.getFile(imagePath);
}
