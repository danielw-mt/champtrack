import 'package:flutter/material.dart';
import 'statistic_card_elements.dart';

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
                        child: QuotesPosition(ring_form: true,),
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
                        child: PerformanceCard(),
                      ),
                      Expanded(
                        child: ActionsCard(),
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
                Expanded(
                  flex: 4,
                  child: Card(
                    child: Center(child: Text("Game field coming soon")),
                  ),
                )
              ],
            )),
      ],
    ));
  }
}



/*class QuotesCard extends StatefulWidget {
  const QuotesCard({Key? key}) : super(key: key);
  @override
  _QuotesCardState createState() => _QuotesCardState();
}

class _QuotesCardState extends State<QuotesCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Flexible(
                  flex: 1,
                  child: Text("Wurfqoute"),
                ),
                Flexible(
                  flex: 2,
                  child: PieChartQuotesWidget(),
                ),
                Flexible(
                  flex: 2,
                  child: Text("20 Wuerfe"),
                )
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Flexible(
                  flex: 1,
                  child: Text("Quote Postition"),
                ),
                Flexible(
                  flex: 2,
                  child: PieChartQuotesWidget(),
                ),
                Flexible(
                  flex: 2,
                  child: Text("15 Wuerfe"),
                )
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Flexible(
                  flex: 1,
                  child: Text("7m Quote"),
                ),
                Flexible(
                  flex: 2,
                  child: PieChartQuotesWidget(),
                ),
                Flexible(
                  flex: 2,
                  child: Text("7 Wuerfe"),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
*/
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
