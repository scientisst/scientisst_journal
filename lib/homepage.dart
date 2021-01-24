import 'package:flutter/material.dart';
import 'package:scientisst_journal/studies/studies.dart';
import 'package:scientisst_journal/test/test.dart';
import 'package:scientisst_journal/settings/settings.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  final _items = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
        icon: Icon(Icons.stacked_line_chart), label: "Test"),
    BottomNavigationBarItem(icon: Icon(Icons.graphic_eq), label: "Studies"),
    BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
  ];

  final _children = <Widget>[Test(), Studies(), Settings()];

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
      ),
    );
  }
}
