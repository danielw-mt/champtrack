import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/core/core.dart';
import 'goal_keeper_layout.dart';
import 'defense_layout.dart';
import 'attack_layout.dart';
import 'seven_meter_defense_layout.dart';
import 'seven_meter_offense_layout.dart';
import 'seven_meter_prompt_layout.dart';

enum ActionMenuStyle { offense, defense, goalkeeper, sevenMeterPrompt, sevenMeterOffense, sevenMeterDefense }

/// A menu of differently arranged buttons depending on whether we are in action, defense or goal keeper mode
class ActionMenu extends StatelessWidget {
  final ActionMenuStyle style;
  ActionMenu({super.key, required this.style});
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
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
        child: PageView(
          controller: pageController,
          children: _buildPanel(),
        ),
      )
    ]);
  }

  String _getHelpText() {
    switch (style) {
      case ActionMenuStyle.offense:
        return "Select offensive action";
      case ActionMenuStyle.defense:
        return "Select defensive action";
      case ActionMenuStyle.goalkeeper:
        return "Select goal keeper action";
      case ActionMenuStyle.sevenMeterPrompt:
        return "Did a 7m take place?";
      case ActionMenuStyle.sevenMeterOffense:
        return "Select offensive seven meter action";
      case ActionMenuStyle.sevenMeterDefense:
        return "Select defensive seven meter action";
    }
  }

  // a method for building the children of the pageview in the right order
  // by arranging either the attack menu or defense menu first or the goal keeper menu
  List<Widget> _buildPanel() {
    switch (style) {
      case ActionMenuStyle.goalkeeper:
        return [GoalKeeperLayout()];
      case ActionMenuStyle.offense:
        return [
          AttackLayout(),
          DefenseLayout(),
        ];
      case ActionMenuStyle.defense:
        return [
          DefenseLayout(),
          AttackLayout(),
        ];
      case ActionMenuStyle.sevenMeterPrompt:
        return [SevenMeterPromptLayout()];
      case ActionMenuStyle.sevenMeterOffense:
        return [SevenMeterOffenseLayout()];
      case ActionMenuStyle.sevenMeterDefense:
        return [SevenMeterDefenseLayout()];
    }
  }
}
