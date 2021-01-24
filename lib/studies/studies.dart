import 'package:flutter/material.dart';

class Studies extends StatefulWidget {
  const Studies({Key key}) : super(key: key);

  @override
  _StudiesState createState() => _StudiesState();
}

class _StudiesState extends State<Studies> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
