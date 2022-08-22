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
                        child: QuotesPosition(),
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

class QuotesPosition extends StatelessWidget {
  const QuotesPosition({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(child: ListView.builder(
      //padding: EdgeInsets.symmetric(vertical: 5.0),
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return _buildCarousel(context, index ~/ 2);
        } else {
          return Divider();
        }
      },
    ));
  }

  Widget _buildCarousel(BuildContext context, int carouselIndex) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        SizedBox(
          // you may want to use an aspect ratio here for tablet support
          height: 200.0,
          child: PageView.builder(
            // store this controller in a State to save the carousel scroll position
            controller: PageController(viewportFraction: 0.9),
            itemBuilder: (BuildContext context, int itemIndex) {
              if (itemIndex == 0) {
                return _buildCarouselItemQuotes(
                    context, carouselIndex, itemIndex);
              } else {
                return _buildCarouselItem(context, carouselIndex, itemIndex);
              }
            },
          ),
        )
      ],
    );
  }

  Widget _buildCarouselItemQuotes(BuildContext context, int carouselIndex, int itemIndex) {
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

  Widget _buildCarouselItem(
      BuildContext context, int carouselIndex, int itemIndex) {
    return Column(
      children: [
        Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Quotes"),
            Text("Würfe"),
            Text("Position"),
            Text("7m"),
          ],
        )),
        Expanded(child: LineChartWidget())
      ],
    );
  }
}

class QuotesCard extends StatefulWidget {
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

class PerformanceCard extends StatefulWidget {
  const PerformanceCard({Key? key}) : super(key: key);
  @override
  _PerformanceCardState createState() => _PerformanceCardState();
}

class _PerformanceCardState extends State<PerformanceCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(flex: 1, child: PerformanceDropDownButton()),
          Flexible(flex: 4, child: LineChartWidget())
        ],
      ),
    );
  }
}

class PerformanceDropDownButton extends StatefulWidget {
  const PerformanceDropDownButton({Key? key}) : super(key: key);
  @override
  _PerformanceDropDownButtonState createState() =>
      _PerformanceDropDownButtonState();
}

class _PerformanceDropDownButtonState extends State<PerformanceDropDownButton> {
  // Initial Selected Value
  String dropdownvalue = 'Ef-Score';

  // List of items in our dropdown menu
  var items = [
    'Ef-Score',
    'Tore-Spiel',
    'Tore letzes Spiel',
  ];
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      // Initial Value
      value: dropdownvalue,

      // Down Arrow Icon
      icon: const Icon(Icons.keyboard_arrow_down),

      // Array list of items
      items: items.map((String items) {
        return DropdownMenuItem(
          value: items,
          child: Text(items),
        );
      }).toList(),
      // After selecting the desired option,it will
      // change button value to selected value
      onChanged: (String? newValue) {
        setState(() {
          dropdownvalue = newValue!;
        });
      },
    );
  }
}

class ActionsCard extends StatefulWidget {
  const ActionsCard({Key? key}) : super(key: key);
  @override
  _ActionsCardState createState() => _ActionsCardState();
}

class _ActionsCardState extends State<ActionsCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 1,
            child: Text("% Actions"),
          ),
          Flexible(
            flex: 4,
            child: PieChartActionsWidget(),
          ),
          Flexible(
            flex: 4,
            child: PieChartActionsWidget(),
          )
        ],
      ),
    );
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
