import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/core/constants/strings_game_screen.dart';
import 'package:handball_performance_tracker/core/constants/game_actions.dart';
import 'action_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/features/game/game.dart';
import 'goal_keeper_buttons.dart';
import 'defense_buttons.dart';
import 'attack_buttons.dart';

class AttackButtons extends StatelessWidget {
  const AttackButtons({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, String> attackActionMapping = actionMapping[actionContextAttack]!;
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          ActionButton(
              actionTag: attackActionMapping[StringsGameScreen.lYellowCard]!,
              actionContext: actionContextAttack,
              buttonText: StringsGameScreen.lYellowCard,
              buttonColor: Colors.yellow,
              sizeFactor: 0,
              icon: Icon(Icons.style)),
          ActionButton(
              actionTag: attackActionMapping[StringsGameScreen.lRedCard]!,
              actionContext: actionContextAttack,
              buttonText: StringsGameScreen.lRedCard,
              buttonColor: Colors.red,
              sizeFactor: 0,
              icon: Icon(Icons.style))
        ]),
        Flexible(
            child: ActionButton(
          actionTag: attackActionMapping[StringsGameScreen.lTwoMin]!,
          actionContext: actionContextAttack,
          buttonText: StringsGameScreen.lTwoMin,
          buttonColor: Color.fromRGBO(199, 208, 244, 1),
          sizeFactor: 1,
        )),
        Flexible(
            child: ActionButton(
          actionTag: attackActionMapping[StringsGameScreen.lTimePenalty]!,
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
              actionTag: attackActionMapping[StringsGameScreen.lErrThrow]!,
              actionContext: actionContextAttack,
              buttonText: StringsGameScreen.lErrThrow,
              buttonColor: Color.fromRGBO(203, 206, 227, 1),
            )),
            Flexible(
                child: ActionButton(
              actionTag: attackActionMapping[StringsGameScreen.lTrf]!,
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
              actionTag: attackActionMapping[StringsGameScreen.lGoal]!,
              actionContext: actionContextAttack,
              buttonText: StringsGameScreen.lGoal,
              buttonColor: Color.fromRGBO(99, 107, 171, 1),
            )),
            Flexible(
                child: ActionButton(
              actionTag: attackActionMapping[StringsGameScreen.lOneVsOneAnd7m]!,
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
