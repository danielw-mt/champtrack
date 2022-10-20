import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/constants/stringsGeneral.dart';
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
                      icon: Image(image: AssetImage('images/statistic_screen/yellow_card_button.jpg')),
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
                    icon: Image(image: AssetImage('images/statistic_screen/red_card_button.jpg')),
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
                    icon: Image(image: AssetImage('images/statistic_screen/time_penalty_button.jpg')),
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
                        child: Text(StringsGeneral.lTableView)),
                  ],
                )),
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
                        child: Text(StringsGeneral.lPieChartView)),
                  ],
                )),
            Flexible(
                flex: 4,
                child: widget.actionCounts != {}
                    ? SingleChildScrollView(
                        controller: ScrollController(),
                        scrollDirection: Axis.vertical,
                        child: DataTable(
                            columns: const <DataColumn>[
                              DataColumn(
                                label: Text(StringsGeneral.lAction),
                              ),
                              DataColumn(
                                label: Text(StringsGeneral.lCount),
                              ),
                            ],
                            rows: List<DataRow>.generate(
                                widget.actionCounts.length,
                                (index) => DataRow(cells: [
                                      // convert action tag to the correct string specified in the strings using realActionType
                                      DataCell(Text(realActionTag(widget.actionCounts.keys.elementAt(index)))),
                                      DataCell(Text(widget.actionCounts.values.elementAt(index).toString()))
                                    ]))),
                      )
                    : Text(StringsGeneral.lNoActionsRecorded))
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
    _dropDownElements = [];
    if (widget.actionSeries.length == 0) {
      return Center(child: Text(StringsGeneral.lNoDataAvailable));
    }
    // add the ef-score option to the action series dropdown elements
    if (widget.efScoreSeries.length > 0) {
      _dropDownElements.add("Ef-Score");
    }
    widget.actionSeries.keys.toList().forEach((String actionTag) {
      // convert action tag to the correct string specified in the strings using realActionType
      _dropDownElements.add(actionTag);
    });
    _selectedDropdownElement = _dropDownElements[0];
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(flex: 1, child: buildActionTagDropdown()),
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

  DropdownButton buildActionTagDropdown() {
    if (_selectedDropdownElement == "") {
      _selectedDropdownElement = _dropDownElements[0];
    }
    print("dropdown menu items: $_dropDownElements");
    return DropdownButton<String>(
      isExpanded: true,
      // Initial Value
      value: _selectedDropdownElement,

      // Down Arrow Icon
      icon: const Icon(Icons.keyboard_arrow_down),

      // Array list of items
      items: _dropDownElements.map((String dropdownElement) {
        print("dropdown element: "+dropdownElement);
        // if (widget.actionSeries[dropdownElement] == null && dropdownElement != "Ef-Score") {
        //   print("cannot display dropdown element" +
        //       dropdownElement +
        //       " which has no data");
        //   return DropdownMenuItem(
        //     child: Text("Cannot display statistic"),
        //     value: dropdownElement,
        //   );
        // }
        return DropdownMenuItem(
          value: dropdownElement,
          // if the element is Ef-score don't do anything.
          //If it is one of the action type series then convert the tag to the correct string using realActionType
          child: dropdownElement == "Ef-score" ? Text(dropdownElement) : Text(realActionTag(dropdownElement)),
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
        Expanded(
          // you may want to use an aspect ratio here for tablet support
          //height: 20.0,
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
    print("7m quota: " + widget.quotas[0].toString());
    print("position quota: " + widget.quotas[1].toString());
    print("throw quota: " + widget.quotas[2].toString());
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
                      child: Text(StringsGeneral.l7mQuota),
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
                      child: Text(widget.quotas[0][1].toString() + " " + StringsGeneral.l7mThrowsRecord),
                    )
                  ],
                )
              : Text(StringsGeneral.lNo7mQuota),
        ),
        // TODO implement position quota calculation in statistics engine
        // Flexible(
        //   flex: 1,
        //   child: widget.quotas[1][1] != 0
        //       ? Column(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             const Flexible(
        //               flex: 1,
        //               child: Text(StringsGeneral.lPositionQuota),
        //             ),
        //             Flexible(
        //               flex: 2,
        //               child: QuotaPieChart(
        //                 ringForm: true,
        //                 dataMap: {"Goals": widget.quotas[1][0], "Position throws": widget.quotas[1][1]},
        //               ),
        //             ),
        //             Flexible(
        //               flex: 2,
        //               child: Text(widget.quotas[1][1].toString() + " "+StringsGeneral.lPositonThrowsRecord),
        //             )
        //           ],
        //         )
        //       : Text(StringsGeneral.lNoPositionQuota),
        // ),
        Flexible(
          flex: 1,
          child: widget.quotas[2][1] != 0
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Flexible(
                      flex: 1,
                      child: Text(StringsGeneral.lThrowQuota),
                    ),
                    Flexible(
                      flex: 2,
                      child: QuotaPieChart(ringForm: true, dataMap: {"Total goals": widget.quotas[2][0], "Total throws": widget.quotas[2][1]}),
                    ),
                    Flexible(
                      flex: 2,
                      child: Text(widget.quotas[2][1].toString() + " " + StringsGeneral.lThrowsRecord),
                    )
                  ],
                )
              : Text(StringsGeneral.lNoThrowQuota),
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
