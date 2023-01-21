import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/core/core.dart';
import 'action_button.dart';

class GoalKeeperLayout extends StatelessWidget {
  const GoalKeeperLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ActionButton(
                  actionTag: yellowCardTag,
                  actionContext: actionContextGoalkeeper,
                  buttonText: StringsGameScreen.lYellowCard,
                  buttonColor: Colors.yellow,
                  sizeFactor: 0,
                  icon: Icon(Icons.style)),
              ActionButton(
                  actionTag: redCardTag,
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
                actionTag: timePenaltyTag,
                actionContext: actionContextGoalkeeper,
                buttonText: StringsGameScreen.lTimePenalty,
                buttonColor: Color.fromRGBO(199, 208, 244, 1),
                sizeFactor: 2,
                icon: Icon(Icons.timer))),
        Flexible(
          child: ActionButton(
            actionTag: emptyGoalTag,
            actionContext: actionContextGoalkeeper,
            buttonText: StringsGameScreen.lEmptyGoal,
            buttonColor: Color.fromRGBO(199, 208, 244, 1),
            sizeFactor: 2,
          ),
        ),
        Flexible(
            child: ActionButton(
          actionTag: missTag,
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
            actionTag: goalGoalKeeperTag,
            actionContext: actionContextGoalkeeper,
            buttonText: StringsGameScreen.lGoalGoalkeeper,
            buttonColor: Color.fromRGBO(99, 107, 171, 1),
          )),
          Flexible(
              child: ActionButton(
            actionTag: badPassTag,
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
              actionTag: paradeTag,
              actionContext: actionContextGoalkeeper,
              buttonText: StringsGameScreen.lParade,
              buttonColor: Color.fromRGBO(99, 107, 171, 1),
            )),
            Flexible(
                child: ActionButton(
              actionTag: goalOpponentTag,
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
