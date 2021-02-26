part of 'report_entry.dart';

class VideoEntry extends ReportEntry {
  String imagePath;
  int durationInMilliseconds;

  VideoEntry.fromDocument(DocumentSnapshot doc)
      : imagePath = doc.data["path"],
        durationInMilliseconds = doc.data["duration"],
        super(
          reference: doc.reference,
          timestamp: doc.data["timestamp"],
          text: doc.data["text"],
          type: "video",
        );

  String get legend => _text;

  Future<File> getVideo() async => await Database.getFile(imagePath);
}
