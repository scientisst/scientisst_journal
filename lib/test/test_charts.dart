import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scientisst_journal/charts/chart.dart';
import 'package:scientisst_journal/controllers/accelerometer_controller.dart';
import 'package:scientisst_journal/controllers/controller.dart';
import 'package:scientisst_journal/controllers/light_controller.dart';
import 'package:scientisst_journal/data/sensor_options.dart';

const WINDOW_IN_SECONDS = 5;
const FRAME_RATE = 30;

class TestCharts extends StatefulWidget {
  const TestCharts(this.sensorOptions, {Key key}) : super(key: key);

  final Map<String, SensorOptions> sensorOptions;

  @override
  _TestChartsState createState() => _TestChartsState();
}

class _TestChartsState extends State<TestCharts> {
  List<Controller> _controllers = [];
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

    _initSensors();
  }

  void _initSensors() async {
    widget.sensorOptions.forEach(
      (String name, SensorOptions options) async {
        if (options.active) {
          switch (name) {
            case "accelerometer":
              final controller = AccelerometerController(
                options: options,
                bufferSizeSeconds: 5,
              );
              controller.start();
              _controllers.add(controller);
              break;
            case "light":
              final controller = LightController(
                options: options,
                bufferSizeSeconds: 5,
              );
              controller.start();
              _controllers.add(controller);
              break;
            default:
              break;
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _controllers.forEach(
      (Controller controller) => controller.dispose(),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: List<Widget>.from(
            _controllers.map(
              (Controller controller) => Column(
                mainAxisSize: MainAxisSize.min,
                children: List<Widget>.generate(
                  controller.data.length,
                  (index) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      controller.options.channelsLabels != null
                          ? Text(controller.options
                              .channelsLabels[controller.channels[index]])
                          : Container(),
                      SizedBox(
                        height: 200,
                        child: Chart(controller.data[index]),
                      ),
                    ],
                  ),
                )..insert(
                    0,
                    Text(
                      controller.options.name,
                    ),
                  ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
