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
                        child: QuotaCard(
                      quotas: [
                        [0, 0],
                        [0, 0],
                        [0, 0]
                      ],
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
                                  child: PerformanceCard(
                                    efScoreSeries: [],
                                    allActionTimeStamps: [],
                                    startTime: 0,
                                    stopTime: 0,
                                    actionSeries: {},
                                  ),
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
      ),
    );
  }
}
