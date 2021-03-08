import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:scientisst_journal/data/sensors/sensor_value.dart';

class Utils {
  static String getTimeAgo(DateTime timestamp) {
    final Duration difference = DateTime.now().difference(timestamp);
    if (difference.inMinutes >= 60) {
      return DateFormat.Hms().format(timestamp);
    } else {
      return "${difference.inMinutes} min ago";
    }
  }

  static Future<List<List<SensorValue>>> parseCSV(File file) async {
    bool header = true;
    bool first = false;
    List<List<SensorValue>> data;
    int start;
    int nrChannels;
    await file
        .openRead()
        .map(utf8.decode)
        .transform(new LineSplitter())
        .forEach(
      (String line) {
        if (header) {
          header = false;
          first = true;
          nrChannels = line.split(",").length - 2;
          data = List.generate(nrChannels, (_) => <SensorValue>[]);
        } else {
          Iterable<num> fields =
              line.split(",").map((String field) => num.tryParse(field));
          if (first) {
            first = false;
            start = fields.last.toInt();
          }
          for (int i = 0; i < nrChannels; i++) {
            data[i].add(
              SensorValue(
                DateTime.fromMicrosecondsSinceEpoch(
                    start + fields.first.toInt()),
                fields.elementAt(i + 1),
              ),
            );
          }
        }
      },
    );
    return data;
  }
}
