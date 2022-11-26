import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/core/constants/strings_game_screen.dart';
import 'package:handball_performance_tracker/core/constants/game_actions.dart';
import 'action_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/features/game/game.dart';
import 'goal_keeper_buttons.dart';
import 'defense_buttons.dart';
import 'attack_buttons.dart';

/// A menu of differently arranged buttons depending on whether we are in action, defense or goal keeper mode
class ActionPanel extends StatelessWidget {
  final String actionContext;
  ActionPanel({super.key, required this.actionContext});
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scrollbar(thumbVisibility: true, controller: pageController, child: PageView(controller: pageController, children: buildPages()));
  }

  // a method for building the children of the pageview in the right order
  // by arranging either the attack menu or defense menu first or the goal keeper menu
  List<Widget> buildPages() {
    if (actionContext == actionContextGoalkeeper) {
      return [GoalKeeperButtons()];
    } else if (actionContext == actionContextAttack) {
      return [
        AttackButtons(),
        DefenseButtons(),
      ];
    } else if (actionContext == actionContextDefense) {
      return [
        DefenseButtons(),
        AttackButtons(),
      ];
    } else {
      print("no page view children");
      return [Text("Could not build menu that is matching the phase of the game")];
    }
  }
}
