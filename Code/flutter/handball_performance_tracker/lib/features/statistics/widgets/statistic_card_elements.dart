import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/core/core.dart';
import 'package:handball_performance_tracker/features/statistics/statistics.dart';
import 'package:carousel_slider/carousel_slider.dart';

class PenaltyInfoCard extends StatelessWidget {
  final int redCards;
  final int yellowCards;
  final int timePenalties;

  //initialize card values by default with 0
  const PenaltyInfoCard(
      {Key? key,
      this.redCards = 0,
      this.yellowCards = 0,
      this.timePenalties = 0})
      : super(key: key);
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
                  child: Image(
                      image: AssetImage(
                          'files/statistic_screen/yellow_card_button.jpg')),
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
                  child: Image(
                      image: AssetImage(
                          'files/statistic_screen/red_card_button.jpg')),
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
                  child: Image(
                      image: AssetImage(
                          'files/statistic_screen/time_penalty_button.jpg')),
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

class ActionsCard extends StatelessWidget {
  final Map<String, int> actionCounts;

  const ActionsCard({super.key, required this.actionCounts});

  @override
  Widget build(BuildContext context) {
    // get statistics bloc
    final statisticsBloc = context.watch<StatisticsBloc>();
    // print statistics bloc state action counts
    //print(statisticsBloc.state.selectedTeamStats.actionCounts);

    if (statisticsBloc.state.pieChartView) {
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
                          // call bloc event to change pie chart view to false
                          statisticsBloc.add(PieChartView(pieChartView: false));
                        },
                        child: Text(StringsGeneral.lTableView)),
                  ],
                )),
            Flexible(
              flex: 4,
              child: PieChartActionsWidget(actionCounts),
            ),
          ],
        ),
      );
    } else {
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
                          // call bloc event to change pie chart view to false
                          statisticsBloc.add(PieChartView(pieChartView: true));
                        },
                        child: Text(StringsGeneral.lPieChartView)),
                  ],
                )),
            Flexible(
                flex: 4,
                child: actionCounts != {}
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
                                actionCounts.length,
                                (index) => DataRow(cells: [
                                      // convert action tag to the correct string specified in the strings using realActionType
                                      DataCell(Text(realActionTag(
                                          actionCounts.keys.elementAt(index)))),
                                      DataCell(Text(actionCounts.values
                                          .elementAt(index)
                                          .toString()))
                                    ]))),
                      )
                    : Text(StringsGeneral.lNoActionsRecorded))
          ],
        ),
      );
    }
  }
}

// class PerformanceCard extends StatefulWidget {
//   final Map<String, List<int>> actionSeries;
//   final int startTime;
//   final int stopTime;
//   final List<double> efScoreSeries;
//   final List<int> allActionTimeStamps;

//   const PerformanceCard(
//       {Key? key,
//       required this.actionSeries,
//       required this.startTime,
//       required this.stopTime,
//       required this.efScoreSeries,
//       required this.allActionTimeStamps})
//       : super(key: key);
//   @override
//   _PerformanceCardState createState() => _PerformanceCardState();
// }

class PerformanceCard extends StatelessWidget {
  final String selectedDropdownElement;
  final List<String> dropDownElements;
  final Map<String, List<int>> actionSeries;
  final int startTime;
  final int stopTime;
  final List<double> efScoreSeries;
  final List<int> allActionTimeStamps;
  final bool
      teamPerformanceParameter; // if true change selectedTeamPerformanceParameter, else change selectedPlayerPerformanceParameter

  const PerformanceCard(
      {super.key,
      required this.selectedDropdownElement,
      required this.dropDownElements,
      required this.actionSeries,
      required this.startTime,
      required this.stopTime,
      required this.efScoreSeries,
      required this.allActionTimeStamps,
      required this.teamPerformanceParameter});

