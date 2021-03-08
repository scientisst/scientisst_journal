import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scientisst_journal/data/sensors/sensor_options.dart';
import 'package:scientisst_journal/test/test_charts.dart';
import 'package:scientisst_journal/ui/sensor_button.dart';
import 'package:scientisst_journal/ui/sensor_options_dialog.dart';

class Test extends StatefulWidget {
  const Test({Key key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  final Map<String, SensorOptions> _sensorsOptions = {
    "accelerometer": SensorOptions(
      name: "accelerometer",
      channels: [false, false, false],
      channelsLabels: ["X", "Y", "Z"],
    ),
    "light": SensorOptions(
      name: "light",
      channels: [false],
    ),
    //"microphone": SensorOptions(name: "microphone", channels: [false]),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TestCharts(_sensorsOptions),
            ),
          );
        },
        child: Icon(
          Icons.play_arrow,
        ),
      ),
      body: GridView.count(
        padding: EdgeInsets.all(8),
        crossAxisCount: 3,
        children: [
          _buildButton(
            options: _sensorsOptions["accelerometer"],
            icon: SvgPicture.asset(
              "assets/icons/sensors/accelerometer.svg",
              semanticsLabel: 'Accelerometer',
              color: Colors.white,
              width: 28,
              height: 28,
            ),
            disabledIcon: Icon(Icons.extension_outlined),
            color: Colors.blue,
            onLongPress: _showAccelerometerOptions,
          ),
          _buildButton(
            options: _sensorsOptions["light"],
            icon: Icon(Icons.lightbulb),
            disabledIcon: Icon(Icons.lightbulb_outline_rounded),
            color: Colors.yellow[800],
          ),
          /*_buildButton(
            options: _sensorsOptions["microphone"],
            icon: Icon(Icons.mic_rounded),
            disabledIcon: Icon(Icons.mic_outlined),
            color: Colors.green,
          ),*/
        ],
      ),
    );
  }

  Widget _buildButton(
      {@required SensorOptions options,
      @required Widget icon,
      Widget disabledIcon,
      Color color = Colors.blueAccent,
      Function onLongPress}) {
    final bool active = options.active;
    return SensorButton(
      onPressed: () => setState(() => options.toggle()),
      icon: active ? icon : disabledIcon,
      label: options.name,
      active: active,
      color: color,
      onLongPress: onLongPress,
    );
  }

  void _showAccelerometerOptions() {
    final SensorOptions options = _sensorsOptions["accelerometer"];
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, _setState) => TitleDialog(
          title: "Select axis:",
          child: Row(
            children: List.generate(
              options.channels.length,
              (int index) {
                final bool active = options.channels[index];
                return Expanded(
                  child: SensorButton(
                      onPressed: () {
                        setState(() => options.toggleChannel(index));
                        _setState(() {});
                      },
                      icon: Text(
                        options.channelsLabels[index],
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: active ? Colors.white : Colors.grey),
                      ),
                      active: options.channels[index],
                      label: null),
                );
              },
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}
