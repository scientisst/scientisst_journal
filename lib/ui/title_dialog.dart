import 'package:flutter/material.dart';

class SimpleDialog extends StatelessWidget {
  const SimpleDialog(this.title, this.onPressed, this.child, {Key key})
      : super(key: key);

  final String title;
  final Widget child;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        children: [
          Text(title),
          child,
          FlatButton(
            onPressed: this.onPressed,
            child: Text("Ok"),
          ),
        ],
      ),
    );
  }
}
