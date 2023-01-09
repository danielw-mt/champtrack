import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/features/statistics/statistics.dart';
import 'package:handball_performance_tracker/features/game/game.dart';
import 'package:handball_performance_tracker/data/models/models.dart';

// Button which takes you back to the game
class StatisticsButton extends StatelessWidget {
  const StatisticsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // Back to Game Button
    return Container(
      decoration: BoxDecoration(
          color: buttonDarkBlueColor,
          // set border so corners can be made round
          border: Border.all(
            color: buttonDarkBlueColor,
          ),
          // make round edges
          borderRadius: BorderRadius.all(Radius.circular(MENU_RADIUS))),
      margin: EdgeInsets.only(left: 20, right: 20, top: 100),
      padding: EdgeInsets.all(10),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: buttonGreyColor,
          padding: EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(MENU_RADIUS),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sports_handball, color: buttonDarkBlueColor, size: 50),
            Expanded(
              child: Text(
                StringsGeneral.lStatistics,
                style: TextStyle(color: buttonDarkBlueColor, fontSize: 18),
              ),
            )
          ],
        ),
        onPressed: () {
          Navigator.pop(context);
          StatisticsBloc statisticsBloc = BlocProvider.of<StatisticsBloc>(context);
          GameBloc gameBloc = BlocProvider.of<GameBloc>(context);

          List<String> onFieldPlayerIds = gameBloc.state.onFieldPlayers
              .map((Player player) => player.id.toString())
              .toList();
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
          statisticsBloc.add(AddCurrentGameStatistics(game: currentGame));
        },
      ),
    );
  }
}