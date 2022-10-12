import 'package:flutter/material.dart';
import 'statistic_card_elements.dart';
import 'charts.dart';

class ComparisonStatistics extends StatelessWidget {
  const ComparisonStatistics({Key? key, required this.changePage})
      : super(key: key);
  final void Function(int) changePage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        // Payer List in this Team
        Expanded(flex: 1, child: PlayerList()),
        // Quotes
        Flexible(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 1,
                child: Card(
                    child: LineChartWidget(
                  startTime: 0,
                  stopTime: 0,
                  timeStamps: [],
                  values: [],
                )),
              ),
              Flexible(
                flex: 1,
                child: Card(
                    child: PerformanceCard(
                  allActionTimeStamps: [],
                  efScoreSeries: [],
                  startTime: 0,
                  stopTime: 0,
                  actionSeries: {},
                )),
              ),
            ],
          ),
        ),
        Flexible(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: PenaltyInfoCard(),
                ),
                Expanded(
                  flex: 4,
                  child: Card(
                    child: Center(child: Text("Game field coming soon")),
                  ),
                )
              ],
            )),
      ],
    );
  }
}
