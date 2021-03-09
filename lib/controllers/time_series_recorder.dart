import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scientisst_db/scientisst_db.dart';

class TimeSeriesRecorder {
  File file;
  IOSink sink;
  int rowNumber = -1;
  int step;
  String filepath;
  List<int> channels;
  int start;
  List<String> labels;
  String deviceName;
  List<String> units;
  bool writing = true;

  TimeSeriesRecorder({
    @required this.channels,
    this.labels,
    int fs,
    this.deviceName,
    this.units,
  }) {
    assert(channels != null && nrChannels > 0);
    assert(labels == null || labels.length == nrChannels);
    assert(units == null || units.length == nrChannels);
    if (fs != null) step = (1000000 ~/ fs);
    if (units == null) units = List<String>.generate(nrChannels, (_) => "RAW");
    if (labels == null)
      labels = List<String>.generate(nrChannels, (int i) => "A$i");
  }

  int get nrChannels => this.channels.length;

  Future<void> init({String filepath}) async {
    assert(filepath == null || (filepath != null && filepath.endsWith(".txt")));
    if (filepath == null) {
      String folderPath = (await getTemporaryDirectory()).path;
      filepath = "$folderPath/${ObjectId().id}.txt";
    } else {
      this.filepath = filepath;
    }
    file = File(filepath);
  }

  void writeHeader({@required DateTime start}) {
    sink = file.openWrite(mode: FileMode.append);
    sink.write("#");
    final Map<String, dynamic> metadata = {};
    metadata["units"] = units;
    metadata["label"] = labels;
    metadata["device_name"] = deviceName ?? "";
    metadata["column"] = List.generate(nrChannels, (int i) => "A$i")
      ..insert(0, "timestamp");
    metadata["channels"] = channels;

    final String timestamp = start.toIso8601String();
    metadata["date"] = timestamp.substring(0, 10);
    metadata["time"] = timestamp.substring(11).replaceFirst("Z", "");
    this.start = start.microsecondsSinceEpoch;
    metadata["microsecondsSinceEpoch"] = this.start;

    sink.write(jsonEncode(metadata));
    sink.write("\n");
  }

  Future<void> writeRow({
    @required Iterable<num> values,
    @required DateTime timestamp,
  }) async {
    assert(timestamp != null);
    if (writing) {
      rowNumber++;
      if (rowNumber == 0) writeHeader(start: timestamp);
      sink?.write(
          "${timestamp.microsecondsSinceEpoch - start}\t${values.join("\t")}\n");
    }
  }

  File closeFile() {
    writing = false;
    sink?.close();
    return file;
  }

  int currentMills() {
    return rowNumber * step;
  }
}
