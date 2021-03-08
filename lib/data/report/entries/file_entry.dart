part of 'report_entry.dart';

abstract class FileEntry extends ReportEntry {
  String path;

  FileEntry(
      {@required String reportID,
      @required String id,
      @required DateTime created,
      @required DateTime modified,
      @required String text,
      @required String type,
      @required this.path})
      : super(
          reportID: reportID,
          id: id,
          text: text,
          type: type,
          created: created,
          modified: modified,
        );

  Future<void> delete() async {
    await super.delete();
    await Database.deleteFile(path);
  }

  String get caption => _text;
}
