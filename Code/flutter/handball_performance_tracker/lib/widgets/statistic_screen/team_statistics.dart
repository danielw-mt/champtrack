import 'package:flutter/material.dart';
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
                        child: QuotesPosition(
                      ring_form: true,
                    )),
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
                                  child: ActionsCard(
                                    {},
                                  ),
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
