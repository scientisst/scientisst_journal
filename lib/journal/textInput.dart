import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  const TextInput(this.onPressed, {Key key}) : super(key: key);

  final Function onPressed;

  @override
  _TextInputState createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  final TextEditingController controller = TextEditingController();

  void _onPressed() {
    final String trimmedText = controller.text.trim();
    if (trimmedText.isNotEmpty) {
      widget.onPressed(trimmedText);
      controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              controller: controller,
              maxLines: 100,
              style: TextStyle(fontSize: 18),
              decoration: InputDecoration(hintText: "Add a note"),
            ),
          ),
        ),
        FlatButton(
          minWidth: double.infinity,
          height: 64,
          color: Theme.of(context).primaryColor,
          child: Icon(
            Icons.send,
            color: Colors.white,
          ),
          onPressed: _onPressed,
        ),
      ],
    );
  }
}
