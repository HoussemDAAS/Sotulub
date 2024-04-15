import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}

class LineChartSample extends StatelessWidget {
  final List<charts.Series<LinearSales, int>> seriesList = [
    charts.Series<LinearSales, int>(
      id: 'Sales',
      colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (LinearSales sales, _) => sales.year,
      measureFn: (LinearSales sales, _) => sales.sales,
      data: [
        LinearSales(0, 5),
        LinearSales(1, 25),
        LinearSales(2, 100),
        LinearSales(3, 75),
        LinearSales(4, 75),
        LinearSales(5, 75),
        LinearSales(6, 75),
      ],
    ),
  ];

  final charts.NumericAxisSpec axis = charts.NumericAxisSpec(
    renderSpec: charts.GridlineRendererSpec(
      lineStyle: charts.LineStyleSpec(
        color: charts.MaterialPalette.blue.shadeDefault,
      ),
      labelStyle: charts.TextStyleSpec(
        fontSize: 10,
        color: charts.MaterialPalette.blue.shadeDefault,
      ),
    ),
  );

  LineChartSample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 300,
          child: charts.LineChart(
            seriesList,
            animate: true,
            primaryMeasureAxis: axis,
            domainAxis: axis,
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Sales Data',
          ),
        ),
      ],
    );
  }
}
