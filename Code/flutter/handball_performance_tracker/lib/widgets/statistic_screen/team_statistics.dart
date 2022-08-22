import 'package:flutter/material.dart';
import 'charts.dart';
import 'statistic_card_elements.dart';

class TeamStatistics extends StatelessWidget {
  const TeamStatistics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Payer List in this Team
          Flexible(
              flex: 1,
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: <Widget>[
                  Container(
                    height: 50,
                    color: Colors.amber[600],
                    child: const Center(child: Text('Spieler A')),
                  ),
                  Container(
                    height: 50,
                    color: Colors.amber[500],
                    child: const Center(child: Text('Spieler B')),
                  ),
                  Container(
                    height: 50,
                    color: Colors.amber[100],
                    child: const Center(child: Text('Spieler C')),
                  ),
                ],
              )),
          // Quotes
          Flexible(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: Card(child: QuotesPosition()),
                  ),
                  Flexible(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                            flex: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: PerformanceCard(),
                                ),
                                Expanded(
                                  child: ActionsCard(),
                                )
                              ],
                            )),
                      ],
                    ),
                  )
                ],
              )),
          Flexible(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: CardsInfoCard(),
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
      ),
    );
  }
}
