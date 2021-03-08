part of 'report_entry_card.dart';

class _ImageCard extends StatefulWidget {
  const _ImageCard(this.entry, {Key key}) : super(key: key);

  final ImageEntry entry;

  @override
  __ImageCardState createState() => __ImageCardState();
}

class __ImageCardState extends State<_ImageCard> {
  File image;
  @override
  void initState() {
    super.initState();
    widget.entry.getImage().then((File image) {
      this.image = image;
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: image != null
          ? Image.file(image)
          : SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(),
            ),
    );
  }
}
