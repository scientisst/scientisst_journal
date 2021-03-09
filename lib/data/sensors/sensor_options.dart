import 'package:flutter/material.dart';

class SensorOptions {
  final List<String> units;
  final List<String> label;
  List<String> column;
  final String deviceName;
  final List<int> channels;

  SensorOptions({
    @required this.units,
    @required this.label,
    @required this.channels,
    @required this.deviceName,
  }) : assert(channels != null && channels.length > 0);

  SensorOptions.fromMap(Map<String, dynamic> map)
      : units = List<String>.from(map["units"]),
        channels = List<int>.from(map["channels"]),
        label = List<String>.from(map["label"]),
        deviceName = map["device_name"];

  int get nrChannels => channels.length;
}
