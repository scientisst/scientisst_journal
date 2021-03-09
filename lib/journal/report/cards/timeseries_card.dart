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
    return Container(
      height: 256,
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 12, right: 12, bottom: 16),
      child: data != null
          ? Chart(data, colors: colors)
          : SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(),
            ),
    );
  }
}
