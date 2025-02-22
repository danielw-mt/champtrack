import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/data/repositories/repositories.dart';
import 'package:handball_performance_tracker/features/game/game.dart';
import 'package:handball_performance_tracker/data/models/models.dart';

class GamePage extends StatelessWidget {
  List<Player> onFieldPlayers = [];
  Team selectedTeam = Team();
  String opponent = "";
  String location = "";
  DateTime date = DateTime.now();
  bool isHomeGame = true;
  bool attackIsLeft = true;
  bool isTestGame = false;

  GamePage(
      {super.key,
      onFieldPlayers,
      selectedTeam,
      this.opponent = "",
      this.location = "",
      date,
      this.isHomeGame = true,
      this.attackIsLeft = true,
      this.isTestGame = false}) {
    if (onFieldPlayers != null && onFieldPlayers.length > 0) {
      this.onFieldPlayers = onFieldPlayers;
    }
    if (selectedTeam != null) {
      this.selectedTeam = selectedTeam;
    }
    if (date != null) {
      this.date = date;
    }
  }

  @override
  Widget build(BuildContext context) {
    GameBloc gameBloc = BlocProvider.of<GameBloc>(context);
    gameBloc
      ..add(InitializeGame(
          onFieldPlayers: onFieldPlayers,
          selectedTeam: selectedTeam,
          opponent: opponent,
          location: location,
          date: date,
          isHomeGame: isHomeGame,
          attackIsLeft: attackIsLeft,
          isTestGame: isTestGame));
    return BlocProvider.value(value: BlocProvider.of<GameBloc>(context), child: GameView());
  }
}
