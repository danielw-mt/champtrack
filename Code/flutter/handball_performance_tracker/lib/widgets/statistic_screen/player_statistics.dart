import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/constants/game_actions.dart';
import 'package:handball_performance_tracker/controllers/persistent_controller.dart';
import 'package:handball_performance_tracker/controllers/temp_controller.dart';
import 'statistic_card_elements.dart';
import '../../data/player.dart';
import '../../data/game.dart';
import '../../controllers/temp_controller.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

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
  Player _selectedPlayer = Player();
  Game _selectedGame = Game(date: DateTime.fromMicrosecondsSinceEpoch(0));
  List<Game> _games = [];
  Map<String, dynamic> _statistics = {};

  @override
  void initState() {
    _players = _tempController.getPlayersFromSelectedTeam();
    _selectedPlayer = _players[0];
    _games = _persistentController.getAllGames();
    _selectedGame = _games[0];
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
      // try to get action counts for the player
      actionCounts = _statistics[_selectedGame.id]["player_stats"]
          [_selectedPlayer.id]["action_counts"];
      // try to get action_series for player
      actionSeries = _statistics[_selectedGame.id]["player_stats"]
          [_selectedPlayer.id]["action_series"];

      // try to get ef-score series for player
      efScoreSeries = _statistics[_selectedGame.id]["player_stats"]
          [_selectedPlayer.id]["ef_score_series"];
      // try to get all action timestamps for player
      timeStamps = _statistics[_selectedGame.id]["player_stats"]
          [_selectedPlayer.id]["all_action_timestamps"];
      // try to get start time for game
      startTime = _statistics[_selectedGame.id]["start_time"];
      stopTime = _statistics[_selectedGame.id]["stop_time"];

      // try to get quotas for player
      quotas[0][0] = double.parse(_statistics[_selectedGame.id]["player_stats"]
              [_selectedPlayer.id]["seven_meter_quota"][0]
          .toString());
      quotas[0][1] = double.parse(_statistics[_selectedGame.id]["player_stats"]
              [_selectedPlayer.id]["seven_meter_quota"][1]
          .toString());
      quotas[1][0] = double.parse(_statistics[_selectedGame.id]["player_stats"]
              [_selectedPlayer.id]["position_quota"][0]
          .toString());
      quotas[1][1] = double.parse(_statistics[_selectedGame.id]["player_stats"]
              [_selectedPlayer.id]["position_quota"][1]
          .toString());
      quotas[2][0] = double.parse(_statistics[_selectedGame.id]["player_stats"]
              [_selectedPlayer.id]["throw_quota"][0]
          .toString());
      quotas[2][1] = double.parse(_statistics[_selectedGame.id]["player_stats"]
              [_selectedPlayer.id]["throw_quota"][1]
          .toString());
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
                              buildPlayerSelectionCard(),
                              Container(
                                height: 20,
                              ),
                              buildGameSelectionCard(),
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
                    redCards: actionCounts[redCard] == null
                        ? 0
                        : actionCounts[redCard]!,
                    yellowCards: actionCounts[yellowCard] == null
                        ? 0
                        : actionCounts[yellowCard]!,
                    timePenalties: actionCounts[timePenalty] == null
                        ? 0
                        : actionCounts[timePenalty]!,
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

  Card buildPlayerSelectionCard() {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: DropdownButton<Player>(
              value: _selectedPlayer,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (Player? newPlayer) {
                // This is called when the user selects an item.
                setState(() {
                  _selectedPlayer = newPlayer!;
                });
              },
              items: _players.map<DropdownMenuItem<Player>>((Player player) {
                return DropdownMenuItem<Player>(
                  value: player,
                  child: Text(player.firstName + " " + player.lastName),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }

  Card buildGameSelectionCard() {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: DropdownButton<Game>(
              value: _selectedGame,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (Game? newGame) {
                // This is called when the user selects an item.
                setState(() {
                  _selectedGame = newGame!;
                });
              },
              items: _games.map<DropdownMenuItem<Game>>((Game game) {
                return DropdownMenuItem<Game>(
                  value: game,
                  child: Text(game.date.toString()),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
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

