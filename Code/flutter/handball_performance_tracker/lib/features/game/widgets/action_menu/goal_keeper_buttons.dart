import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/core/constants/strings_game_screen.dart';
import 'package:handball_performance_tracker/core/constants/game_actions.dart';
import 'action_button.dart';

class GoalKeeperButtons extends StatelessWidget {
  const GoalKeeperButtons({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, String> goalKeeperActionMapping = actionMapping[actionContextGoalkeeper]!;
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ActionButton(
                  actionTag: goalKeeperActionMapping[StringsGameScreen.lYellowCard]!,
                  actionContext: actionContextGoalkeeper,
                  buttonText: StringsGameScreen.lYellowCard,
                  buttonColor: Colors.yellow,
                  sizeFactor: 0,
                  icon: Icon(Icons.style)),
              ActionButton(
                  actionTag: goalKeeperActionMapping[StringsGameScreen.lRedCard]!,
                  actionContext: actionContextGoalkeeper,
                  buttonText: StringsGameScreen.lRedCard,
                  buttonColor: Colors.red,
                  sizeFactor: 0,
                  icon: Icon(Icons.style))
            ],
          ),
        ),
        Flexible(
            child: ActionButton(
                actionTag: goalKeeperActionMapping[StringsGameScreen.lTimePenalty]!,
                actionContext: actionContextGoalkeeper,
                buttonText: StringsGameScreen.lTimePenalty,
                buttonColor: Color.fromRGBO(199, 208, 244, 1),
                sizeFactor: 2,
                icon: Icon(Icons.timer))),
        Flexible(
          child: ActionButton(
            actionTag: goalKeeperActionMapping[StringsGameScreen.lEmptyGoal]!,
            actionContext: actionContextGoalkeeper,
            buttonText: StringsGameScreen.lEmptyGoal,
            buttonColor: Color.fromRGBO(199, 208, 244, 1),
            sizeFactor: 2,
          ),
        ),
        Flexible(
            child: ActionButton(
          actionTag: goalKeeperActionMapping[StringsGameScreen.lErrThrowGoalkeeper]!,
          actionContext: actionContextGoalkeeper,
          buttonText: StringsGameScreen.lErrThrowGoalkeeper,
          buttonColor: Color.fromRGBO(199, 208, 244, 1),
          sizeFactor: 2,
        )),
      ]),
      Flexible(
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Flexible(
              child: ActionButton(
            actionTag: goalKeeperActionMapping[StringsGameScreen.lGoalGoalkeeper]!,
            actionContext: actionContextGoalkeeper,
            buttonText: StringsGameScreen.lGoalGoalkeeper,
            buttonColor: Color.fromRGBO(99, 107, 171, 1),
          )),
          Flexible(
              child: ActionButton(
            actionTag: goalKeeperActionMapping[StringsGameScreen.lBadPass]!,
            actionContext: actionContextGoalkeeper,
            buttonText: StringsGameScreen.lBadPass,
            buttonColor: Color.fromRGBO(203, 206, 227, 1),
          )),
        ]),
      ),
      Flexible(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
                child: ActionButton(
              actionTag: goalKeeperActionMapping[StringsGameScreen.lParade]!,
              actionContext: actionContextGoalkeeper,
              buttonText: StringsGameScreen.lParade,
              buttonColor: Color.fromRGBO(99, 107, 171, 1),
            )),
            Flexible(
                child: ActionButton(
              actionTag: goalKeeperActionMapping[StringsGameScreen.lGoalOpponent]!,
              actionContext: actionContextGoalkeeper,
              buttonText: StringsGameScreen.lGoalOpponent,
              buttonColor: Color.fromRGBO(203, 206, 227, 1),
            )),
          ],
        ),
      ),
    ]);
  }
}
