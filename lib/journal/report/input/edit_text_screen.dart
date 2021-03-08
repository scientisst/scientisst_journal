import 'package:flutter/material.dart';
import 'package:scientisst_journal/ui/time_ago_text.dart';
import 'package:scientisst_journal/utils/database/database.dart';

class EditTextScreen extends StatefulWidget {
  const EditTextScreen(
      {@required this.reportID,
      @required this.entryID,
      this.text,
      this.title,
      this.allowEmpty = false,
      @required this.lastModified,
      Key key})
      : super(key: key);

  final String reportID;
  final String entryID;
  final String text;
  final String title;
  final bool allowEmpty;
  final DateTime lastModified;

  @override
  _EditTextScreenState createState() => _EditTextScreenState();
}

class _EditTextScreenState extends State<EditTextScreen> {
  TextEditingController _controller;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _previousText;
  DateTime _lastModified;
  bool _canSave = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.text ?? "");
    _previousText = _controller.text;
    _lastModified = widget.lastModified;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              Icons.save,
              color: _canSave ? Colors.white : Colors.white38,
            ),
            onPressed: _save,
          ),
        ],
        title: Text(widget.title ?? ""),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    maxLines: 64,
                    controller: _controller,
                    validator: _validator,
                    decoration: InputDecoration.collapsed(
                        hintText: "Write something..."),
                    onChanged: (String text) {
                      if (text.trim() != _previousText) {
                        if (!_canSave) {
                          setState(() {
                            _canSave = true;
                          });
                        }
                      } else {
                        if (_canSave) {
                          setState(() {
                            _canSave = false;
                          });
                        }
                      }
                    },
                  ),
                ),
              ),
            ),
            Divider(),
            Container(
              height: 40,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Last edited "),
                  TimeAgoText(_lastModified),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _validator(String text) {
    final String trimmed = text.trim();
    if (!widget.allowEmpty && trimmed.isEmpty) return "This can't be empty";
    return null;
  }

  Future<void> _save() async {
    if (_formKey.currentState.validate()) {
      await ReportFunctions.updateEntryText(
        reportID: widget.reportID,
        entryID: widget.entryID,
        text: _controller.text.trim(),
      );
      setState(() {
        _lastModified = DateTime.now();
        _canSave = false;
        _previousText = _controller.text.trim();
      });
    }
  }
}
