import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scientisst_db/scientisst_db.dart';

class TimeSeriesRecorder {
  File file;
  IOSink sink;
  int rowNumber = 0;
  int step;
  String filepath;
  int nrChannels;
  int start;
  List<String> labels;

  TimeSeriesRecorder({
    @required this.nrChannels,
    this.labels,
    int fs,
  }) {
    assert(labels != null || labels.length == nrChannels);
    if (fs != null) step = (1000 ~/ fs);
  }

  Future<void> init({String filepath}) async {
    assert(filepath == null || (filepath != null && filepath.endsWith(".csv")));
    this.filepath = filepath;
    if (filepath == null) {
      String folderPath = (await getTemporaryDirectory()).path;
      filepath = "$folderPath/${ObjectId().id}.csv";
    }
    file = File(filepath);

    writeHeader();
  }

  void writeHeader() {
    sink = file.openWrite(mode: FileMode.append);
    List<String> header = [
      "microsecondsSinceStart",
    ];
    if (labels != null) {
      labels.forEach((String label) {
        header.add(label);
      });
    } else {
      for (int i = 0; i < nrChannels; i++) {
        header.add("a$i");
      }
    }
    header.add("microsecondsSinceEpoch");
    sink.write(header.join(",") + "\n");
  }

  void writeRow({
    @required Iterable<num> values,
    DateTime timestamp,
  }) {
    final int microsecondsSinceStart =
        timestamp?.microsecondsSinceEpoch ?? currentMills();
    final String valuesJoined = values.join(",");
    if (rowNumber == 0) {
      start = microsecondsSinceStart;
      sink.write("0,$valuesJoined,$microsecondsSinceStart\n");
    } else {
      sink.write("${microsecondsSinceStart - start},$valuesJoined\n");
    }
    rowNumber++;
  }

  File closeFile() {
    sink?.close();
    return file;
  }

  int currentMills() {
    return rowNumber * step;
  }
}
