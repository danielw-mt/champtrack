import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:handball_performance_tracker/core/constants/game_actions.dart';
import 'package:handball_performance_tracker/features/statistics/statistics.dart';
import 'package:handball_performance_tracker/core/constants/game_actions.dart';
// import 'package:handball_performance_tracker/oldcontrollers/persistent_controller.dart';
// import 'package:handball_performance_tracker/oldcontrollers/temp_controller.dart';
// import 'statistic_card_elements.dart';
// import 'package:handball_performance_tracker/data/models/player_model.dart';
import 'package:handball_performance_tracker/data/models/game_model.dart';
import 'package:handball_performance_tracker/data/models/team_model.dart';
// import 'package:handball_performance_tracker/core/constants/game_actions.dart';
// import 'package:logger/logger.dart';
// import 'statistic_dropdowns.dart';

class TeamStatistics extends StatefulWidget {
  const TeamStatistics({Key? key}) : super(key: key);

  @override
  State<TeamStatistics> createState() => _TeamStatisticsState();
}

class _TeamStatisticsState extends State<TeamStatistics> {
  //PersistentController _persistentController = Get.put(PersistentController());
  // StatisticsBloc _statisticsBloc = ;
  List<Game> _games = [];
  List<Team> _teams = [];
  Map<String, dynamic> _statistics = {};
  Team _selectedTeam = Team(players: [], onFieldPlayers: []);
  Game _selectedGame = Game(date: DateTime.fromMicrosecondsSinceEpoch(0));

  @override
  void initState() {
    _teams = []; //_persistentController.getAvailableTeams();
    _statistics = {}; // _persistentController.getStatistics();
    // index access safety
    if (_teams.length > 0) {
      //_selectedTeam = _teams[0];
      // get allGame that are cached in persistentController
      List<Game> allGames = []; // _persistentController.getAllGames(teamId: _selectedTeam.id);
      // only actually show games that are in the statistics map
      _games = allGames.where((game) => _statistics.containsKey(game.id)).toList();
      // if there are no teams ofc there are no players and no games
    } else {
      _games = [];
    }
    if (_games.length > 0) {
      _selectedGame = _games[0];
    }
    super.initState();
  }

  void onGameSelected(Game game) {
    setState(() {
      _selectedGame = game;
    });
  }

  void onTeamSelected(Team team) {
    setState(() {
      _selectedTeam = team;
      //List<Game> allGames = []; // _persistentController.getAllGames(teamId: _selectedTeam.id);
      // only actually show games that are in the statistics map
      // _games = allGames.where((game) => _statistics.containsKey(game.id)).toList();
      // _selectedGame = _games[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    // get statistics bloc
    final statisticsBloc = context.watch<StatisticsBloc>();
    Map<String, int> actionCounts = {};
    Map<String, List<int>> actionSeries = {};
    int startTime = 0;
    int stopTime = 0;
    List<List<double>> quotas = [
      [0, 0],
      [0, 0],
      [0, 0]
    ];
    List<double> efScoreSeries = [];
    List<int> timeStamps = [];
    try { 
      Map<String, dynamic> teamStats = _statistics[_selectedGame.id]["team_stats"][_selectedTeam.id];
      //Map<String, dynamic> teamStats = _statistics[statisticsBloc.state.selectedGame.id]["team_stats"][statisticsBloc.state.selectedTeam.id];
      // try to get action counts for the player
      actionCounts = teamStats["action_counts"];
      // try to get action_series for player
      actionSeries = teamStats["action_series"];

      // try to get ef-score series for player
      efScoreSeries = teamStats["ef_score_series"];
      // try to get all action timestamps for player
      timeStamps = teamStats["all_action_timestamps"];
      // try to get start time for game
      startTime = _statistics[_selectedGame.id]["start_time"];
      stopTime = _statistics[_selectedGame.id]["stop_time"];

      // try to get quotas for player
      quotas[0][0] = double.parse(teamStats["seven_meter_quota"][0].toString());
      quotas[0][1] = double.parse(teamStats["seven_meter_quota"][1].toString());
      quotas[1][0] = double.parse(teamStats["position_quota"][0].toString());
      quotas[1][1] = double.parse(teamStats["position_quota"][1].toString());
      quotas[2][0] = double.parse(teamStats["throw_quota"][0].toString());
      quotas[2][1] = double.parse(teamStats["throw_quota"][1].toString());
    } on Exception catch (e) {
      logger.e(e);
    } catch (e) {
      logger.e(e);
    }
    print("#########");
    print(statisticsBloc.state.allTeams);

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
                                TeamSelector(onTeamSelected: onTeamSelected),
                                GameSelector()
                              ],
                            ),
                          )),
                      Flexible(
                        flex: 2,
                        child: 
                        QuotaCard(
                          ring_form: true,
                          quotas: quotas,
                        ),
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
                            actionSeries: actionSeries, efScoreSeries: [], allActionTimeStamps: timeStamps, startTime: startTime, stopTime: stopTime),
                      ),
                      Expanded(
                        // TODO change ActionCards to stateless widget
                        child: ActionsCard(actionCounts),
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
                  // only pass the penalty values if they can be found in the actionCounts map
                  // if there is no value for that penalty pass 0
                  child: 
                  PenaltyInfoCard(
                    redCards: actionCounts[redCardTag] == null ? 0 : actionCounts[redCardTag]!,
                    yellowCards: actionCounts[yellowCardTag] == null ? 0 : actionCounts[yellowCardTag]!,
                    timePenalties: actionCounts[timePenaltyTag] == null ? 0 : actionCounts[timePenaltyTag]!,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Card(child: Image(image: AssetImage('images/statistics2_heatmap.jpg'))),
                )
              ],
            )),
      ],
    ));
  }
}
