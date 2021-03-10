import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scientisst_journal/utils/utils.dart';

class TimeAgoText extends StatefulWidget {
  const TimeAgoText(this.timestamp, {this.style, Key key}) : super(key: key);

  final DateTime timestamp;
  final TextStyle style;

  @override
  _TimeAgoTextState createState() => _TimeAgoTextState();
}

class _TimeAgoTextState extends State<TimeAgoText> {
  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(minutes: 1), (Timer timer) {
      if (mounted) {
        try {
          setState(() {});
        } on Exception catch (e) {
          print(e);
        }
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      Utils.getTimeAgo(widget.timestamp),
      style: widget.style,
    );
  }
}
