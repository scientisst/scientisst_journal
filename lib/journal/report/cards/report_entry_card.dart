import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scientisst_journal/charts/chart.dart';
import 'package:scientisst_journal/data/report/entries/report_entry.dart';
import 'package:scientisst_journal/data/sensors/sensor_value.dart';
import 'package:scientisst_journal/journal/report/input/edit_text_screen.dart';
import 'package:scientisst_journal/ui/time_ago_text.dart';

part 'text_card.dart';
part 'image_card.dart';
part 'timeseries_card.dart';

class ReportEntryCard extends StatelessWidget {
  const ReportEntryCard(this.entry, {Key key}) : super(key: key);

  final ReportEntry entry;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    Widget content;
    if (entry is TextEntry)
      content = _TextCard(entry);
    else if (entry is ImageEntry)
      content = _ImageCard(entry);
    else if (entry is TimeSeriesEntry) {
      final Map<String, MaterialColor> accelerometerColors = {
        "x": Colors.red,
        "y": Colors.green,
        "z": Colors.blue
      };
      content = _TimeSeriesCard(entry, colormap: accelerometerColors);
    }
    children.add(
      Padding(
        padding: EdgeInsets.only(
          left: 12,
          top: 12,
          right: 12,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TimeAgoText(entry.modified),
            _buildOptions(),
          ],
        ),
      ),
    );
    children.add(Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Divider(),
    ));
    children.add(content);
    return Card(
      elevation: 4,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }

  Widget _buildOptions() => PopupMenuButton<String>(
        icon: Icon(
          Icons.more_vert,
          color: Colors.grey[600],
        ),
        onSelected: _performAction,
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(
            value: "delete",
            child: Text('Delete entry'),
          ),
        ],
      );

  Future<void> _performAction(String action) async {
    switch (action) {
      case "delete":
        await entry.delete();
        break;
      default:
        break;
    }
  }
}
