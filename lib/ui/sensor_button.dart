import 'package:flutter/material.dart';

class SensorButton extends StatelessWidget {
  const SensorButton(
      {@required this.onPressed,
      @required this.icon,
      @required this.label,
      @required this.active,
      this.color = Colors.blueAccent,
      Key key})
      : super(key: key);

  final Function onPressed;
  final Widget icon;
  final String label;
  final bool active;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4),
      child: FlatButton(
        color: this.active ? this.color : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            width: 3,
            color: this.active ? this.color : Colors.grey,
          ),
        ),
        onPressed: this.onPressed,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconTheme(
                data: IconThemeData(
                    size: 42, color: this.active ? Colors.white : Colors.grey),
                child: this.icon),
            SizedBox(height: 8),
            Text(
              this.label,
              style: TextStyle(
                color: this.active ? Colors.white : Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
