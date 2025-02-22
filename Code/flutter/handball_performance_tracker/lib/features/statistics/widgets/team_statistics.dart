import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/features/statistics/statistics.dart';
import 'package:handball_performance_tracker/core/constants/game_actions.dart';

class TeamStatistics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // get statistics bloc
    final statisticsBloc = context.watch<StatisticsBloc>();
    List<String> _dropDownElements = [];

    statisticsBloc.state.selectedTeamStats.actionSeries.keys
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
                              children: [TeamSelector(), GameSelector()],
                            ),
                          )),
                      Expanded(
                        flex: 2,
                        child: QuotaCard(
                            quotas:
                                statisticsBloc.state.selectedTeamStats.quotas,
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
                      Expanded(
                        child: PerformanceCard(
                          selectedDropdownElement: statisticsBloc
                              .state.selectedTeamPerformanceParameter,
                          dropDownElements: _dropDownElements,
                          actionSeries: statisticsBloc
                              .state.selectedTeamStats.actionSeries,
                          efScoreSeries: [],
                          allActionTimeStamps:
                              statisticsBloc.state.selectedTeamStats.timeStamps,
                          startTime:
                              statisticsBloc.state.selectedTeamStats.startTime,
                          stopTime:
                              statisticsBloc.state.selectedTeamStats.stopTime,
                          teamPerformanceParameter: true,
                        ),
                      ),
                      Expanded(
                        child: ActionsCard(
                            actionCounts: statisticsBloc
                                .state.selectedTeamStats.actionCounts),
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
                    redCards: statisticsBloc
                            .state.selectedTeamStats.actionCounts[redCardTag] ??
                        0,
                    yellowCards: statisticsBloc.state.selectedTeamStats
                            .actionCounts[yellowCardTag] ??
                        0,
                    timePenalties: statisticsBloc.state.selectedTeamStats
                            .actionCounts[timePenaltyTag] ??
                        0,
                  ),
                ),
                Expanded(
                  flex: 4,
                  //child: HeatMapCard(),
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
