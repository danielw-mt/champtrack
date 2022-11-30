import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/core/constants/game_actions.dart';
import 'package:handball_performance_tracker/oldcontrollers/persistent_controller.dart';
import 'package:handball_performance_tracker/oldcontrollers/temp_controller.dart';
import 'statistic_card_elements.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:handball_performance_tracker/core/constants/game_actions.dart';
import 'package:handball_performance_tracker/features/statistics/statistics.dart';
import 'package:handball_performance_tracker/core/constants/game_actions.dart';
// import 'package:handball_performance_tracker/oldcontrollers/persistent_controller.dart';
// import 'package:handball_performance_tracker/oldcontrollers/temp_controller.dart';
// import 'statistic_card_elements.dart';
import 'package:handball_performance_tracker/data/models/player_model.dart';
import 'package:handball_performance_tracker/data/models/game_model.dart';
import 'package:handball_performance_tracker/data/models/team_model.dart';
// import '../../data/models/player_model.dart';
// import '../../data/models/game_model.dart';
// import '../../data/models/team_model.dart';
// import '../../oldcontrollers/temp_controller.dart';
// import 'package:get/get.dart';
// import 'package:logger/logger.dart';
// import 'statistic_dropdowns.dart';
// import '../../core/constants/game_actions.dart';

// var logger = Logger(
//   printer: PrettyPrinter(
//       methodCount: 2, // number of method calls to be displayed
//       errorMethodCount: 8, // number of method calls if stacktrace is provided
//       lineLength: 120, // width of the output
//       colors: true, // Colorful log messages
//       printEmojis: true, // Print an emoji for each log message
//       printTime: true // Should each log print contain a timestamp
//       ),
// );

class PlayerStatistics extends StatefulWidget {
  const PlayerStatistics({Key? key}) : super(key: key);

  @override
  State<PlayerStatistics> createState() => _PlayerStatisticsState();
}

class _PlayerStatisticsState extends State<PlayerStatistics> {
  //PersistentController _persistentController = Get.put(PersistentController());
  List<Player> _players = [];
  List<Game> _games = [];
  List<Team> _teams = [];
  Map<String, dynamic> _statistics = {};
  Team _selectedTeam = Team(players: [], onFieldPlayers: []);
  Player _selectedPlayer = Player();
  Game _selectedGame = Game(date: DateTime.fromMicrosecondsSinceEpoch(0));

  @override
  void initState() {
    _teams = []; // _persistentController.getAvailableTeams();
    _statistics = {}; // _persistentController.getStatistics();
    if (_teams.length != 0) {
      _selectedTeam = _teams[0];
      _games = getGamesInStatistics();
      _players = []; //_persistentController.getAllPlayers(teamId: _selectedTeam.id);
      // if there are no teams ofc there are no players and no games
    } else {
      _games = [];
      _players = [];
    }
    if (_games.length != 0) {
      _selectedGame = _games[0];
      // if there are no games don't show the player menu
    } 
    // else {
    //   _players = [];
    // }
    if (_players.length != 0) {
      _selectedPlayer = _players[0];
      // if there are no players also don't display any games
    } 
    // else {
    //   _games = [];
    // }
    super.initState();
  }

  /// provide the games that are cached in persistentcontroller that match the selected team and that also match games in the statistics map
  List<Game> getGamesInStatistics() {
    List<Game> allGames = []; // _persistentController.getAllGames(teamId: _selectedTeam.id);
    List<Game> matchingGames = allGames.where((Game game) => _statistics.containsKey(game.id)).toList();
    return matchingGames;
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
      _games = getGamesInStatistics();
      // if there are no games do not display the player dropdown
      if (_games.length != 0) {
        _selectedGame = _games[0];
        _players = []; //_persistentController.getAllPlayers(teamId: _selectedTeam.id);
        logger.d(_players);
      } 
      // else {
      //   _players = [];
      // }
      if (_players.length > 0) {
        _selectedPlayer = _players[0];
      }
    });
  }

  // TODO implement this function
  /// get all players from selected team that player in the selected game
  // _updatePlayersOfGame() {
  //   // if no game has been selected yet i.e. there is no game available for the previous team
  //   if (_selectedGame.id == null) {
  //     _selectedGame = _games[0];
  //   }
  //   List<Player> allPlayersInTeam =
  //       _persistentController.getAllPlayers(teamId: _selectedTeam.id);
  //   Map<String, dynamic> gameStats = _statistics[_selectedGame.id];
  //   logger.d("gameStats: $gameStats");
  //   Map<String, dynamic> playerStats = gameStats["player_stats"];
  //   List<String> playerIDsOfGame = playerStats.keys.toList();
  //   logger.d("all player ids");
  //   allPlayersInTeam.forEach((player) {
  //     logger.d(player.id);
  //   });
  //   logger.d("all player id s in game");
  //   playerIDsOfGame.forEach((playerID) {
  //     logger.d(playerID);
  //   });
  //   List<Player> playersInGame = allPlayersInTeam
  //       .where((Player player) => playerIDsOfGame.contains(player.id))
  //       .toList();
  //   _players = playersInGame;
  // }

  @override
  Widget build(BuildContext context) {
    if (_selectedTeam == Team(players: [], onFieldPlayers: []) && _teams.isNotEmpty) {
      _selectedTeam = _teams[0];
      _games = getGamesInStatistics();
      _players = [];// _persistentController.getAllPlayers(teamId: _selectedTeam.id);
    }



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
                      Expanded(
                          flex: 1,
                          child: Card(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TeamSelector(teams: _teams, onTeamSelected: onTeamSelected),
                              GameSelector(games: _games, onGameSelected: onGameSelected),
                              PlayerSelector(players: _players, onPlayerSelected: onPlayerSelected)
                            ],
                          ))),
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

