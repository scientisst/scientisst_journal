import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scientisst_journal/journal/journal.dart';
//import 'package:scientisst_journal/test/test.dart';
import 'package:scientisst_journal/settings/settings.dart';
import 'package:scientisst_journal/values/app_colors.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;
  StreamSubscription subscription;

  final _items = <BottomNavigationBarItem>[
    /*BottomNavigationBarItem(
        icon: Icon(Icons.stacked_line_chart), label: "Test"),*/
    BottomNavigationBarItem(icon: Icon(Icons.graphic_eq), label: "Journal"),
    BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
  ];

  final _children = <Widget>[
    //Test(),
    Journal(),
    Settings(),
  ];

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("ScientISST Journal"),
      ),
      body: SafeArea(
        child: IndexedStack(index: _index, children: _children),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        items: _items,
        onTap: (int index) => setState(() => _index = index),
        selectedItemColor: AppColors.primaryColor.shade600,
      ),
    );
  }
}
