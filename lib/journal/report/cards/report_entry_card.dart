import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scientisst_journal/data/report/report_entry.dart';

part 'text_card.dart';
part 'image_card.dart';

class ReportEntryCard extends StatelessWidget {
  const ReportEntryCard(this.entry, {Key key}) : super(key: key);

  final ReportEntry entry;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    Widget content;
    if (entry.isText)
      content = _TextCard(entry as TextEntry);
    else if (entry.isImage) content = _ImageCard(entry as ImageEntry);

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
            _buildTimestamp(entry.timestamp),
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
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }

  Widget _buildTimestamp(DateTime timestamp) {
    String time;
    final Duration difference = DateTime.now().difference(timestamp);
    if (difference.inMinutes >= 60) {
      time = DateFormat.Hms().format(timestamp);
    } else {
      time = "${difference.inMinutes} min ago";
    }
    return Container(
      child: Text(
        time,
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
