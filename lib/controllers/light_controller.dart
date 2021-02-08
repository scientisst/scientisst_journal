import 'dart:async';

import 'package:flutter_sensors/flutter_sensors.dart';
import 'package:scientisst_journal/controllers/controller.dart';
import 'package:scientisst_journal/data/sensor_options.dart';
import 'package:scientisst_journal/data/sensor_value.dart';

class LightController extends Controller {
  StreamSubscription subscription;
  List<int> channels;
  int samplingRate;
  int _t;
  DateTime _timestamp;
  int _n;
  List data = [];
  final SensorOptions options;
  final int bufferSizeSeconds;

  LightController({this.options, this.bufferSizeSeconds = 5}) {
    this.channels = List<int>.from(
      List.generate(options.channels.length,
              (index) => options.channels[index] ? index : null)
          .where((index) => index != null),
    );
    this.samplingRate = options.samplingRate ?? 50;

    _t = 1000 ~/ samplingRate;
    _n = samplingRate * bufferSizeSeconds;
  }

  void start() async {
    final stream = await SensorManager().sensorUpdates(
      sensorId: 5,
      interval: Sensors.SENSOR_DELAY_FASTEST,
    );
    _timestamp = DateTime.now();
    _clearData();
    subscription = stream.listen(
      (sensorEvent) {
        _timestamp = DateTime.now();
        while (data.first.isNotEmpty &&
            _timestamp.difference(data.first.first.timestamp).inSeconds >
                bufferSizeSeconds) {
          for (int i = 0; i < channels.length; i++) {
            data[i].removeAt(0);
          }
        }
        for (int i = 0; i < channels.length; i++) {
          data[i].add(
            SensorValue(
              _timestamp,
              sensorEvent.data[channels[i]],
            ),
          );
        }
      },
    );
  }

  void _clearData() {
    data = List.generate(
      this.channels.length,
      (_) => List<SensorValue>.generate(
        _n,
        (int index) => SensorValue(
            DateTime.fromMillisecondsSinceEpoch(
                _timestamp.millisecondsSinceEpoch - (_n - 1 - index) * _t),
            0),
      ),
    );
  }

  void dispose() {
    subscription?.cancel();
  }
}
