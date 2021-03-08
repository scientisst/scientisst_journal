part of 'report_entry_card.dart';

class _TimeSeriesCard extends StatefulWidget {
  const _TimeSeriesCard(this.entry, {this.colormap, Key key}) : super(key: key);

  final TimeSeriesEntry entry;
  final Map<String, MaterialColor> colormap;
  @override
  __TimeSeriesCardState createState() => __TimeSeriesCardState();
}

class __TimeSeriesCardState extends State<_TimeSeriesCard> {
  List<List<SensorValue>> data;

  @override
  void initState() {
    super.initState();
    widget.entry.getData().then(
      (List<List<SensorValue>> data) {
        this.data = data;
        if (mounted) setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Color> colors;
    if (widget.colormap != null) {
      colors = List<MaterialColor>.from(
        widget.entry.labels.map(
          (String label) => widget.colormap[label],
        ),
      );
    }
    return data != null
        ? Container(
            height: 256,
            padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: Chart(data, colors: colors),
          )
        : Container();
  }
}
