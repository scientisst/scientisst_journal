import 'package:scientisst_journal/data/sensor_options.dart';

abstract class Controller {
  final SensorOptions options;
  final List data;
  final int bufferSizeSeconds;
  List<int> channels;

  Controller({this.options, this.data, this.bufferSizeSeconds});

  void start() {}

  void dispose() {}
}
