import 'package:flutter/material.dart';
import 'package:scientisst_journal/test/test_charts.dart';
import 'package:scientisst_journal/ui/sensor_button.dart';

class Test extends StatefulWidget {
  const Test({Key key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  final Map<String, bool> _sensorsState = {
    "accelerometer": false,
    "light": false,
    "microphone": false
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TestCharts(_sensorsState),
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
            label: "Accelerometer",
            icon: Icon(Icons.extension_rounded),
            disabledIcon: Icon(Icons.extension_outlined),
            color: Colors.blue,
          ),
          _buildButton(
            label: "Light",
            icon: Icon(Icons.lightbulb),
            disabledIcon: Icon(Icons.lightbulb_outline_rounded),
            color: Colors.yellow[800],
          ),
          _buildButton(
            label: "Microphone",
            icon: Icon(Icons.mic_rounded),
            disabledIcon: Icon(Icons.mic_outlined),
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
      {@required String label,
      @required Widget icon,
      Widget disabledIcon,
      Color color = Colors.blueAccent}) {
    final active = _sensorsState[label.toLowerCase()];
    return SensorButton(
      onPressed: () =>
          setState(() => _sensorsState[label.toLowerCase()] = !active),
      icon: active ? icon : disabledIcon,
      label: label,
      active: active,
      color: color,
    );
  }
}
