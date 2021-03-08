part of 'report_entry.dart';

class VideoEntry extends FileEntry {
  int durationInMilliseconds;

  VideoEntry.fromDocument(DocumentSnapshot doc, String reportID)
      : durationInMilliseconds = doc.data["duration"],
        super(
          id: doc.id,
          reportID: reportID,
          created: doc.data["created"],
          modified: doc.data["modified"],
          text: doc.data["text"],
          type: "video",
          path: doc.data["path"],
        );

  String get caption => _text;

  Future<File> getVideo() async => await Database.getFile(path);
}