  @override
  Widget build(BuildContext context) {

    // check if data is available, if not display text
    return selectedDropdownElement == StringsGeneral.lNoDataAvailable
        ? Card(child: Text(StringsGeneral.lNoDataAvailable))
        : Card(
            child: Padding(
              padding: EdgeInsets.all(6.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                      flex: 1,
                      child: buildActionTagDropdown(
                          context, teamPerformanceParameter)),
                  Flexible(
                      flex: 4,
                      // when we selected ef-score in the dropdown use the timestamps from all the actions and not the series timestamps
                      // also use the values from the ef-score series that lign up with the timestamps for all actions
                      child: selectedDropdownElement == "Ef-Score"
                          ? LineChartWidget(
                              startTime: startTime,
                              timeStamps: allActionTimeStamps,
                              values: efScoreSeries,
                              stopTime: stopTime,
                            )
                          : LineChartWidget(
                              startTime: startTime,
                              timeStamps:
                                  actionSeries[selectedDropdownElement]!,
                              stopTime: stopTime,
                              values: [],
                            )),
                ],
              ),
            ),
          );
  }

  DropdownButton buildActionTagDropdown(
      BuildContext context, bool teamPerformanceParameter) {
    // get statistics bloc
    final statisticsBloc = BlocProvider.of<StatisticsBloc>(context);
    return DropdownButton<String>(
      isExpanded: true,
      // Initial Value
      value: selectedDropdownElement,

      // Down Arrow Icon
      icon: const Icon(Icons.keyboard_arrow_down),

      // Array list of items
      items: dropDownElements.map((String dropdownElement) {
        if (actionSeries[dropdownElement] == null &&
            dropdownElement != "Ef-Score") {
          print("cannot display dropdown element" +
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
          child: dropdownElement == "Ef-score"
              ? Text(dropdownElement)
              : Text(realActionTag(dropdownElement)),
        );
      }).toList(),
      // After selecting the desired option,it will
      // change button value to selected value
      onChanged: (String? newDropdownElement) {
        // call selectTeamPerformanceParamter from statisticsbloc event
        print(newDropdownElement);
        if (teamPerformanceParameter) {
          statisticsBloc.add(SelectTeamPerformanceParameter(
            parameter: newDropdownElement!,
          ));
        } else {
          statisticsBloc.add(SelectPlayerPerformanceParameter(
            parameter: newDropdownElement!,
          ));
        }
        // context.watch<StatisticsBloc>().add(SelectPerformanceParameter(

        //     parameter: newDropdownElement!,
        //     teamParameter: teamPerformanceParameter));
      },
    );
  }
}

class QuotaCard extends StatelessWidget {
  final List<List<double>> quotas;
  final ring_form;
  const QuotaCard({Key? key, required this.ring_form, required this.quotas})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, double> sevenMeterDataMap = {
      "7m goals": quotas[0][0],
      "7m misses": quotas[0][1] - quotas[0][0]
    };
    Map<String, double> throwDataMap = {
      "Throw goals": quotas[2][0],
      "Throw misses": quotas[2][1] - quotas[2][0]
    };
    Map<String, double> paradeDataMap = {
      "Parades": quotas[3][0],
      "Goals opponent": quotas[3][1] - quotas[3][0]
    };

    List<Row> quota_charts = [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            flex: 1,
            child: quotas[0][1] != 0
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Flexible(
                        flex: 1,
                        child: Text(StringsGeneral.l7mThrowsRecord),
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
                        child: Text(((quotas[0][0] / quotas[0][1]) * 100)
                                .toStringAsFixed(0) +
                            "% " +
                            StringsGeneral.l7mQuota),
                      )
                    ],
                  )
                : Text(StringsGeneral.lNo7mQuota),
          ),
          Flexible(
            flex: 1,
            child: quotas[2][1] != 0
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Flexible(
                        flex: 1,
                        child: Text(StringsGeneral.lThrowsRecord),
                      ),
                      Flexible(
                        flex: 2,
                        child: QuotaPieChart(
                            ringForm: true, dataMap: throwDataMap),
                      ),
                      Flexible(
                        flex: 2,
                        child: Text(((quotas[2][0] / quotas[2][1]) * 100)
                                .toStringAsFixed(0) +
                            "% " +
                            StringsGeneral.lThrowQuota),
                      )
                    ],
                  )
                : Text(StringsGeneral.lNoThrowQuota),
          ),
          Flexible(
            flex: 1,
            child: quotas[3][1] != 0
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Flexible(
                        flex: 1,
                        child: Text(StringsGeneral.lThrowsOpponent),
                      ),
                      Flexible(
                        flex: 2,
                        child: QuotaPieChart(
                          ringForm: true,
                          dataMap: paradeDataMap,
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Text(((quotas[3][0] / quotas[3][1]) * 100)
                                .toStringAsFixed(0) +
                            "% " +
                            StringsGeneral.lGoalkeeperQuota),
                      )
                    ],
                  )
                : Text(StringsGeneral.lNoGoalkeeperQuota),
          )
        ],
      )
    ];

    return Card(
        child: CarouselSlider(
      options: CarouselOptions(
        enlargeCenterPage: true,
        enableInfiniteScroll: false,
      ),
      items: quota_charts.map<Widget>((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Flexible(flex: 2, child: i));
          },
        );
      }).toList(),
    ));
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

class HeatMapCard extends StatelessWidget {
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
    final StatisticsBloc statisticsBloc =
        BlocProvider.of<StatisticsBloc>(context);

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
        context
            .read<StatisticsBloc>()
            .add(SelectHeatmapParameter(parameter: newDropdownElement!));

        // setState(() {
        //   _selectedDropdownElement = newDropdownElement!;
        // });
      },
    );
  }
}
