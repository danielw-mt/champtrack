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
                Expanded(
                  flex: 1,
                  child: CardsInfoCard(),
                ),
                Flexible(
                  flex: 4,
                  child: LineChartWidget(),
                )
              ],
            )),
      ],
    ));
  }
}


class CardsInfoCard extends StatelessWidget {
  const CardsInfoCard({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 1,
            child: Column(
              children: [
                Flexible(
                  flex: 1,
                  child: Text('2min'),
                ),
                Flexible(
                  flex: 1,
                  // TODO read from database
                  child: Text('0'),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Column(
              children: [
                Flexible(
                  flex: 1,
                  child: Text('Yellow Cards'),
                ),
                Flexible(
                  flex: 1,
                  // TODO read from database
                  child: Text('0'),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Column(
              children: [
                Flexible(
                  flex: 1,
                  child: Text('Red Cards'),
                ),
                Flexible(
                  flex: 1,
                  // TODO read from database
                  child: Text('0'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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