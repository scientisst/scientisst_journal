import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scientisst_journal/charts/chart.dart';
import 'package:scientisst_journal/data/sensor_value.dart';
import 'package:flutter_sensors/flutter_sensors.dart';

const WINDOW_IN_SECONDS = 5;
const FRAME_RATE = 30;

class TestCharts extends StatefulWidget {
  const TestCharts(this.activeSensors, {Key key}) : super(key: key);

  final Map<String, bool> activeSensors;

  @override
  _TestChartsState createState() => _TestChartsState();
}

class _TestChartsState extends State<TestCharts> {
  Map<String, List<SensorValue>> _data = {};
  List<StreamSubscription> _subscriptions = [];
  DateTime _now;
  Timer _refreshTimer;

  @override
  void initState() {
    super.initState();
    _refreshTimer = Timer.periodic(Duration(milliseconds: 1000 ~/ FRAME_RATE),
        (Timer timer) {
      if (mounted) {
        setState(() {});
      } else {
        timer.cancel();
      }
    });

    _checkSensors();
    _initSensors();
  }

  void _checkSensors() {
    widget.activeSensors.forEach((String key, bool value) {
      if (value) {
        switch (key) {
          case "accelerometer":
            _data.addEntries(
              [
                MapEntry("accelerometerX", <SensorValue>[]),
                MapEntry("accelerometerY", <SensorValue>[]),
                MapEntry("accelerometerZ", <SensorValue>[]),
              ],
            );
            break;
          default:
            _data.addEntries([MapEntry(key, <SensorValue>[])]);
            break;
        }
      }
    });
  }

  void _initSensors() async {
    _now = DateTime.now();
    _data.forEach((String name, List<SensorValue> sensorValues) async {
      switch (name) {
        case "accelerometerX":
          final stream = await SensorManager().sensorUpdates(
            sensorId: Sensors.ACCELEROMETER,
            interval: Sensors.SENSOR_DELAY_GAME,
          );
          _subscriptions.add(
            stream.listen(
              (sensorEvent) {
                _now = _now.add(Duration(milliseconds: 20));
                while (_data["accelerometerX"].isNotEmpty &&
                    _now
                            .difference(_data["accelerometerX"].first.timestamp)
                            .inSeconds >
                        WINDOW_IN_SECONDS) {
                  _data["accelerometerX"].removeAt(0);
                  _data["accelerometerY"].removeAt(0);
                  _data["accelerometerZ"].removeAt(0);
                }
                _data["accelerometerX"]
                    .add(SensorValue(_now, sensorEvent.data[0]));
                _data["accelerometerY"]
                    .add(SensorValue(_now, sensorEvent.data[1]));
                _data["accelerometerZ"]
                    .add(SensorValue(_now, sensorEvent.data[2]));
              },
            ),
          );
          break;
        default:
          break;
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _subscriptions
        .forEach((StreamSubscription subscription) => subscription.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: List<Widget>.from(
            _data.entries.map(
              (MapEntry entry) => SizedBox(
                height: 200,
                child: Chart(entry.value),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
