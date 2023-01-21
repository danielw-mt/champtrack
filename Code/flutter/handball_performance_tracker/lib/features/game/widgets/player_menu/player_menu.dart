import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/core/core.dart';
import 'package:handball_performance_tracker/features/game/game.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/data/models/models.dart';
import 'player_button.dart';
import 'expand_menu_button.dart';

// all of these styles are two page menus with onfieldplayers on the first page and offfieldplayers on the second page
// in the assist style the goal scoring player is highlighted
// in all styles the hinttext of the menu differs
enum PlayerMenuStyle { standard, assist, sevenMeterScorer, sevenMeterExecutor, sevenMeterFouler, substitutionTarget, goalKeeperSelection }

class PlayerMenu extends StatelessWidget {
  PlayerMenuStyle style;
  PlayerMenu({super.key, required this.style});
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final gameBloc = context.read<GameBloc>();
    List<Player> availableOnFieldPlayers = gameBloc.state.onFieldPlayers;
    List<Player> availablePlayers = gameBloc.state.selectedTeam.players;
    if (style == PlayerMenuStyle.goalKeeperSelection) {
      availableOnFieldPlayers = gameBloc.state.onFieldPlayers.where((Player player) => player.positions.contains("TW")).toList();
      availablePlayers = gameBloc.state.selectedTeam.players.where((Player player) => player.positions.contains("TW")).toList();
    }
    List<Widget> _buildPanel() {
      if (style == PlayerMenuStyle.substitutionTarget) {
        print("substitution target menu");
        return [
          GridView.count(
              // 4 items max per row
              crossAxisCount: 4,
              padding: const EdgeInsets.all(20),
              children: availableOnFieldPlayers
                  .map((Player player) => PlayerButton(
                        player: player,
                        isSubstitution: true,
                      ))
                  .toList())
        ];
      }
      return [
        GridView.count(
            // 4 items max per row
            crossAxisCount: 4,
            padding: const EdgeInsets.all(20),
            children: availableOnFieldPlayers
                .map<Widget>((Player player) => PlayerButton(
                      player: player,
                      isSubstitution: false,
                    ))
                .toList()
              ..add(ExpandMenuButton(
                pageController: pageController,
              ))),
        GridView.count(
            // 4 items max per row
            crossAxisCount: 4,
            padding: const EdgeInsets.all(20),
            children: availablePlayers
                .where((Player player) => !gameBloc.state.selectedTeam.onFieldPlayers.contains(player))
                .toList()
                .map((Player player) => PlayerButton(
                      player: player,
                      isSubstitution: true,
                    ))
                .toList())
      ];
    }

    return // Column of "Player", horizontal line and Button-Row
        Column(children: [
      // upper row: "Player" Text on left and "Assist" will pop up on right after a goal.
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Align(
            alignment: Alignment.topLeft,
            child: Text(
              StringsGeneral.lPlayer,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            // Change from "" to "Assist" after a goal.
            child: Text(
              _getHelpText(),
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.purple,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
      // horizontal line
      const Divider(
        thickness: 2,
        color: Colors.black,
        height: 6,
      ),

      // Button-Row: one Row with four Columns of one or two buttons
      SizedBox(
        height: 0.5 * MediaQuery.of(context).size.height,
        width: 0.6 * MediaQuery.of(context).size.width,
        child: Scrollbar(
          controller: pageController,
          thumbVisibility: true,
          child: PageView(
            controller: pageController,
            children: _buildPanel(),
          ),
        ),
      )
    ]);
  }

  String _getHelpText() {
    switch (style) {
      case PlayerMenuStyle.standard:
        return 'Select player who performed the action';
      case PlayerMenuStyle.assist:
        return 'Select the player who assisted';
      case PlayerMenuStyle.sevenMeterScorer:
        return 'Select the player who scored 7m';
      case PlayerMenuStyle.sevenMeterExecutor:
        return 'Select the player who executed 7m';
      case PlayerMenuStyle.sevenMeterFouler:
        return 'Select the player who fouled';
      case PlayerMenuStyle.substitutionTarget:
        return 'Select the player who is being substituted';
      case PlayerMenuStyle.goalKeeperSelection:
        return 'Select the goal keeper';
    }
  }
}
