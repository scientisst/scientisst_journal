import 'package:flutter/material.dart';
import 'package:scientisst_db/scientisst_db.dart';
import 'package:scientisst_journal/data/report.dart';

class ReportWidget extends StatefulWidget {
  const ReportWidget(this.report, {Key key}) : super(key: key);

  final Report report;

  @override
  _ReportWidgetState createState() => _ReportWidgetState();
}

class _ReportWidgetState extends State<ReportWidget> {
  TextEditingController _titleController;
  bool _editTitle = false;
  FocusNode _titleFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.report.title);
  }

  void _toggleEditTitle() {
    _titleController.text = _titleController.text.trim();
    if (_editTitle) {
      ScientISSTdb.instance
          .collection("history")
          .document(widget.report.id)
          .updateData(
        {
          "title": _titleController.text,
        },
      );
    } else {
      _titleFocus.requestFocus();
    }
    setState(() {
      _editTitle = !_editTitle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _editTitle
            ? TextField(
                controller: _titleController,
                focusNode: _titleFocus,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                cursorColor: Colors.white,
                decoration: InputDecoration.collapsed(hintText: ""),
              )
            : Text(_titleController.text),
        actions: [
          IconButton(
            icon: Icon(_editTitle ? Icons.check : Icons.edit),
            onPressed: _toggleEditTitle,
          ),
          IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}
