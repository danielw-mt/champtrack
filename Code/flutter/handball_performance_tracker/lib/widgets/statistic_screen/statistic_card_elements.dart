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
  final Map<String, int> actionCounts;
  const ActionsCard(this.actionCounts);

  @override
  _ActionsCardState createState() => _ActionsCardState();
}

class _ActionsCardState extends State<ActionsCard> {
  PersistentController persistentController = Get.find<PersistentController>();
  int currentTab = 0;

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
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            currentTab = 1;
                          });
                        },
                        child: Text("Table View")),
                  ],
                )),
            Flexible(
              flex: 1,
              child: Text("% Actions"),
            ),
            Flexible(
              flex: 4,
              child: PieChartActionsWidget(widget.actionCounts),
            ),
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
                child: widget.actionCounts != {}
                    ? DataTable(
                        columns: const <DataColumn>[
                            DataColumn(
                              label: Text("Action"),
                            ),
                            DataColumn(
                              label: Text("Count"),
                            ),
                          ],
                        rows: List<DataRow>.generate(
                            widget.actionCounts.length,
                            (index) => DataRow(cells: [
                                  DataCell(Text(widget.actionCounts.keys
                                      .elementAt(index)
                                      .toString())),
                                  DataCell(Text(widget.actionCounts.values
                                      .elementAt(index)
                                      .toString()))
                                ])))
                    : Text(
                        "No actions recorded for the selected player and game"))
          ],
        ),
      );
    }
    return Container();
  }
}

class PerformanceCard extends StatefulWidget {
  final Map<String, List<int>> actionSeries;
  final int startTime;
  final int stopTime;

  const PerformanceCard(
      {Key? key,
      required this.actionSeries,
      required this.startTime,
      required this.stopTime})
      : super(key: key);
  @override
  _PerformanceCardState createState() => _PerformanceCardState();
}

class _PerformanceCardState extends State<PerformanceCard> {
  int currentGraph = 0;
  String _selectedActionType = "";

  @override
  Widget build(BuildContext context) {
    print("rebuilding performance card: " + widget.actionSeries.toString());
    if (widget.actionSeries.length == 0) {
      return Text("No data available");
    }
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(flex: 1, child: buildActionTypeDropdown()),
          Flexible(
              flex: 4,
              child: LineChartWidget(
                startTime: widget.startTime,
                timeStamps: widget.actionSeries[_selectedActionType]!,
                stopTime: widget.stopTime,
                values: [],
              )),
        ],
      ),
    );
  }

  DropdownButton buildActionTypeDropdown() {
    if (_selectedActionType == "" ||
        widget.actionSeries.containsKey(_selectedActionType) == false) {
      _selectedActionType = widget.actionSeries.keys.elementAt(0);
    }
    return DropdownButton<String>(
      isExpanded: true,
      // Initial Value
      value: _selectedActionType,

      // Down Arrow Icon
      icon: const Icon(Icons.keyboard_arrow_down),

      // Array list of items
      items: widget.actionSeries.keys.map((String actionType) {
        return DropdownMenuItem(
          value: actionType,
          child: Text(actionType),
        );
      }).toList(),
      // After selecting the desired option,it will
      // change button value to selected value
      onChanged: (String? newActionType) {
        setState(() {
          _selectedActionType = newActionType!;
        });
      },
    );
  }
}

class QuotaCard extends StatefulWidget {
  const QuotaCard({Key? key, required this.ring_form}) : super(key: key);

  final ring_form;

  @override
  State<QuotaCard> createState() => _QuotaCardState();
}

class _QuotaCardState extends State<QuotaCard> {
  int _selectedCarousalIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Card(child: 
          _buildCarousel(context, _selectedCarousalIndex ~/ 2, widget.ring_form));
       
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
            onPageChanged: (pageIndex) => setState(() {
              _selectedCarousalIndex = pageIndex;
            }),
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
    return Row(
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
        Expanded(
            child: LineChartWidget(
          startTime: 0,
          stopTime: 0,
          timeStamps: [],
          values: [],
        ))
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
