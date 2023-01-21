import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/features/statistics/statistics.dart';
import 'package:handball_performance_tracker/features/game/game.dart';
import 'package:handball_performance_tracker/data/models/models.dart';

class SidebarStatisticsButton extends StatelessWidget {
  final String text;
  const SidebarStatisticsButton({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(" " * 2 + text, style: TextStyle(fontSize: 20)),
      textColor: Colors.white,
      onTap: () {
        StatisticsBloc statisticsBloc =
            BlocProvider.of<StatisticsBloc>(context);
        GameBloc gameBloc = BlocProvider.of<GameBloc>(context);
        if (gameBloc.state.stopWatchTimer.rawTime.value > 0) {
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
          gameBloc.add(PauseGame());
          statisticsBloc.add(AddCurrentGameStatistics(game: currentGame));
        }
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => StatisticsView()));
      },
    );
  }
}
