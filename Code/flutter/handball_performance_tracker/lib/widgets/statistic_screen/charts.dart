import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart' as pie;

class LineChartWidget extends StatelessWidget {
  final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  @override
  Widget build(BuildContext context) => LineChart(LineChartData(
        minX: 0,
        maxX: 60,
        minY: -20,
        maxY: 20,
        lineBarsData: [
          LineChartBarData(spots: [
            FlSpot(0, 0),
            FlSpot(10, 1),
            FlSpot(20, 2),
            FlSpot(30, 3),
            FlSpot(40, 4),
            FlSpot(50, 5),
            FlSpot(60, 6),
          ], isCurved: true),
        ],
      ));
}

Map<String, double> dataMap = {
  "Tor": 5,
  "Assist": 3,
  "TRF": 2,
  "Fehlwurf": 2,
};

class PieChartActionsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return pie.PieChart(dataMap: dataMap);
  }
}

class PieChartQuotesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return pie.PieChart(
        chartType: pie.ChartType.ring,
        legendOptions: pie.LegendOptions(
          showLegendsInRow: false,
          legendPosition: pie.LegendPosition.right,
          showLegends: false,
        ),
        dataMap: dataMap);
  }
}
