import 'package:flutter/material.dart';
      inicornButton(
        hasLabel: true,
        labelText: "Study",
        currentButton: FloatingActionButton(
          heroTag: null,
          mini: true,
          child: Icon(Icons.integration_instructions),
          onPressed: () {},
        ),
      ),
import 'package:scientisst_db/scientisst_db.dart';
import 'package:scientisst_journal/data/report.dart';
import 'package:scientisst_journal/journal/reportWidget.dart';
import 'package:scientisst_journal/ui/fancy_fab.dart';
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
    final DateTime now = DateTime.now();
    DocumentReference doc =
        await ScientISSTdb.instance.collection("history").add(
      {
        "type": "report",
        "timestamp": now,
      },
    );
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ReportWidget(
          Report(id: doc.id, timestamp: now),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: UnicornDialer(
          hasBackground: false,
          backgroundColor: Color.fromRGBO(255, 255, 255, 0.6),
          parentButtonBackground: Theme.of(context).primaryColor,
          orientation: UnicornOrientation.VERTICAL,
          parentButton: Icon(Icons.add),
          childButtons: childButtons),
      body: SafeArea(
        child: FutureBuilder(
          future: ScientISSTdb.instance.collection("history").getDocuments(),
          builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snap) {
            if (snap.hasError || snap.data == null)
              return Center(
                child: Text("Empty"),
              );
            else
              return RefreshIndicator(
                onRefresh: () {
                  setState(() {});
                  return Future.value(null);
                },
                child: ListView(
                  children: List<ListTile>.from(
                    snap.data.map(
                      (DocumentSnapshot doc) {
                        final Report report = Report.fromDocument(doc);
                        return ListTile(
                          title: Text(
                            report.title,
                          ),
                          subtitle: Text(
                            report.timestamp.toString(),
                          ),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ReportWidget(
                                Report.fromDocument(doc),
                              ),
                            ),
                          ),
                          onLongPress: () {
                            doc.reference.delete();
                            setState(() {});
                          },
                        );
                      },
                    ),
                  ),
                ),
              );
          },
        ),
      ),
    );
  }
}
