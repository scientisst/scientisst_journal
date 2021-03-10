import 'package:flutter/material.dart';
import 'package:charts_common/common.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import 'package:scientisst_journal/data/sensors/sensor_value.dart';

const List<MaterialColor> DEFAULT_COLORS = [
  Colors.blue,
  Colors.orange,
  Colors.red,
  Colors.green,
  Colors.purple,
  Colors.brown,
  Colors.yellow,
];

class Chart extends StatelessWidget {
  final List data;
  final double offset;
  final bool area;
  final List<MaterialColor> colors;

  Chart(this.data, {this.area = false, this.offset = 0, this.colors});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<SensorValue, DateTime>> _series;
    if (data is List<List<SensorValue>>) {
      _series = List<charts.Series<SensorValue, DateTime>>.from(List.generate(
        data.length,
        (int index) => charts.Series<SensorValue, DateTime>(
          id: 'Values',
          colorFn: (_, __) => charts.ColorUtil.fromDartColor(
              (colors ?? DEFAULT_COLORS).elementAt(index)),
          domainFn: (SensorValue values, _) => values.timestamp,
          measureFn: (SensorValue values, _) => values.value + this.offset,
          data: List<SensorValue>.from(data[index]),
        ),
      ));
    } else {
      _series = [
        charts.Series<SensorValue, DateTime>(
          id: 'Values',
          colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.blue),
          domainFn: (SensorValue values, _) => values.timestamp,
          measureFn: (SensorValue values, _) => values.value + this.offset,
          data: List<SensorValue>.from(data),
        ),
      ];
    }
    return charts.TimeSeriesChart(
      _series,
      defaultRenderer:
          new LineRendererConfig(includeArea: area, strokeWidthPx: 3),
      animate: false,
      behaviors: [
        new charts.LinePointHighlighter(
            showHorizontalFollowLine:
                charts.LinePointHighlighterFollowLineType.none,
            showVerticalFollowLine:
                charts.LinePointHighlighterFollowLineType.none),
        new charts.SelectNearest(eventTrigger: null),
      ],
      primaryMeasureAxis: charts.NumericAxisSpec(
        tickProviderSpec:
            new charts.BasicNumericTickProviderSpec(zeroBound: false),
        //renderSpec: NoneRenderSpec(),
        showAxisLine: true,
      ),
      domainAxis: DateTimeAxisSpec(
        //showAxisLine: false,
        tickProviderSpec: DateTimeEndPointsTickProviderSpec(),
        tickFormatterSpec:
            BasicDateTimeTickFormatterSpec.fromDateFormat(DateFormat.Hms()),
        //renderSpec: NoneRenderSpec(),
      ),
    );
  }
}
