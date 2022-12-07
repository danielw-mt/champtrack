import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/features/statistics/statistics.dart';
import 'package:handball_performance_tracker/core/utils/utils.dart';
import 'package:handball_performance_tracker/core/constants/strings_general.dart';

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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 1,
                  child: Image(image: AssetImage('images/statistic_screen/yellow_card_button.jpg')),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 1,
                  child: Image(image: AssetImage('images/statistic_screen/red_card_button.jpg')),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 1,
                  child: Image(image: AssetImage('images/statistic_screen/time_penalty_button.jpg')),
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
    // if we did not select an element yet, select the first one
    if (_selectedDropdownElement == "") {
      _selectedDropdownElement = _dropDownElements[0];
    }
    // if a dropdown element is selected that is not available. (i.e. remnant from loading another game statistic previously)
    if (!_dropDownElements.contains(_selectedDropdownElement)) {
      _selectedDropdownElement = _dropDownElements[0];
    }

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
    return DropdownButton<String>(
      isExpanded: true,
      // Initial Value
      value: _selectedDropdownElement,

      // Down Arrow Icon
      icon: const Icon(Icons.keyboard_arrow_down),

      // Array list of items
      items: _dropDownElements.map((String dropdownElement) {
        if (widget.actionSeries[dropdownElement] == null && dropdownElement != "Ef-Score") {
          print("cannot display dropdown element" + dropdownElement + " which has no data");
          return DropdownMenuItem(
            child: Text("Cannot display statistic"),
            value: dropdownElement,
          );
        }
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
    // convert quotas to correct datamaps for the piecharts
    // 7 meter misses are just the total seven meter atempts - the seven meter goals
    Map<String, double> sevenMeterDataMap = {"7m goals": widget.quotas[0][0], "7 meter misses": widget.quotas[0][1] - widget.quotas[0][0]};
    Map<String, double> positionDataMap = {"Position goals": widget.quotas[1][0], "Position throws": widget.quotas[1][1] - widget.quotas[1][0]};
    Map<String, double> throwDataMap = {"Throw goals": widget.quotas[2][0], "Throw misses": widget.quotas[2][1] - widget.quotas[2][0]};
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          flex: 1,
          child: widget.quotas[0][1] != 0
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Flexible(
                      flex: 1,
                      child: Text(StringsGeneral.l7mQuota),
                    ),
                    Flexible(
                      flex: 2,
                      child: QuotaPieChart(
                        ringForm: true,
                        dataMap: sevenMeterDataMap,
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
        //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //           children: [
        //             const Flexible(
        //               flex: 1,
        //               child: Text(StringsGeneral.lPositionQuota),
        //             ),
        //             Flexible(
        //               flex: 2,
        //               child: QuotaPieChart(
        //                 ringForm: true,
        //                 dataMap: positionDataMap,
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Flexible(
                      flex: 1,
                      child: Text(StringsGeneral.lThrowQuota),
                    ),
                    Flexible(
                      flex: 2,
                      child: QuotaPieChart(ringForm: true, dataMap: throwDataMap),
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
      controller: ScrollController(),
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

// class HeatMapCard extends StatefulWidget {
//   final Map<String, dynamic> actionCoordinatesWithContext;

//   const HeatMapCard({Key? key, required this.actionCoordinatesWithContext})
//       : super(key: key);
//   @override
//   _HeatMapCardState createState() =>
//       _HeatMapCardState(actionCoordinatesWithContext);
// }

class HeatMapCard extends StatelessWidget{
  final Map<String, dynamic> actionCoordinatesWithContext;
  HeatMapCard({super.key, required this.actionCoordinatesWithContext});
  //_HeatMapCardState(this.actionCoordinatesWithContext);

  String _selectedDropdownElement = "";
  List<String> _dropDownElements = [];

  @override
  // void initState() {
  //   super.initState();

  //   print("fake action context");
  //   print(actionContextFake);
  //   print("fake action coordinates");
  //   print(actionCoordinatesFake);

  //   // TODO remove here once the real data is available
  //   for (String action in actionCoordinatesFake.keys) {
  //     List<dynamic>? coordinates = actionCoordinatesFake[action];
  //     List<String>? context = actionContextFake[action];
  //     List<dynamic> coordinatesWithContext = [];
  //     for (int i = 0; i < coordinates!.length; i++) {
  //       coordinatesWithContext
  //           .add({"coordinates": coordinates[i], "context": context![i]});
  //     }
  //     actionCoordinatesWithContext[action] = coordinatesWithContext;
  //   }
  //   print("coordinates with context");
  //   print(actionCoordinatesWithContext);
  // }

  final Map<String, List<dynamic>> actionCoordinatesFake = {
    "parade": [
      [3.0, 3.0]
    ],
    "goal_goalkeeper": [
      [3.0, 3.0],
      [20.0, 180.0]
    ],
    "block_steal": [
      [200.0, 33.0],
      [31.0, 35.0],
      [20.0, 30.0]
    ],
    "goal": [
      [33.0, 63.0],
      [43.0, 34.0],
      [30.0, 80.0],
      [140, 280]
    ]
  };

  final Map<String, List<String>> actionContextFake = {
    "parade": ["goalkeeper"],
    "goal_goalkeeper": ["goalkeeper", "goalkeeper"],
    "block_steal": ["attack", "defense", "defense"],
    "goal": [
      "attack",
      "attack",
      "attack",
      "defense",
    ]
  };

  Map<String, dynamic> actionCoordinatesWithContextFake = {};

  

  @override
  Widget build(BuildContext context) {
    // get statisticsbloc 
    final StatisticsBloc statisticsBloc = BlocProvider.of<StatisticsBloc>(context);

    if (actionCoordinatesWithContext.length == 0) {
      return Center(child: Text(StringsGeneral.lNoDataAvailable));
    }
    _dropDownElements = actionCoordinatesWithContext.keys.toList();

    // if (actionCoordinatesWithContext.keys.length > 0) {
    //   _dropDownElements = actionCoordinatesWithContext.keys.toList();
    //   //print(_dropDownElements);
    //   _selectedDropdownElement = _dropDownElements[0];
    // }

    // if we did not select an element yet, select the first one
    if (_selectedDropdownElement == "") {
      _selectedDropdownElement = _dropDownElements[0];
    }

    // if a dropdown element is selected that is not available. (i.e. remnant from loading another game statistic previously)
    if (!_dropDownElements.contains(_selectedDropdownElement)) {
      _selectedDropdownElement = _dropDownElements[0];
    }

    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
              flex: 1,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Wurfverteilung"),
                    buildActionTagDropdown(context)
                  ])),
          Expanded(
            flex: 12,
            child: Container(),
            // CardFieldSwitch(
            //     actionCoordinatesWithContext[_selectedDropdownElement]!),
          ),
        ],
      ),
    );
  }

  DropdownButton buildActionTagDropdown(BuildContext context) {
    return DropdownButton<String>(
      isExpanded: false,
      // Initial Value
      value: _selectedDropdownElement,

      // Down Arrow Icon
      icon: const Icon(Icons.keyboard_arrow_down),

      // Array list of items
      items: _dropDownElements.map((String dropdownElement) {
        if (actionCoordinatesWithContext[dropdownElement] == null) {
          print("cannot display dropdown element " +
              dropdownElement +
              " which has no data");
          return DropdownMenuItem(
            child: Text("Cannot display statistic"),
            value: dropdownElement,
          );
        }
        return DropdownMenuItem(
          value: dropdownElement,
          // if the element is Ef-score don't do anything.
          //If it is one of the action type series then convert the tag to the correct string using realActionType
          child: Text(realActionTag(dropdownElement)),
        );
      }).toList(),
      // After selecting the desired option,it will
      // change button value to selected value
      onChanged: (String? newDropdownElement) {
        // call SelectHeatMapParameter event from statistics bloc
        context.read<StatisticsBloc>().add(SelectHeatmapParameter(parameter: newDropdownElement!));

        // setState(() {
        //   _selectedDropdownElement = newDropdownElement!;
        // });
      },
    );
  }
}

