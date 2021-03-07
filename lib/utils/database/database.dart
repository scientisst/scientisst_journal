import 'dart:io';
import 'dart:typed_data';

import 'package:scientisst_db/scientisst_db.dart';
import 'package:scientisst_journal/data/history_entry.dart';
import 'package:scientisst_journal/data/report/report.dart';
import 'package:scientisst_journal/data/report/report_entry.dart';
import 'package:archive/archive_io.dart';
import 'package:path_provider/path_provider.dart';

part 'report.dart';

class Database {
  static CollectionReference get _historyReference =>
      ScientISSTdb.instance.collection("history");

  static DirectoryReference get _reportsFilesReference =>
      ScientISSTdb.instance.files.directory("reports");

  static Stream<List<HistoryEntry>> getHistory() => _historyReference
      .orderBy("timestamp", descending: true)
      .watchDocuments()
      .map(
        (List<DocumentSnapshot> docs) => List<HistoryEntry>.from(
          docs.map(
            (DocumentSnapshot doc) => HistoryEntry.fromDocument(doc),
          ),
        ),
      );

  static Future<void> deleteHistoryEntry(String id) async {
    await _historyReference.document(id).delete();
    try {
      await _reportsFilesReference.directory(id).delete();
    } on FileSystemException catch (e) {
      if (e.osError.errorCode != 2)
        throw e; // if error is not "No such file or directory"

    }
  }

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

  static Future<File> getFile(String path) async =>
      await ScientISSTdb.instance.files.file(path).getFile();
}