import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/core/constants/game_actions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/features/statistics/statistics.dart';

class PlayerStatistics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final StatisticsBloc statisticsBloc =
        BlocProvider.of<StatisticsBloc>(context);

    List<String> _dropDownElements = [];

    statisticsBloc.state.selectedPlayerStats.actionSeries.keys
        .toList()
        .forEach((String actionTag) {
      // convert action tag to the correct string specified in the strings using realActionType
      _dropDownElements.add(actionTag);
    });

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
                      Expanded(
                          flex: 1,
                          child: Card(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TeamSelector(),
                              GameSelector(), //games: _games, onGameSelected: onGameSelected),
                              PlayerSelector()
                            ],
                          ))),
                      Flexible(
                        flex: 2,
                        child: QuotaCard(
                            quotas:
                                statisticsBloc.state.selectedPlayerStats.quotas,
                            ring_form: true),
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
                        child: PerformanceCard(
                          selectedDropdownElement: statisticsBloc
                              .state.selectedPlayerPerformanceParameter,
                          dropDownElements: _dropDownElements,
                          actionSeries: statisticsBloc
                              .state.selectedPlayerStats.actionSeries,
                          efScoreSeries: statisticsBloc
                              .state.selectedPlayerStats.efScoreSeries,
                          allActionTimeStamps: statisticsBloc
                              .state.selectedPlayerStats.timeStamps,
                          startTime: statisticsBloc
                              .state.selectedPlayerStats.startTime,
                          stopTime:
                              statisticsBloc.state.selectedPlayerStats.stopTime,
                          teamPerformanceParameter: false,
                        ),
                      ),
                      Expanded(
                        child: ActionsCard(
                            actionCounts: statisticsBloc
                                .state.selectedPlayerStats.actionCounts),
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
                  child: PenaltyInfoCard(
                    yellowCards: statisticsBloc.state.selectedPlayerStats
                            .actionCounts[yellowCardTag] ??
                        0,
                    redCards: statisticsBloc.state.selectedPlayerStats
                            .actionCounts[redCardTag] ??
                        0,
                    timePenalties: statisticsBloc.state.selectedPlayerStats
                            .actionCounts[timePenaltyTag] ??
                        0,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Card(
                      child: Image(
                          image: AssetImage('files/statistics2_heatmap.jpg'))),
                )
              ],
            )),
      ],
    ));
  }
}
