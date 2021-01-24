import 'package:flutter/material.dart';
import 'package:scientisst_journal/ui/sensor_button.dart';

class Test extends StatefulWidget {
  const Test({Key key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  final Map<String, bool> _sensorsState = {"Light": false, "Microphone": false};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(
          Icons.play_arrow,
        ),
      ),
      body: GridView.count(
        padding: EdgeInsets.all(8),
        crossAxisCount: 3,
        children: [
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
          Color color = Colors.blueAccent}) =>
      SensorButton(
        onPressed: () =>
            setState(() => _sensorsState[label] = !_sensorsState[label]),
        icon: _sensorsState[label] ? icon : disabledIcon,
        label: label,
        active: _sensorsState[label],
        color: color,
      );
}
