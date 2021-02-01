import 'package:flutter/material.dart';
import 'package:charts_common/common.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import 'package:scientisst_journal/data/sensor_value.dart';

class Chart extends StatelessWidget {
  final List<SensorValue> data;
  final double offset;
  final bool area;

  Chart(this.data, {this.area = false, this.offset = 0});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<dynamic, DateTime>> _series = [
      charts.Series<SensorValue, DateTime>(
        id: 'Values',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.blue),
        domainFn: (SensorValue values, _) => values.timestamp,
        measureFn: (SensorValue values, _) => values.value + this.offset,
        data: data,
      ),
    ];
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
            BasicDateTimeTickFormatterSpec.fromDateFormat(DateFormat.ms()),
        //renderSpec: NoneRenderSpec(),
      ),
    );
  }
}
