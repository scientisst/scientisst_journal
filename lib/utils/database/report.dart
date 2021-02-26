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
        "text": "Caption",
        "image": reference.path,
        "type": "text",
      },
    );
  }
}
