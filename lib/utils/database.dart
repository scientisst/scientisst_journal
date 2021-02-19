import 'package:scientisst_db/scientisst_db.dart';
import 'package:scientisst_journal/data/historyEntry.dart';
import 'package:scientisst_journal/data/report.dart';
import 'package:scientisst_journal/data/reportEntry.dart';

class Database {
  static CollectionReference get _historyReference =>
      ScientISSTdb.instance.collection("history");

  static Stream<List<HistoryEntry>> getHistory() => _historyReference
      .orderBy("timestamp", ascending: false)
      .watchDocuments()
      .map(
        (List<DocumentSnapshot> docs) => List<HistoryEntry>.from(
          docs.map(
            (DocumentSnapshot doc) => HistoryEntry.fromDocument(doc),
          ),
        ),
      );

  static Future<Report> getReport(String id) async =>
      Report.fromDocument(await _historyReference.document(id).get());

  static Future<void> deleteHistoryEntry(String id) async =>
      await _historyReference.document(id).delete();

  static Future<Report> newReport() async {
    final DateTime now = DateTime.now();
    final String title = "Experiência sem título";
    final DocumentReference doc = await _historyReference.add(
      {
        "title": title,
        "type": "report",
        "timestamp": now,
      },
    );
    return Report(id: doc.id, title: title, timestamp: now);
  }

  static CollectionReference _reportEntires(String reportID) =>
      _historyReference.document(reportID).collection("entries");

  static Stream<List<ReportEntry>> getReportEntries(String reportID) =>
      _reportEntires(reportID).watchDocuments().map(
            (List<DocumentSnapshot> docs) => List<ReportEntry>.from(
              docs.map(
                (DocumentSnapshot doc) => ReportEntry.fromDocument(doc),
              ),
            ),
          );

  static Future<void> addReportNote(String reportID, String text) async {
    await _historyReference.document(reportID).collection("entries").add(
      {
        "timestamp": DateTime.now(),
        "text": text,
        "type": "note",
      },
    );
  }
}
