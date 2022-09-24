import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart' as pie;

class LineChartWidget extends StatelessWidget {
  // TODO so far only for timestamp only charts. Add support for timeseries with values
  List<int> timeStamps;
  LineChartWidget(this.timeStamps);

  final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  @override
  Widget build(BuildContext context) => timeStamps != []
      ? LineChart(LineChartData(
          minX: 0,
          maxX: 60,
          minY: -20,
          maxY: 20,
          lineBarsData: [
            LineChartBarData(
                spots: List.generate(
                    timeStamps.length,
                    (index) =>
                        FlSpot(timeStamps[index].toDouble(), index.toDouble())),
                isCurved: true)
          ],
        ))
      : Text("No data for selected inputs");
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
