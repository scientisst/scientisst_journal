import 'package:flutter/material.dart';
import 'package:scientisst_journal/utils/utils.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

const String SPACE = "%20";
const String FEEDBACK_URL = "https://forms.gle/gyNFULdcxQhkJLPt9";
const String HELP_URL =
    "mailto:afonsocraposo@gmail.com?Subject=ScientISST${SPACE}Journal$SPACE-${SPACE}Something${SPACE}is${SPACE}not${SPACE}working";
const String SUC_URL = "https://forms.gle/NrjpuzNJ9Juk6hGL8";

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        /*ListTile(
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
        ),*/
        ListTile(
          onTap: () => Utils.launchURL(FEEDBACK_URL),
          title: Text("Feedback"),
          subtitle: Text("Suggestions, bugs, etc"),
          leading: Icon(Icons.chat),
        ),
        ListTile(
          onTap: () => Utils.launchURL(HELP_URL),
          title: Text("Help!"),
          subtitle: Text("Something is not working"),
          leading: Icon(Icons.error),
        ),
        ListTile(
          onTap: () => Utils.launchURL(SUC_URL),
          title: Text("System Usability Scale"),
          subtitle: Text("Evaluate the application"),
          leading: Icon(Icons.grading),
        ),
      ],
    );
  }
}
