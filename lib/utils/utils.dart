import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:scientisst_journal/data/sensors/sensor_options.dart';
import 'package:scientisst_journal/data/sensors/sensor_value.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static String getTimeAgo(DateTime timestamp) {
    final Duration difference = DateTime.now().difference(timestamp);
    if (difference.inMinutes >= 60) {
      return DateFormat.Hms().format(timestamp);
    } else {
      return "${difference.inMinutes} min ago";
    }
  }

  static Future<List<List<SensorValue>>> parseTimeSeries(File file) async {
    assert(file.path.endsWith(".txt"));
    bool header = true;
    List<List<SensorValue>> data;
    int start;
    int nrChannels;
    SensorOptions options;
    await file
        .openRead()
        .map(utf8.decode)
        .transform(new LineSplitter())
        .forEach(
      (String line) {
        if (header) {
          header = false;
          Map<String, dynamic> map = jsonDecode(line.substring(1));
          options = SensorOptions.fromMap(map);
          start = map["microsecondsSinceEpoch"];
          nrChannels = options.nrChannels;
          data = List.generate(nrChannels, (_) => <SensorValue>[]);
        } else {
          Iterable<num> fields =
              line.split("\t").map((String field) => num.tryParse(field));
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

  static Future<void> launchURL(String url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
}
