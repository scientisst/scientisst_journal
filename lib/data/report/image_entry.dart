part of 'report_entry.dart';

class ImageEntry extends ReportEntry {
  String imagePath;

  ImageEntry.fromDocument(DocumentSnapshot doc)
      : imagePath = doc.data["image"],
        super(
          reference: doc.reference,
          timestamp: doc.data["timestamp"],
          text: doc.data["text"],
          type: "image",
        );

  String get caption => _text;

  Future<File> getImage() async => await Database.getFile(imagePath);
}
