part of "database.dart";

class ReportFunctions {
  static Future<Report> getReport(String id) async =>
      Report.fromDocument(await Database._historyReference.document(id).get());

  static CollectionReference _reportEntires(String reportID) =>
      Database._historyReference.document(reportID).collection("entries");

  static Stream<List<ReportEntry>> getReportEntries(String reportID) =>
      _reportEntires(reportID).watchDocuments().map(
            (List<DocumentSnapshot> docs) => List<ReportEntry>.from(
              docs.map(
                (DocumentSnapshot doc) => ReportEntry.getEntry(doc),
              ),
            ),
          );

  static Future<void> addReportNote(String reportID, String text) async {
    await Database._historyReference
        .document(reportID)
        .collection("entries")
        .add(
      {
        "timestamp": DateTime.now(),
        "text": text,
        "type": "text",
      },
    );
  }

  static Future<void> addReportImage(String reportID, Uint8List image) async {
    final FileReference reference = await Database._reportsFilesReference
        .directory(reportID)
        .putBytes(image, "${ObjectId().id}.jpg");
    await Database._historyReference
        .document(reportID)
        .collection("entries")
        .add(
      {
        "timestamp": DateTime.now(),
        "text": "caption",
        "image": reference.path,
        "type": "image",
      },
    );
  }

  static Future<void> changeTitle(String reportID, String title) async {
    print(title);
    await ScientISSTdb.instance
        .collection("history")
        .document(reportID)
        .updateData(
      {
        "title": title,
      },
    );
  }

  static Future<File> exportReport(String reportID, {String path}) async {
    // Either the permission was already granted before or the user just granted it.
    File report = await ScientISSTdb.instance
        .collection("history")
        .document(reportID)
        .export();
    File files =
        await Database._reportsFilesReference.directory(reportID).export();

    final String folderPath = path ?? (await getTemporaryDirectory()).path;
    final String filepath = "$folderPath/$reportID.report.zip";
    // Manually create a zip of a directory and individual files.
    final ZipFileEncoder encoder = ZipFileEncoder();
    encoder.create(filepath);
    if (report != null) encoder.addFile(report);
    if (files != null) encoder.addFile(files);
    encoder.close();

    report?.deleteSync();
    files?.deleteSync();

    return File(filepath);
  }

  static Future<void> importReport(File file) async {
    if (file.path.endsWith(".report.zip")) {
      final String id = file.path.split("/").last.split(".").first;

      final bytes = file.readAsBytesSync();

      // Decode the Zip file
      final archive = ZipDecoder().decodeBytes(bytes);

      // Extract the contents of the Zip archive to disk.
      for (final file in archive) {
        final filename = file.name;
        if (file.isFile) {
          final data = file.content as List<int>;
          if (filename.endsWith(".db.zip")) {
            ScientISSTdb.instance
                .collection("history")
                .importFromBytes(data, id);
          } else if (filename.endsWith(".files.zip")) {
            Database._reportsFilesReference.importFromBytes(data);
          }
        }
      }
    } else {
      throw Exception("This is not a report");
    }
  }
}
