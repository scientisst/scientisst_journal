import 'dart:async';
import 'dart:io';

import 'package:scientisst_journal/controllers/time_series_recorder.dart';

abstract class Controller {
  StreamSubscription subscription;
  final List data = [];
  final int bufferSizeSeconds;
  List<int> channels;
  List<String> labels;
  bool recording = false;
  TimeSeriesRecorder recorder;

  Controller({List<bool> channels, this.bufferSizeSeconds = 5, this.labels}) {
    assert(channels != null);
    assert(channels.length != 0);
    assert(bufferSizeSeconds != null);
    assert(labels == null || labels.length == channels.length);
    this.channels = List<int>.from(
      List.generate(channels.length, (index) => channels[index] ? index : null)
          .where((index) => index != null),
    );
  }

  Future<void> record() async {
    recording = true;
    recorder = TimeSeriesRecorder(
      nrChannels: channels.length,
      labels: this.labels != null
          ? List<String>.from(channels.map((int index) => labels[index]))
          : null,
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
