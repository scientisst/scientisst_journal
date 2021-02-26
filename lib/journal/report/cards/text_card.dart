part of 'report_entry_card.dart';

class _TextCard extends StatelessWidget {
  const _TextCard(this.entry, {Key key}) : super(key: key);

  final TextEntry entry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 16,
        left: 12,
        right: 12,
        top: 12,
      ),
      child: Text(
        entry.text,
        style: TextStyle(
          fontSize: 17,
        ),
      ),
    );
  }
}
