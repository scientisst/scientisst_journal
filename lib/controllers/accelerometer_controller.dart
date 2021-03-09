import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sensors/flutter_sensors.dart';
import 'package:scientisst_journal/controllers/controller.dart';
import 'package:scientisst_journal/controllers/controller_interface.dart';
import 'package:scientisst_journal/data/sensors/sensor_value.dart';

class AccelerometerController extends Controller
    implements ControllerInterface {
  DateTime _timestamp;
  List data = [];

  AccelerometerController(
      {@required List<bool> channels, int bufferSizeSeconds = 5})
      : super(
          bufferSizeSeconds: bufferSizeSeconds,
          channels: channels,
          labels: ["x", "y", "z"],
          units: ["m/s2", "m/s2", "m/s2"],
          deviceName: "accelerometer",
        ) {
    data = List<List<SensorValue>>.generate(
      nrChannels,
      (_) => <SensorValue>[],
    );
  }

  Stream<List<List<SensorValue>>> listen({int refreshRate = 30}) async* {
    double interval = (refreshRate != null ? 1000 / refreshRate : 0);

    DateTime lastRefresh = DateTime.now();
    yield data;

    final Stream<SensorEvent> stream = await SensorManager().sensorUpdates(
      sensorId: Sensors.ACCELEROMETER,
      interval: Sensors.SENSOR_DELAY_FASTEST,
    );
    await for (SensorEvent sensorEvent in stream) {
      _timestamp = DateTime.now();
      _clearData(_timestamp);

      for (int i = 0; i < nrChannels; i++) {
        data[i].add(
          SensorValue(
            _timestamp,
            sensorEvent.data[channels[i]],
          ),
        );
      }

      if (_timestamp.millisecondsSinceEpoch -
              lastRefresh.millisecondsSinceEpoch >=
          interval) {
        lastRefresh = _timestamp;
        yield data.toList();
      }
    }
  }

  Future<void> _clearData(DateTime timestamp) async {
    while (data.first.isNotEmpty &&
        timestamp.millisecondsSinceEpoch -
                data.first.first.timestamp.millisecondsSinceEpoch >
            bufferSizeSeconds * 1000) {
      for (int i = 0; i < nrChannels; i++) {
        data[i].removeAt(0);
      }
    }
  }

  Future<void> record({String path}) async {
    await super.record();
    Stream<SensorEvent> stream = await SensorManager().sensorUpdates(
      sensorId: Sensors.ACCELEROMETER,
      interval: Sensors.SENSOR_DELAY_FASTEST,
    );

    subscription = stream.listen(
      (SensorEvent sensorEvent) {
        if (recording) {
          final DateTime timestamp = DateTime.now();
          recorder.writeRow(
              values: channels.map((int channel) => sensorEvent.data[channel]),
              timestamp: timestamp);
        }
      },
    );
  }

  File stop() {
    return super.stop();
  }
}
