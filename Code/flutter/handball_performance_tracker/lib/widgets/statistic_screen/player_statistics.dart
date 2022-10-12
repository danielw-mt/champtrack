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

var logger = Logger(
  printer: PrettyPrinter(
      methodCount: 2, // number of method calls to be displayed
      errorMethodCount: 8, // number of method calls if stacktrace is provided
      lineLength: 120, // width of the output
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
      printTime: true // Should each log print contain a timestamp
      ),
);

class PlayerStatistics extends StatefulWidget {
  const PlayerStatistics({Key? key}) : super(key: key);

  @override
  State<PlayerStatistics> createState() => _PlayerStatisticsState();
}

class _PlayerStatisticsState extends State<PlayerStatistics> {
  TempController _tempController = Get.put(TempController());
  PersistentController _persistentController = Get.put(PersistentController());
  List<Player> _players = [];
  List<Game> _games = [];
  List<Team> _teams = [];
  Map<String, dynamic> _statistics = {};
  Team _selectedTeam = Team();
  Player _selectedPlayer = Player();
  Game _selectedGame = Game(date: DateTime.fromMicrosecondsSinceEpoch(0));
  @override
  void initState() {
    _players = _tempController.getPlayersFromSelectedTeam();
    
    _teams = _persistentController.getAvailableTeams();
    // if's are for index safety
    if (_players.length > 0){
       _selectedPlayer = _players[0];
    // if there are no players don't display any games
    } else {
      _games = [];
    }
    if (_games.length > 0){
      _selectedGame = _games[0];
    }
    if (_teams.length > 0){
      _selectedTeam = _tempController.getSelectedTeam();
      _games = _persistentController.getAllGames(teamId: _selectedTeam.id);
    // if there are no teams ofc there are no players and no games
    } else {
      _players = [];
      _games = [];
    }
    
    _statistics = _persistentController.getStatistics();
    super.initState();
  }

  void onPlayerSelected(Player player) {
    setState(() {
      _selectedPlayer = player;
    });
  }

  void onGameSelected(Game game) {
    setState(() {
      _selectedGame = game;
    });
  }

  void onTeamSelected(Team team) {
    setState(() {
      _selectedTeam = team;
      _games = _persistentController.getAllGames(teamId: _selectedTeam.id);
      _players = _persistentController.getAllPlayers(teamId: _selectedTeam.id);
      logger.d("players: $_players");
      if (_players.length > 0){
      _selectedPlayer = _players[0];
      }
      if (_games.length > 0){
        _selectedGame = _games[0];
      }
    });
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
      Map<String, dynamic> playerStats = _statistics[_selectedGame.id]["player_stats"][_selectedPlayer.id];
      // try to get action counts for the player
      actionCounts = playerStats["action_counts"];
      // try to get action_series for player
      actionSeries = playerStats["action_series"];

      // try to get ef-score series for player
      efScoreSeries = playerStats["ef_score_series"];
      // try to get all action timestamps for player
      timeStamps = playerStats["all_action_timestamps"];
      // try to get start time for game
      startTime = _statistics[_selectedGame.id]["start_time"];
      stopTime = _statistics[_selectedGame.id]["stop_time"];

      // try to get quotas for player
      quotas[0][0] = double.parse(playerStats["seven_meter_quota"][0].toString());
      quotas[0][1] = double.parse(playerStats["seven_meter_quota"][1].toString());
      quotas[1][0] = double.parse(playerStats["position_quota"][0].toString());
      quotas[1][1] = double.parse(playerStats["position_quota"][1].toString());
      quotas[2][0] = double.parse(playerStats["throw_quota"][0].toString());
      quotas[2][1] = double.parse(playerStats["throw_quota"][1].toString());
    } on Exception catch (e) {
      logger.e(e);
    } catch (e) {
      logger.e(e);
    }
    logger.d(efScoreSeries);
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
                              PlayerSelector(players: _players, onPlayerSelected: onPlayerSelected),
                              Container(
                                height: 20,
                              ),
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



/*class QuotesCard extends StatefulWidget {
  const QuotesCard({Key? key}) : super(key: key);
  @override
  _QuotesCardState createState() => _QuotesCardState();
}

class _QuotesCardState extends State<QuotesCard> {
  @override
  Widget build(BuildContext context) {
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
                  child: PieChartQuotesWidget(),
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
                  child: PieChartQuotesWidget(),
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
                  child: PieChartQuotesWidget(),
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
}
*/

