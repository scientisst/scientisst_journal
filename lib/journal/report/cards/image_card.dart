part of 'report_entry_card.dart';

class _ImageCard extends StatelessWidget {
  const _ImageCard(this.entry, {Key key}) : super(key: key);

  final ImageEntry entry;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(entry.legend),
    );
  }
}
