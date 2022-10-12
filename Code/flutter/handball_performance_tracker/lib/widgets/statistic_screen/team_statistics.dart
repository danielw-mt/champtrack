import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/constants/game_actions.dart';
import 'package:handball_performance_tracker/controllers/persistent_controller.dart';
import 'package:handball_performance_tracker/controllers/temp_controller.dart';
import 'statistic_card_elements.dart';
import '../../data/player.dart';
import '../../data/game.dart';
import '../../data/team.dart';
import '../../controllers/temp_controller.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'statistic_dropdowns.dart';

class TeamStatistics extends StatefulWidget {
  const TeamStatistics({Key? key}) : super(key: key);

  @override
  State<TeamStatistics> createState() => _TeamStatisticsState();
}

class _TeamStatisticsState extends State<TeamStatistics> {
  TempController _tempController = Get.put(TempController());
  PersistentController _persistentController = Get.put(PersistentController());
  List<Game> _games = [];
  List<Team> _teams = [];
  Map<String, dynamic> _statistics = {};
  Team _selectedTeam = Team();
  Game _selectedGame = Game(date: DateTime.fromMicrosecondsSinceEpoch(0));

  void onGameSelected(Game game) {
    setState(() {
      _selectedGame = game;
    });
  }

  void onTeamSelected(Team team) {
    setState(() {
      _selectedTeam = team;
      _games = _persistentController.getAllGames(teamId: _selectedTeam.id);
    });
  }

  @override
  void initState() {
    _teams = _persistentController.getAvailableTeams();
    // index access safety
    if (_games.length > 0){
      _selectedGame = _games[0];
    }
    if (_teams.length > 0){
      _selectedTeam = _tempController.getSelectedTeam();
      _games = _persistentController.getAllGames(teamId: _selectedTeam.id);
    // if there are no teams ofc there are no players and no games
    } else {
      _games = [];
    }
    
    _statistics = _persistentController.getStatistics();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
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
                      Flexible(
                          flex: 1,
                          child: Column(
                            children: [
                              GameSelector(games: _games, onGameSelected: onGameSelected),
                              Container(
                                height: 20,
                              ),
                              TeamSelector(teams: _teams, onTeamSelected: onTeamSelected)
                            ],
                          )),
                      Flexible(
                        flex: 2,
                        child: QuotaCard(
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
                            actionSeries: actionSeries,
                            efScoreSeries: efScoreSeries,
                            allActionTimeStamps: timeStamps,
                            startTime: startTime,
                            stopTime: stopTime),
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
                  child: PenaltyInfoCard(
                    redCards: actionCounts[redCard] == null ? 0 : actionCounts[redCard]!,
                    yellowCards: actionCounts[yellowCard] == null ? 0 : actionCounts[yellowCard]!,
                    timePenalties: actionCounts[timePenalty] == null ? 0 : actionCounts[timePenalty]!,
                  ),
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
