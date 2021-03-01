part of 'report_entry_card.dart';

class _ImageCard extends StatelessWidget {
  const _ImageCard(this.entry, {Key key}) : super(key: key);

  final ImageEntry entry;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: entry.getImage(),
      builder: (BuildContext context, AsyncSnapshot<File> snap) {
        return snap.hasData
            ? Container(
                child: Image.file(snap.data),
              )
            : Container();
      },
    );
  }
}
