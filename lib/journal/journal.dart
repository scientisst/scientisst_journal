import 'package:flutter/material.dart';

class Journal extends StatefulWidget {
  const Journal({Key key}) : super(key: key);

  @override
  _JournalState createState() => _JournalState();
}

class _JournalState extends State<Journal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: () {},
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
