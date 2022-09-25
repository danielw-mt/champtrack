import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart' as pie;
import 'dart:math';

class LineChartWidget extends StatelessWidget {
  List<int> timeStamps;
  List<int> values;

  /// generate a line chart from @param timeStamps and @param values
  LineChartWidget({required this.timeStamps, required this.values});

  final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  List<double> generateMinMaxValues() {
    double minX = timeStamps.reduce(min).toDouble();
    double maxX = timeStamps.reduce(max).toDouble();
    double minY = 0;
    double maxY = 0;
    // when there are no y values provided just increase y for every x
    // => maximum y is the number of x values
    if (values.isEmpty) {
      maxY = timeStamps.length.toDouble();
    } else {
      minY = values.reduce(min).toDouble();
      maxY = values.reduce(max).toDouble();
    }
    return [minX, maxX, minY, maxY];
  }

  FlTitlesData buildTitleData() {
    return FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
            sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (double value, TitleMeta meta) {
            // get the difference in minutes between the first and the current timestamp
            

            final DateTime date =
                DateTime.fromMillisecondsSinceEpoch(value.toInt());
            final parts = date.toIso8601String().split("T");
            return Text(parts.first);
          },
          //interval: (widget.spots[widget.spots.length - 1].x - widget.spots[0].x),
        )));
  }

  @override
  Widget build(BuildContext context) {
    List<double> minMaxValues = generateMinMaxValues();
    return timeStamps != []
        ? LineChart(LineChartData(
            minX: minMaxValues[0],
            maxX: minMaxValues[1],
            minY: minMaxValues[2],
            maxY: minMaxValues[3],
            titlesData: buildTitleData(),
            lineBarsData: [
              LineChartBarData(
                  spots: List.generate(
                      timeStamps.length,
                      (index) => FlSpot(timeStamps[index].toDouble(),
                          (index + 1).toDouble())),
                  isCurved: true)
            ],
          ))
        : Text("No data for selected inputs");
  }
}

Map<String, double> dataMap = {
  "Test 1": 5,
  "Test 2": 3,
  "Test 3": 2,
  "Test 4": 2,
};

Map<String, double> dataMap2 = {"Tor": 5, "Assist": 3};

class PieChartActionsWidget extends StatelessWidget {
  Map<String, int> actionCounts = {};
  PieChartActionsWidget(this.actionCounts);

  @override
  Widget build(BuildContext context) {
    if (actionCounts.isEmpty) {
      return Text("No Data for selected player and game");
    } else {
      return pie.PieChart(dataMap: actionCounts.cast());
    }
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

class OwnPieChart extends StatelessWidget {
  OwnPieChart({required this.ring_form});

  final bool ring_form;

  final colorListQuotes = <Color>[
    Colors.greenAccent,
  ];

  @override
  Widget build(BuildContext context) {
    return pie.PieChart(
      chartType: ring_form ? pie.ChartType.ring : pie.ChartType.disc,
      legendOptions: pie.LegendOptions(
        showLegendsInRow: ring_form ? false : true,
        legendPosition: pie.LegendPosition.right,
        showLegends: ring_form ? false : true,
      ),
      chartValuesOptions: pie.ChartValuesOptions(
        showChartValueBackground: true,
        showChartValues: true,
        showChartValuesInPercentage: ring_form ? true : false,
        showChartValuesOutside: ring_form ? true : false,
        decimalPlaces: 1,
      ),
      dataMap: ring_form ? dataMap2 : dataMap,
    );
  }
}
