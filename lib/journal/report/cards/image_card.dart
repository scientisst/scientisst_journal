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
    widget.entry
        .getImage()
        .then((File image) => setState(() => this.image = image));
  }

  @override
  Widget build(BuildContext context) {
    return image != null
        ? Container(
            child: Image.file(image),
          )
        : Container();
  }
}
