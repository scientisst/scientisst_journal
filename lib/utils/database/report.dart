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
    Directory report =
        await Database._historyReference.document(reportID).export();
    Directory files =
        await Database._reportsFilesReference.directory(reportID).export();

    final String folderPath = path ?? (await getTemporaryDirectory()).path;
    final String filepath = "$folderPath/$reportID.report.zip";
    // Manually create a zip of a directory and individual files.
    final ZipFileEncoder encoder = ZipFileEncoder();
    encoder.create(filepath);
    if (report != null) encoder.addDirectory(report);
    if (files != null) encoder.addDirectory(files);
    encoder.close();

    report?.delete(recursive: true);
    files?.delete(recursive: true);

    return File(filepath);
  }

  static Future<void> importReport(File file) async {
    if (file.path.endsWith(".report.zip")) {
      final String id = file.path.split("/").last.split(".").first;
      final String tmp = (await getTemporaryDirectory()).path + "/$id";

      final bytes = file.readAsBytesSync();

      //Decode the Zip file
      final archive = ZipDecoder().decodeBytes(bytes);

      //Extract the contents of the Zip archive to disk.
      for (final file in archive) {
        final filename = file.name;
        if (file.isFile) {
          if (filename.startsWith("$id.db/")) {
            final String filepath = "$tmp/" + filename;
            _checkCreateDir(filepath);

            final data = file.content as List<int>;
            File(filepath).writeAsBytesSync(data);
          } else if (filename.startsWith("$id.files/")) {
            final String filepath = "$tmp/" + filename;
            _checkCreateDir(filepath);

            final data = file.content as List<int>;
            File(filepath).writeAsBytesSync(data);
          }
        }
      }

      await Database._historyReference.import(Directory("$tmp/$id.db"));
      await Database._reportsFilesReference.import(Directory("$tmp/$id.files"));
      Directory(tmp).deleteSync(recursive: true);
    } else {
      throw Exception("This is not a report");
    }
  }

  static void _checkCreateDir(String filepath) {
    List<String> parts = filepath.split("/");
    if (parts.length > 1) {
      parts = parts.sublist(0, parts.length - 1);
    }
    Directory(parts.join("/")).createSync(recursive: true);
  }
}
