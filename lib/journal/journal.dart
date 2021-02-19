import 'package:flutter/material.dart';
import 'package:scientisst_db/scientisst_db.dart';
import 'package:scientisst_journal/data/historyEntry.dart';
import 'package:scientisst_journal/data/report.dart';
import 'package:scientisst_journal/journal/reportWidget.dart';
import 'package:scientisst_journal/utils/database.dart';
import 'package:unicorndial/unicorndial.dart';

class Journal extends StatefulWidget {
  const Journal({Key key}) : super(key: key);

  @override
  _JournalState createState() => _JournalState();
}

class _JournalState extends State<Journal> {
  List<UnicornButton> childButtons;

  @override
  void initState() {
    super.initState();
    childButtons = [
      UnicornButton(
        hasLabel: true,
        labelText: "Report",
        currentButton: FloatingActionButton(
          heroTag: null,
          mini: true,
          child: Icon(Icons.article),
          onPressed: _newReport,
        ),
      ),
      UnicornButton(
        hasLabel: true,
        labelText: "Study",
        currentButton: FloatingActionButton(
          heroTag: null,
          mini: true,
          child: Icon(Icons.integration_instructions),
          onPressed: () {},
        ),
      ),
    ];
  }

  Future<void> _newReport() async {
    Report report = await Database.newReport();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ReportWidget(report),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScientISSTdb.instance.collection("history").getDocuments().then(
          (value) => value.forEach(
            (doc) => print("data: ${doc.data}"),
          ),
        );
    return Scaffold(
      floatingActionButton: UnicornDialer(
          hasBackground: false,
          backgroundColor: Color.fromRGBO(255, 255, 255, 0.6),
          parentButtonBackground: Theme.of(context).primaryColor,
          orientation: UnicornOrientation.VERTICAL,
          parentButton: Icon(Icons.add),
          childButtons: childButtons),
      body: SafeArea(
        child: StreamBuilder(
          stream: Database.getHistory(),
          builder: (context, AsyncSnapshot<List<HistoryEntry>> snap) {
            if (snap.hasError || snap.data == null || snap.data.isEmpty)
              return Center(
                child: Text('Empty'),
              );
            else
              return ListView.builder(
                itemCount: snap.data.length,
                itemBuilder: (context, index) {
                  final HistoryEntry entry = snap.data[index];
                  return ListTile(
                    title: Text(
                      entry.title,
                    ),
                    subtitle: Text(
                      entry.timestamp.toString(),
                    ),
                    onTap: () async {
                      Widget page;
                      if (entry.isReport) {
                        page = ReportWidget(await Database.getReport(entry.id));
                      } else if (entry.isStudy) {
                        //page = ReportWidget(await Database.getReport(entry.id));
                        page = Container();
                      }
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => page,
                        ),
                      );
                    },
                    onLongPress: () async {
                      await Database.deleteHistoryEntry(entry.id);
                      setState(() {});
                    },
                  );
                },
              );
          },
        ),
      ),
    );
  }
}
