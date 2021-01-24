import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          onTap: () {
            print("Devices");
          },
          title: Text("Devices"),
          leading: Icon(Icons.bluetooth_searching_outlined),
        ),
        ListTile(
          onTap: () {
            print("Database");
          },
          title: Text("Database"),
          leading: Icon(Icons.cloud_queue),
        ),
      ],
    );
  }
}
