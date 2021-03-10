import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scientisst_journal/charts/chart.dart';

import 'package:scientisst_journal/controllers/accelerometer_controller.dart';

class AccelerometerInput extends StatefulWidget {
  const AccelerometerInput(this.onPressed, {Key key}) : super(key: key);

  final Function onPressed;

  @override
  _AccelerometerInputState createState() => _AccelerometerInputState();
}

class _AccelerometerInputState extends State<AccelerometerInput> {
  static const List<MaterialColor> COLORS = [
    Colors.red,
    Colors.green,
    Colors.blue
  ];
  AccelerometerController _controller;
  bool _recording = false;
  List<bool> axis = [true, true, true];
  List<MaterialColor> colors = COLORS;

  @override
  void initState() {
    super.initState();
    initController();
  }

  void initController() {
    colors = [];
    for (int i = 0; i < axis.length; i++) {
      if (axis[i]) {
        colors.add(COLORS[i]);
      }
    }
    _controller = AccelerometerController(channels: axis);
  }

  void _onPressed() {
    if (!_recording) {
      setState(() {
        _recording = true;
      });
      _startAcquisition();
    } else {
      setState(() {
        _recording = false;
      });
      _stopAcquisition();
    }
  }

  Future<void> _startAcquisition() async {
    await _controller.record();
  }

  void _stopAcquisition({bool save = true}) {
    File file = _controller.stop();
    if (save) {
      widget.onPressed(
        file,
        List<String>.from(
          _controller.channels.map(
            (int channel) => _controller.labels[channel],
          ),
        ),
      );
    }
  }

  @override
  void deactivate() {
    _stopAcquisition(save: false);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) => Padding(
                    padding: EdgeInsets.all(8),
                    child: constraints.maxHeight > 64
                        ? StreamBuilder(
                            stream: _controller.listen(),
                            builder: (context, AsyncSnapshot snap) {
                              if (snap == null ||
                                  (snap.connectionState !=
                                          ConnectionState.active &&
                                      snap.connectionState !=
                                          ConnectionState.waiting))
                                return Container();
                              return Chart(_controller.data, colors: colors);
                            },
                          )
                        : Container(),
                  ),
                ),
              ),
              IgnorePointer(
                ignoring: _recording,
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      axis.length,
                      (int index) => RawMaterialButton(
                        fillColor: axis[index]
                            ? (_recording
                                ? COLORS[index].withOpacity(0.5)
                                : COLORS[index])
                            : Colors.grey,
                        shape: CircleBorder(),
                        child: Text(
                          _controller.labels[index],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          axis[index] = !axis[index];
                          initController();
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        FlatButton(
          minWidth: double.infinity,
          height: 64,
          color: _recording ? Colors.grey[300] : Theme.of(context).primaryColor,
          child: Icon(
            _recording ? Icons.stop : Icons.radio_button_on,
          ),
          onPressed: _onPressed,
        ),
      ],
    );
  }
}
