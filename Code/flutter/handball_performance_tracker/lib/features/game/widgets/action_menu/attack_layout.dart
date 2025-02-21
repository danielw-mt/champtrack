import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/core/core.dart';
import 'action_button.dart';

class AttackLayout extends StatelessWidget {
  const AttackLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          ActionButton(
              actionTag: yellowCardTag,
              actionContext: actionContextAttack,
              buttonText: StringsGameScreen.lYellowCard,
              buttonColor: Colors.yellow,
              sizeFactor: 0,
              icon: Icon(Icons.style)),
          ActionButton(
              actionTag: redCardTag,
              actionContext: actionContextAttack,
              buttonText: StringsGameScreen.lRedCard,
              buttonColor: Colors.red,
              sizeFactor: 0,
              icon: Icon(Icons.style))
        ]),
        Flexible(
            child: ActionButton(
          actionTag: forceTwoMinTag,
          actionContext: actionContextAttack,
          buttonText: StringsGameScreen.lForceTwoMin,
          buttonColor: Color.fromRGBO(199, 208, 244, 1),
          sizeFactor: 1,
        )),
        Flexible(
            child: ActionButton(
          actionTag: timePenaltyTag,
          actionContext: actionContextAttack,
          buttonText: StringsGameScreen.lTimePenalty,
          buttonColor: Color.fromRGBO(199, 208, 244, 1),
          sizeFactor: 1,
        )),
      ]),
      Flexible(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
                child: ActionButton(
              actionTag: missTag,
              actionContext: actionContextAttack,
              buttonText: StringsGameScreen.lMiss,
              buttonColor: Color.fromRGBO(203, 206, 227, 1),
            )),
            Flexible(
                child: ActionButton(
              actionTag: trfTag,
              actionContext: actionContextAttack,
              buttonText: StringsGameScreen.lTrf,
              buttonColor: Color.fromRGBO(203, 206, 227, 1),
            ))
          ],
        ),
      ),
      Flexible(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
                child: ActionButton(
              actionTag: goalTag,
              actionContext: actionContextAttack,
              buttonText: StringsGameScreen.lGoal,
              buttonColor: Color.fromRGBO(99, 107, 171, 1),
            )),
            Flexible(
                child: ActionButton(
              actionTag: oneVOneSevenTag,
              actionContext: actionContextAttack,
              buttonText: StringsGameScreen.lOneVsOneAnd7m,
              buttonColor: Color.fromRGBO(99, 107, 171, 1),
            ))
          ],
        ),
      ),
    ]);
  }
}
