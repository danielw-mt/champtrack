import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/core/bloc/global_bloc.dart';
import 'package:handball_performance_tracker/features/game/bloc/game_bloc.dart';
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

  GamePage(
      {super.key, onFieldPlayers, selectedTeam, this.opponent = "", this.location = "", date, this.isHomeGame = true, this.attackIsLeft = true}) {
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
    Game game = Game(date: date, opponent: opponent, location: location, isAtHome: isHomeGame, attackIsLeft: attackIsLeft, onFieldPlayers: onFieldPlayers, selectedTeam: selectedTeam);
    return BlocProvider(
      create: (_) => GameBloc().add(CreateGame(game: game)),
      child: GameView(),
    );
  }
}
