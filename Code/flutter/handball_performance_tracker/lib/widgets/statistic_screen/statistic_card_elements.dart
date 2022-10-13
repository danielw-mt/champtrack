import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/controllers/persistent_controller.dart';
import 'package:handball_performance_tracker/widgets/statistic_screen/bar_chart_example.dart';
import 'charts.dart';
import 'package:get/get.dart';
import '../../data/player.dart';
import '../../utils/action_mapping.dart';

class PenaltyInfoCard extends StatelessWidget {
  final int redCards;
  final int yellowCards;
  final int timePenalties;

  // initialize card values by default with 0
  const PenaltyInfoCard({Key? key, this.redCards = 0, this.yellowCards = 0, this.timePenalties = 0}) : super(key: key);
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
                  child: IconButton(
                      icon: Image.asset('statistic_screen/yellow_card_button.png'),
                      onPressed: () {
                        // do nothing
                      }),
                ),
                Flexible(
                  flex: 1,
                  child: Text(yellowCards.toString()),
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
                  child: IconButton(
                    icon: Image.asset('statistic_screen/red_card_button.png'),
                    onPressed: () {
                      // do nothing
                    },
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Text(redCards.toString()),
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
                  child: IconButton(
                    icon: Image.asset('statistic_screen/time_penalty_button.png'),
                    onPressed: () {
                      // do nothing
                    },
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Text(timePenalties.toString()),
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
                    ? SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: DataTable(
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
                                      // convert action tag to the correct string specified in the strings using realActionType
                                      DataCell(Text(realActionType(widget.actionCounts.keys.elementAt(index)))),
                                      DataCell(Text(widget.actionCounts.values.elementAt(index).toString()))
                                    ]))),
                      )
                    : Text("No actions recorded for the selected player and game"))
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
  final List<double> efScoreSeries;
  final List<int> allActionTimeStamps;

  const PerformanceCard(
      {Key? key,
      required this.actionSeries,
      required this.startTime,
      required this.stopTime,
      required this.efScoreSeries,
      required this.allActionTimeStamps})
      : super(key: key);
  @override
  _PerformanceCardState createState() => _PerformanceCardState();
}

class _PerformanceCardState extends State<PerformanceCard> {
  String _selectedDropdownElement = "";
  List<String> _dropDownElements = [];

  @override
  Widget build(BuildContext context) {
    if (widget.actionSeries.length == 0) {
      return Center(child: Text("No data available"));
    }
    // add the ef-score option to the action series dropdown elements
    _dropDownElements = [];
    if (widget.efScoreSeries.length > 0) {
      _dropDownElements.add("Ef-Score");
    }
    widget.actionSeries.keys.toList().forEach((String actionType) {
      // convert action tag to the correct string specified in the strings using realActionType
      _dropDownElements.add(actionType);
    });

    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(flex: 1, child: buildActionTypeDropdown()),
          Flexible(
              flex: 4,
              // when we selected ef-score in the dropdown use the timestamps from all the actions and not the series timestamps
              // also use the values from the ef-score series that lign up with the timestamps for all actions
              child: _selectedDropdownElement == "Ef-Score"
                  ? LineChartWidget(
                      startTime: widget.startTime,
                      timeStamps: widget.allActionTimeStamps,
                      values: widget.efScoreSeries,
                      stopTime: widget.stopTime,
                    )
                  : LineChartWidget(
                      startTime: widget.startTime,
                      timeStamps: widget.actionSeries[_selectedDropdownElement]!,
                      stopTime: widget.stopTime,
                      values: [],
                    )),
        ],
      ),
    );
  }

  DropdownButton buildActionTypeDropdown() {
    if (_selectedDropdownElement == "") {
      _selectedDropdownElement = _dropDownElements[0];
    }
    return DropdownButton<String>(
      isExpanded: true,
      // Initial Value
      value: _selectedDropdownElement,

      // Down Arrow Icon
      icon: const Icon(Icons.keyboard_arrow_down),

      // Array list of items

      items: _dropDownElements.map((String dropdownElement) {
        return DropdownMenuItem(
          value: dropdownElement,
          // if the element is Ef-score don't do anything.
          //If it is one of the action type series then convert the tag to the correct string using realActionType
          child: dropdownElement == "Ef-score" ? Text(dropdownElement) : Text(realActionType(dropdownElement)),
        );
      }).toList(),
      // After selecting the desired option,it will
      // change button value to selected value
      onChanged: (String? newDropdownElement) {
        setState(() {
          _selectedDropdownElement = newDropdownElement!;
        });
      },
    );
  }
}

class QuotaCard extends StatefulWidget {
  final List<List<double>> quotas;
  final ring_form;
  const QuotaCard({Key? key, required this.ring_form, required this.quotas}) : super(key: key);

  @override
  State<QuotaCard> createState() => _QuotaCardState();
}

class _QuotaCardState extends State<QuotaCard> {
  int _selectedCarousalIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Card(child: _buildCarousel(context, _selectedCarousalIndex ~/ 2, widget.ring_form));
  }

  Widget _buildCarousel(BuildContext context, int carouselIndex, bool ring_form) {
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
                return _buildCarouselItemQuotes(context, carouselIndex, itemIndex, ring_form);
              } else {
                return Container(); // TODO this is not ready yet //_buildCarouselItem(context, carouselIndex, itemIndex);
              }
            },
          ),
        )
      ],
    );
  }

  Widget _buildCarouselItemQuotes(BuildContext context, int carouselIndex, int itemIndex, bool ring_form) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 1,
          child: widget.quotas[0][1] != 0
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Flexible(
                      flex: 1,
                      child: Text("7m Quota"),
                    ),
                    Flexible(
                      flex: 2,
                      child: QuotaPieChart(
                        ringForm: true,
                        dataMap: {"7m goals": widget.quotas[0][0], "7 meters": widget.quotas[0][1]},
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Text(widget.quotas[0][1].toString() + "total 7m throws"),
                    )
                  ],
                )
              : Text("No 7m throws recorded"),
        ),
        Flexible(
          flex: 1,
          child: widget.quotas[1][1] != 0
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Flexible(
                      flex: 1,
                      child: Text("Postition Quota"),
                    ),
                    Flexible(
                      flex: 2,
                      child: QuotaPieChart(
                        ringForm: true,
                        dataMap: {"Goals": widget.quotas[1][0], "Position throws": widget.quotas[1][1]},
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Text(widget.quotas[1][1].toString() + "total position throws"),
                    )
                  ],
                )
              : Text("No throws from position recorded"),
        ),
        Flexible(
          flex: 1,
          child: widget.quotas[2][1] != 0
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Flexible(
                      flex: 1,
                      child: Text("Throw Quota"),
                    ),
                    Flexible(
                      flex: 2,
                      child: QuotaPieChart(ringForm: true, dataMap: {"Total goals": widget.quotas[2][0], "Total throws": widget.quotas[2][1]}),
                    ),
                    Flexible(
                      flex: 2,
                      child: Text(widget.quotas[2][1].toString() + " total throws onto goal"),
                    )
                  ],
                )
              : Text("No goal attempts recorded"),
        ),
      ],
    );
  }

  Widget _buildCarouselItem(BuildContext context, int carouselIndex, int itemIndex) {
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
