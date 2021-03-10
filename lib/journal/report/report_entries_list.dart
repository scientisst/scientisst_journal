import 'package:flutter/material.dart';
import 'package:scientisst_journal/data/report/entries/report_entry.dart';
import 'package:scientisst_journal/journal/report/cards/report_entry_card.dart';

import 'package:flutter/material.dart';

class ReportEntriesList extends StatefulWidget {
  ReportEntriesList(this.entries, this.scrollController, {Key key})
      : super(key: key);
  final List<ReportEntry> entries;
  final ScrollController scrollController;
  @override
  _ReportEntriesListState createState() => _ReportEntriesListState();
}

class _ReportEntriesListState extends State<ReportEntriesList> {
  Map<String, GlobalKey> keys = {};

  @override
  void initState() {
    super.initState();
    _updateKeys();
  }

  void _updateKeys() {
    Iterable<String> lostKeys =
        keys.keys.where((String key) => !widget.entries.contains(key));

    keys.removeWhere((String key, _) => lostKeys.contains(key));
    widget.entries.forEach(
      (ReportEntry entry) {
        if (!keys.containsKey(entry.id)) keys[entry.id] = GlobalKey();
      },
    );
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((oldWidget as ReportEntriesList).entries.length !=
        widget.entries.length) _updateKeys();
  }

  Widget build(BuildContext context) {
    Iterable<ReportEntry> entries = widget.entries.reversed;
    return ListView.builder(
      reverse: true,
      padding: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 8,
      ),
      itemCount: widget.entries.length,
      controller: widget.scrollController,
      itemBuilder: (context, index) {
        final ReportEntry entry = entries.elementAt(index);
        return ReportEntryCard(
          entry,
          key: keys[entry.id],
        );
      },
    );
  }
}
