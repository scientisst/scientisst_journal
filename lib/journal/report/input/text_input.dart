import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  const TextInput(this.onPressed, {Key key}) : super(key: key);

  final Function onPressed;

  @override
  _TextInputState createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  final TextEditingController controller = TextEditingController();
  bool save = false;

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
              onChanged: (String text) {
                final String trimmed = text.trim();
                if (trimmed.isNotEmpty) {
                  if (!save)
                    setState(() {
                      save = true;
                    });
                } else {
                  if (save)
                    setState(() {
                      save = false;
                    });
                }
              },
              decoration: InputDecoration(hintText: "Add a note"),
            ),
          ),
        ),
        FlatButton(
          minWidth: double.infinity,
          height: 64,
          color: save ? Theme.of(context).primaryColor : Colors.grey[300],
          child: Icon(
            Icons.send,
          ),
          onPressed: _onPressed,
        ),
      ],
    );
  }
}
