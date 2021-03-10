part of 'report_entry.dart';

class TimeSeriesEntry extends FileEntry {
  List<String> labels;
  TimeSeriesEntry({
    @required String reportID,
    @required String id,
    @required DateTime created,
    @required DateTime modified,
    @required String text,
    @required String type,
    @required String path,
    this.labels,
  }) : super(
          reportID: reportID,
          id: id,
          text: text,
          type: type,
          created: created,
          modified: modified,
          path: path,
        );

  Future<List<List<SensorValue>>> getData() async =>
      Utils.parseTimeSeries(await Database.getFile(path));
}
