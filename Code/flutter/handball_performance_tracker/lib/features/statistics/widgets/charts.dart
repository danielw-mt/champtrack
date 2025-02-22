import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart' as pie;
import 'dart:math';
import 'dart:core';
import 'package:handball_performance_tracker/core/core.dart';
import 'package:handball_performance_tracker/core/constants/strings_general.dart';

class LineChartWidget extends StatelessWidget {
  final List<int> timeStamps;
  final List<double> values;
  final int startTime;
  final int stopTime;

  /// generate a line chart from @param timeStamps and @param values
  LineChartWidget(
      {required this.startTime,
      required this.timeStamps,
      required this.values,
      required this.stopTime});

  final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  List<double> generateMinMaxValues() {
    // by default the chart should go from 0 to 60
    int end_minutes = 60;
    // if the stop watch time in minutes is larger than 60 then extend the chart to that value
    // for example if the game lasted 70 minutes extend the chart to that value
    int stop_time_in_minutes =
        DateTime.fromMillisecondsSinceEpoch(stopTime).minute;
    if (stop_time_in_minutes > 60) {
      end_minutes = stop_time_in_minutes;
    }
    double minX = 0;
    double maxX = end_minutes.toDouble();
    double minY = 0;
    double maxY = 0;
    // when there are no y values provided just increase y by 1 for every x and provide that as the y values
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
        leftTitles: AxisTitles(
          // if there are no values provided (i.e. ef-score data) then only display Action Count
          // axisNameWidget: values.isEmpty
          //     ? Text(StringsGeneral.lActionCount)
          //     : Text(StringsGeneral.lValues),
          sideTitles:
              SideTitles(interval: 1, showTitles: true, reservedSize: 15),
        ),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
            axisNameWidget: Text(StringsGeneral.lMinutesSinceStart),
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                return Text(value.toString());
              },
              // set marker every 5 minutes
              interval: 10,
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
                  spots: List.generate(timeStamps.length,
                      // each spot is the difference in minutes from the startTime
                      (index) {
                    int difference_in_minutes =
                        DateTime.fromMillisecondsSinceEpoch(timeStamps[index])
                            .difference(
                                DateTime.fromMillisecondsSinceEpoch(startTime))
                            .inMinutes;
                    print("diff in min" + difference_in_minutes.toString());
                    if (values.isEmpty) {
                      return FlSpot(difference_in_minutes.toDouble(),
                          (index + 1).toDouble());
                    } else {
                      return FlSpot(difference_in_minutes.toDouble(),
                          values[index].toDouble());
                    }
                  }),
                  isCurved: false)
            ],
          ))
        : Text("No data for selected inputs");
  }
}

class PieChartActionsWidget extends StatelessWidget {
  final Map<String, int> actionCounts;
  PieChartActionsWidget(this.actionCounts);

  @override
  Widget build(BuildContext context) {
    if (actionCounts.isEmpty) {
      return Text("No Data for selected player and game");
    } else {
      // convert int values in map to double
      Map<String, double> actionCountsAsDouble = {};
      actionCounts.forEach((key, value) {
        actionCountsAsDouble[key] = value.toDouble();
      });
      // convert action tag keys to the correct string specified in the strings
      actionCountsAsDouble = actionCountsAsDouble.map((key, value) {
        return MapEntry(realActionTag(key), value);
      });
      return pie.PieChart(dataMap: actionCountsAsDouble, legendOptions: pie.LegendOptions(showLegendsInRow: true, legendPosition: pie.LegendPosition.bottom));
    }
  }
}

class QuotaPieChart extends StatelessWidget {
  final Map<String, double> dataMap;
  QuotaPieChart({required this.ringForm, required this.dataMap});

  final bool ringForm;

  final colorListQuotes = <Color>[
    Colors.greenAccent,
    Colors.redAccent,
  ];

  @override
  Widget build(BuildContext context) {
    if (dataMap.isEmpty) {
      return Text("No data provided");
    } else {
      // if numerator and denominator are the same just display numerator because it is 100%
      // if (dataMap.values.toList()[0] == dataMap.values.toList()[1]) {
      //   dataMap.remove(dataMap.keys.toList()[1]);
      // }
      return pie.PieChart(
        chartType: ringForm ? pie.ChartType.ring : pie.ChartType.disc,
        initialAngleInDegree: -90,
        colorList: colorListQuotes,
        legendOptions: pie.LegendOptions(
          showLegendsInRow: ringForm ? false : true,
          legendPosition: pie.LegendPosition.right,
          showLegends: ringForm ? false : true,
        ),
        chartValuesOptions: pie.ChartValuesOptions(
          decimalPlaces: 0,
          showChartValueBackground: true,
          showChartValues: true,
          showChartValuesInPercentage: false,
          showChartValuesOutside: ringForm ? true : false,
        ),
        dataMap: dataMap,
      );
    }
  }
}
