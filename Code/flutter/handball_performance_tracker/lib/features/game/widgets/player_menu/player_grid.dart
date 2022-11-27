import 'package:flutter/material.dart';
import 'player_button.dart';
import 'package:handball_performance_tracker/data/models/models.dart';

class PlayersGrid extends StatelessWidget {
  List<Player> players;
  bool isSubstitution;
  PlayersGrid({super.key, required this.players, required this.isSubstitution});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      // 4 items max per row
      crossAxisCount: 4,
      padding: const EdgeInsets.all(20),
      children: players
          .map((Player player) => PlayerButton(
                player: player,
                isSubstitution: isSubstitution,
              ))
          .toList(),
    );
  }
}
