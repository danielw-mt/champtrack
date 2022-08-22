import 'package:flutter/material.dart';
import 'charts.dart';

class PlayerStatistics extends StatelessWidget {
  const PlayerStatistics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
            flex: 2,
            child: Column(children: [
              // Name & Quotes
              Flexible(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Flexible(
                        flex: 1,
                        child: PlayerInfoCard(),
                      ),
                      Flexible(
                        flex: 2,
                        child: Card(),
                      )
                    ],
                  )),
              // ef-score & actions
              Flexible(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Card(child: LineChartWidget()),
                      ),
                      Expanded(
                        child: LineChartWidget(),
                      )
                    ],
                  ))
            ])),
        // cards & field
        Flexible(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Card(child: LineChartWidget()),
                ),
                Expanded(
                  child: LineChartWidget(),
                )
              ],
            )),
      ],
    ));
  }
}

class PlayerInfoCard extends StatefulWidget {
  const PlayerInfoCard({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PlayerInfoCardState();
}

class _PlayerInfoCardState extends State<PlayerInfoCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text("Number"), Text("Name"), Text("Score")],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text("1"), Text("Player 1"), Text("0")],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text("2"), Text("Player 2"), Text("0")],
        ),
      ],
    ));
  }
}