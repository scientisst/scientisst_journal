part of 'report_entry.dart';

class ImageEntry extends FileEntry {
  ImageEntry.fromDocument(DocumentSnapshot doc, String reportID)
      : super(
          reportID: reportID,
          id: doc.id,
          created: doc.data["created"],
          modified: doc.data["modified"],
          text: doc.data["text"],
          type: "image",
          path: doc.data["path"],
        );

  Future<File> getImage() async => await Database.getFile(path);
}
