import 'package:flutter/material.dart';

class TitleDialog extends StatelessWidget {
  const TitleDialog(
      {@required this.title,
      @required this.onPressed,
      @required this.child,
      Key key})
      : super(key: key);

  final String title;
  final Widget child;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 8, right: 8, top: 8),
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 60,
              ),
              child: child,
            ),
          ),
          Container(
            height: 40,
            width: double.infinity,
            child: FlatButton(
              color: Theme.of(context).primaryColor,
              onPressed: this.onPressed ?? () => Navigator.of(context).pop(),
              child: Text(
                "OK",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
