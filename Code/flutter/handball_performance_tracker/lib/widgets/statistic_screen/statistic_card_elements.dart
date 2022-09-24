import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/controllers/persistent_controller.dart';
import 'package:handball_performance_tracker/widgets/statistic_screen/bar_chart_example.dart';
import 'charts.dart';
import 'package:get/get.dart';
import '../../data/player.dart';

class CardsInfoCard extends StatelessWidget {
  const CardsInfoCard({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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

class ActionsCard extends StatefulWidget {
  Map<String, int> actionCounts;
  ActionsCard({Key? key, required this.actionCounts}) : super(key: key);
  @override
  _ActionsCardState createState() => _ActionsCardState(actionCounts);
}

class _ActionsCardState extends State<ActionsCard> {
  Map<String, int> _actionCounts = {};
  _ActionsCardState(this._actionCounts);
  PersistentController persistentController = Get.find<PersistentController>();
  int currentTab = 0;
  Map<String, int> actionCounts = {};

  @override
  Widget build(BuildContext context) {
    if (currentTab == 0) {
      return Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(onPressed: () {setState(() {
                      currentTab = 1;
                    });}, child: Text("Table View")),
                  ],
                )),
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
    if (currentTab == 1) {
      return Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            currentTab = 0;
                          });
                        },
                        child: Text("Pie Chart View")),
                  ],
                )),
            Flexible(
              flex: 4,
              child: DataTable(columns: const <DataColumn>[
                DataColumn(
                  label: Text("Action"),
                ),
                DataColumn(
                  label: Text("Count"),
                ),
              ], rows: 
                List<DataRow>.generate(actionCounts.length, (index) => DataRow(cells: [
                  DataCell(Text(actionCounts.keys.elementAt(index).toString())),
                  DataCell(Text(actionCounts.values.elementAt(index).toString()))
                ]))
              ),
            )
          ],
        ),
      );
    }
    return Container();
  }
}

class PerformanceCard extends StatefulWidget {
  const PerformanceCard({Key? key}) : super(key: key);
  @override
  _PerformanceCardState createState() => _PerformanceCardState();
}

class _PerformanceCardState extends State<PerformanceCard> {
  int currentGraph = 0;
  List graphs = [LineChartWidget(), BarChartSample2State()];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(flex: 1, child: PerformanceDropDownButton()),
          Flexible(flex: 4, child: graphs[currentGraph]),
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
      isExpanded: true,
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

class QuotesPosition extends StatelessWidget {
  const QuotesPosition({Key? key, required this.ring_form}) : super(key: key);

  final ring_form;

  @override
  Widget build(BuildContext context) {
    return Card(child: ListView.builder(
      //padding: EdgeInsets.symmetric(vertical: 5.0),
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return _buildCarousel(context, index ~/ 2, ring_form);
        } else {
          return Divider();
        }
      },
    ));
  }

  Widget _buildCarousel(
      BuildContext context, int carouselIndex, bool ring_form) {
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
                    context, carouselIndex, itemIndex, ring_form);
              } else {
                return _buildCarouselItem(context, carouselIndex, itemIndex);
              }
            },
          ),
        )
      ],
    );
  }

  Widget _buildCarouselItemQuotes(
      BuildContext context, int carouselIndex, int itemIndex, bool ring_form) {
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
                  child: OwnPieChart(ring_form: true),
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
                  child: OwnPieChart(ring_form: true),
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
                  child: OwnPieChart(ring_form: true),
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

class PlayerList extends StatefulWidget {
  const PlayerList({Key? key}) : super(key: key);
  @override
  _PlayerListState createState() => _PlayerListState();
}

class _PlayerListState extends State<PlayerList> {
  List<String> playerNames = [
    "Player 1",
    "Player 2",
    "Player 3",
    "Player 4",
    "Player 5",
    "Player 6",
    "Player 7",
    "Player 8",
    "Player 9",
    "Player 10",
    "Player 11",
    "Player 12"
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListView.builder(
      itemBuilder: (BuildContext, index) {
        return Card(
          child: ListTile(
            title: Text(playerNames[index]),
            subtitle: Text("This is subtitle"),
          ),
        );
      },
      itemCount: playerNames.length,
      shrinkWrap: true,
      padding: EdgeInsets.all(5),
      scrollDirection: Axis.vertical,
    ));
  }
}
