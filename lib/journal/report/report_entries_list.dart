import 'package:flutter/material.dart';
import 'package:scientisst_journal/data/report/entries/report_entry.dart';
import 'package:scientisst_journal/journal/report/cards/report_entry_card.dart';

class ReportEntriesList extends StatelessWidget {
  const ReportEntriesList(this.entries, this.scrollController, {Key key})
      : super(key: key);
  final List<ReportEntry> entries;
  final ScrollController scrollController;

  Widget build(BuildContext context) => ListView.builder(
        reverse: true,
        padding: EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 8,
        ),
        itemCount: entries.length,
        controller: scrollController,
        itemBuilder: (context, index) => ReportEntryCard(
          entries.reversed.elementAt(index),
        ),
      );
}
