import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/features/game/game.dart';
import 'package:handball_performance_tracker/features/dashboard/dashboard.dart';
import 'package:handball_performance_tracker/features/statistics/statistics.dart';
import 'package:handball_performance_tracker/data/models/models.dart';

class FinishGameButton extends StatelessWidget {
  const FinishGameButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GameBloc gameBloc = context.watch<GameBloc>();
    final GlobalBloc globalBloc = context.watch<GlobalBloc>();
    final StatisticsBloc statisticsBloc = context.watch<StatisticsBloc>();

    return Container(
      margin: EdgeInsets.only(right: 3),
      child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: buttonDarkBlueColor,
            primary: Colors.black,
          ),
          onPressed: () {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text(StringsGameScreen.lStopGame),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, StringsGameSettings.lCancelButton),
                    child: Text(
                      StringsGameSettings.lCancelButton,
                      style: TextStyle(
                        color: buttonDarkBlueColor,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      gameBloc.add(FinishGame());
                      if (gameBloc.state.stopWatchTimer.rawTime.value > 0) {
                        List<String> onFieldPlayerIds = gameBloc.state.onFieldPlayers.map((Player player) => player.id.toString()).toList();
                        Game currentGame = Game(
                          id: gameBloc.state.documentReference!.id,
                          path: gameBloc.state.documentReference!.path,
                          teamId: gameBloc.state.selectedTeam.id,
                          date: gameBloc.state.date,
                          startTime: gameBloc.state.date!.millisecondsSinceEpoch,
                          stopTime: DateTime.now().millisecondsSinceEpoch,
                          scoreHome: gameBloc.state.ownScore,
                          scoreOpponent: gameBloc.state.opponentScore,
                          isAtHome: gameBloc.state.isHomeGame,
                          location: gameBloc.state.location,
                          opponent: gameBloc.state.opponent,
                          // TODO add season here and season to gameBloc.state
                          lastSync: DateTime.now().millisecondsSinceEpoch.toString(),
                          onFieldPlayers: onFieldPlayerIds,
                          attackIsLeft: gameBloc.state.attackIsLeft,
                          stopWatchTimer: gameBloc.state.stopWatchTimer,
                          gameActions: gameBloc.state.gameActions,
                        );
                        gameBloc.add(PauseGame());
                        statisticsBloc.add(AddCurrentGameStatistics(game: currentGame));
                      }
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => StatisticsView()));

                      gameBloc.add(ResetGame());
                      globalBloc.add(ResetPlayerScores());
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(
                        color: buttonDarkBlueColor,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          child: Row(
            children: [
              Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              Text(
                StringsGameScreen.lStopGame,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          )),
    );
  }
}
