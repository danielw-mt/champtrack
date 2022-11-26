import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/features/game/game.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'player_button.dart';
import 'package:handball_performance_tracker/data/models/models.dart';

class PlayersGrid extends StatelessWidget {
  List<Player> players;
  PlayersGrid({super.key, required this.players});

  @override
  Widget build(BuildContext context) {
    final GameBloc gameBloc = context.read<GameBloc>();
    return GridView.count(
      // 4 items max per row
      crossAxisCount: 4,
      padding: const EdgeInsets.all(20),
      children: gameBloc.state.onFieldPlayers.map((Player player) => PlayerButton(player: player)).toList(),
    );
  }
}
