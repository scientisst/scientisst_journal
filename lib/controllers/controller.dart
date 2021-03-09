import 'dart:async';
import 'dart:io';

import 'package:scientisst_journal/controllers/time_series_recorder.dart';

abstract class Controller {
  StreamSubscription subscription;
  final List data = [];
  final int bufferSizeSeconds;
  List<int> channels;
  final List<String> labels;
  final List<String> units;
  bool recording = false;
  TimeSeriesRecorder recorder;
  final String deviceName;

  Controller({
    // TODO - change labels from [true, true, false] to [0, 1]
    List<bool> channels,
    this.bufferSizeSeconds = 5,
    this.labels,
    this.units,
    this.deviceName = "",
  }) {
    assert(channels != null);
    assert(channels.length != 0);
    assert(bufferSizeSeconds != null);
    assert(labels == null || labels.length == channels.length);
    assert(units == null || units.length == channels.length);
    this.channels = List<int>.from(
      List.generate(channels.length, (index) => channels[index] ? index : null)
          .where((index) => index != null),
    );
  }

  int get nrChannels => channels.length;

  Future<void> record() async {
    recording = true;
    recorder = TimeSeriesRecorder(
      channels: channels,
      labels: this.labels != null
          ? List<String>.from(channels.map((int index) => labels[index]))
          : null,
      units: this.units != null
          ? List<String>.from(channels.map((int index) => units[index]))
          : null,
      deviceName: deviceName,
    );
    await recorder.init();
  }

  File stop() {
    subscription?.cancel();
    if (recording) {
      recording = false;
      final File file = recorder?.closeFile();
      return file;
    } else {
      return null;
    }
  }
}
