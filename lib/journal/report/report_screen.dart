import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:share/share.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:scientisst_journal/data/report/report.dart';
import 'package:scientisst_journal/data/report/report_entry.dart';
import 'package:scientisst_journal/journal/report/cards/report_entry_card.dart';
import 'package:scientisst_journal/journal/report/input/text_input.dart';
import 'package:scientisst_journal/journal/report/input/camera_input.dart';
import 'package:scientisst_journal/journal/report/input/image_input.dart';
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
  final List<Tab> _tabs = [
    Tab(
      icon: Icon(Icons.message),
    ),
    Tab(
      icon: Icon(Icons.camera_alt),
    ),
    Tab(
      icon: Icon(Icons.photo),
    ),
  ];
  List<Widget> _tabViews;
  List<ReportEntry> _entries = [];
  StreamSubscription<List<ReportEntry>> _stream;
  ScrollController _scrollController = ScrollController();
  TabController _tabController;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
}

class _ReportScreenState extends ReportScreenState
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _tabs.length,
      vsync: this,
    );
    _tabViews = [
      TextInput(_addNote),
      CameraInput(_addImage),
      ImageInput(_addImage),
    ];
    _titleController = TextEditingController(text: widget.report.title);
    _stream = ReportFunctions.getReportEntries(widget.report.id)
        .listen((List<ReportEntry> entries) {
      setState(() => _entries = entries);
      _scrollToBottom();
    });

    _tabController.addListener(_raiseBottom);
  }

  @override
  void dispose() {
    _stream?.cancel();
    super.dispose();
  }

  void _raiseBottom() {
    FocusScope.of(context).unfocus();
    if (_halfOffset > 0) {
      setState(() {
        _halfOffset = 0;
      });
    }
  }

  void _toggleEditTitle() {
    _titleController.text = _titleController.text.trim();
    if (_editTitle) {
      ReportFunctions.changeTitle(widget.report.id, _titleController.text);
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

  Future<void> _addImage(Uint8List imageBytes) async {
    if (imageBytes != null && imageBytes.isNotEmpty) {
      await ReportFunctions.addReportImage(widget.report.id, imageBytes);
    }
  }

  void _scrollToBottom() => _scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                setState(() {
                  _panning = false;
                  _animationDuration = ANIMATION_DURATION;
                });
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
                    child: ListView.builder(
                      reverse: true,
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      itemCount: _entries.length,
                      controller: _scrollController,
                      itemBuilder: (context, index) => ReportEntryCard(
                          _entries[_entries.length - 1 - index]),
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
                            child: GestureDetector(
                              onTap: _raiseBottom,
                              child: ButtonsTabBar(
                                controller: _tabController,
                                tabs: _tabs,
                                contentPadding: EdgeInsets.zero,
                                backgroundColor: Theme.of(context).primaryColor,
                                unselectedBackgroundColor: Colors.grey[400],
                                unselectedLabelStyle:
                                    TextStyle(color: Colors.white),
                                duration: 150,
                              ),
                            ),
                          ),
                          halfHeight - _halfOffset - BAR_MIN_HEIGHT > 64
                              ? Expanded(
                                  child: TabBarView(
                                      controller: _tabController,
                                      children: _tabViews),
                                )
                              : Container(),
                        ],
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
          _optionsMenu,
        ],
      );

  PopupMenuButton get _optionsMenu => PopupMenuButton<String>(
        icon: Icon(
          Icons.more_vert,
        ),
        onSelected: _performAction,
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            value: "save as",
            child: _optionsEntry(
              "Save As",
              Icon(Icons.save),
            ),
          ),
          PopupMenuItem<String>(
            value: "export",
            child: _optionsEntry(
              "Share",
              Icon(Icons.share),
            ),
          ),
        ],
      );

  Widget _optionsEntry(String text, Widget icon) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconTheme(
              data: IconThemeData(
                color: Colors.grey,
              ),
              child: icon),
          SizedBox(width: 16),
          Text(text)
        ],
      );

  void _performAction(String action) {
    switch (action) {
      case "export":
        _export();
        return;
      case "save as":
        _saveAs();
        return;
      default:
        return;
    }
  }

  Future<void> _saveAs() async {
    if (await Permission.storage.request().isGranted) {
      String result = await FilePicker.platform.getDirectoryPath();
      if (result != null) {
        await ReportFunctions.exportReport(widget.report.id, path: result);
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text("Saved!"),
          ),
        );
      } else {
        // User canceled the picker
      }
    }
  }

  Future<void> _export() async {
    File file = await ReportFunctions.exportReport(widget.report.id);
    Share.shareFiles([file.path], text: _titleController.text.trim());
  }
}
