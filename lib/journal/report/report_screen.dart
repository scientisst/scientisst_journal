import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:scientisst_db/scientisst_db.dart';
import 'package:scientisst_journal/data/report/report.dart';
import 'package:scientisst_journal/data/report/report_entry.dart';
import 'package:scientisst_journal/journal/report/cards/report_entry_card.dart';
import 'package:scientisst_journal/journal/report/input/text_input.dart';
import 'package:scientisst_journal/journal/report/input/camera_input.dart';
import 'package:scientisst_journal/utils/database/database.dart';

const ANIMATION_DURATION = Duration(milliseconds: 250);
const BAR_MIN_HEIGHT = 88.0;

class ReportScreen extends StatefulWidget {
  const ReportScreen(this.report, {Key key}) : super(key: key);

  final Report report;

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

abstract class ReportScreenState extends State<ReportScreen> {
  TextEditingController _titleController;
  bool _editTitle = false;
  bool _panning = false;
  FocusNode _titleFocus = FocusNode();
  double _halfOffset = 0;
  Duration _animationDuration = Duration.zero;
  List<Tab> _tabs = [
    Tab(
      icon: Icon(Icons.message),
    ),
    Tab(
      icon: Icon(Icons.camera_alt),
    ),
  ];
  List<Widget> _tabViews;
}

class _ReportScreenState extends ReportScreenState {
  @override
  void initState() {
    super.initState();
    _tabViews = [
      TextInput(_addNote),
      CameraInput(_addImage),
    ];
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

  Future<void> _addNote(String text) async {
    if (text.isNotEmpty) {
      await ReportFunctions.addReportNote(widget.report.id, text);
    }
  }

  Future<void> _addImage(XFile image) async {
    if (image != null) {
      await ReportFunctions.addReportImage(
          widget.report.id, await image.readAsBytes());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double halfHeight = constraints.maxHeight / 2;
            if (!_panning) {
              if (_halfOffset < -halfHeight / 2) {
                _halfOffset = -halfHeight;
              } else if (_halfOffset >= halfHeight / 2) {
                FocusScope.of(context).unfocus();
                _halfOffset = halfHeight;
              } else {
                _halfOffset = 0;
              }
            }
            return GestureDetector(
              onPanStart: (_) {
                _panning = true;
                _animationDuration = Duration.zero;
              },
              onPanUpdate: (DragUpdateDetails details) {
                final double dy = details.delta.dy;
                if (_halfOffset + dy >= -halfHeight &&
                    _halfOffset + dy < halfHeight) {
                  setState(() {
                    _halfOffset += details.delta.dy;
                  });
                }
              },
              onPanEnd: (_) {
                _panning = false;
                _animationDuration = ANIMATION_DURATION;
              },
              child: Stack(
                children: [
                  AnimatedContainer(
                    constraints: BoxConstraints(
                      minHeight: halfHeight,
                      maxHeight: halfHeight * 2 - BAR_MIN_HEIGHT,
                    ),
                    height: halfHeight + _halfOffset,
                    duration: _animationDuration,
                    child: StreamBuilder(
                      stream:
                          ReportFunctions.getReportEntries(widget.report.id),
                      builder:
                          (context, AsyncSnapshot<List<ReportEntry>> snap) {
                        return snap.hasError || snap.data == null
                            ? Container(child: Text("Empty"))
                            : ListView.builder(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 8,
                                ),
                                itemCount: snap.data.length,
                                itemBuilder: (context, index) =>
                                    ReportEntryCard(snap.data[index]),
                              );
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: AnimatedContainer(
                      constraints: const BoxConstraints(
                        minHeight: BAR_MIN_HEIGHT,
                      ),
                      decoration: const BoxDecoration(
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.black38,
                              blurRadius: 10.0,
                              offset: Offset(0.0, 0.5))
                        ],
                        color: Colors.white,
                      ),
                      height: halfHeight - _halfOffset,
                      duration: _animationDuration,
                      child: DefaultTabController(
                        length: _tabs.length,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(360),
                                child: Container(
                                  width: 80,
                                  height: 8,
                                  color: Colors.grey[300],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 64,
                              child: ButtonsTabBar(
                                tabs: _tabs,
                                contentPadding: EdgeInsets.zero,
                                backgroundColor: Theme.of(context).primaryColor,
                                unselectedBackgroundColor: Colors.grey[400],
                                unselectedLabelStyle:
                                    TextStyle(color: Colors.white),
                                duration: 150,
                              ),
                            ),
                            halfHeight - _halfOffset - BAR_MIN_HEIGHT > 64
                                ? Expanded(
                                    child: TabBarView(children: _tabViews),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  AppBar get _appBar => AppBar(
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
      );
}
