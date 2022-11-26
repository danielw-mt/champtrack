import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/core/constants/stringsGameScreen.dart';
import 'package:handball_performance_tracker/core/constants/game_actions.dart';
import 'action_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/features/game/game.dart';
import 'goal_keeper_buttons.dart';
import 'defense_buttons.dart';
import 'attack_buttons.dart';

class DefenseButtons extends StatelessWidget {
  const DefenseButtons({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, String> defenseActionMapping = actionMapping[actionContextDefense]!;
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(children: [
            ActionButton(
                buildContext: context,
                actionTag: defenseActionMapping[StringsGameScreen.lYellowCard]!,
                actionContext: actionContextDefense,
                buttonText: StringsGameScreen.lYellowCard,
                buttonColor: Colors.yellow,
                sizeFactor: 0,
                icon: Icon(Icons.style)),
            ActionButton(
                buildContext: context,
                actionTag: defenseActionMapping[StringsGameScreen.lRedCard]!,
                actionContext: actionContextDefense,
                buttonText: StringsGameScreen.lRedCard,
                buttonColor: Colors.red,
                sizeFactor: 0,
                icon: Icon(Icons.style))
          ]),
          Flexible(
              child: ActionButton(
            buildContext: context,
            actionTag: defenseActionMapping[StringsGameScreen.lTwoMin]!,
            actionContext: actionContextDefense,
            buttonText: StringsGameScreen.lTwoMin,
            buttonColor: Color.fromRGBO(199, 208, 244, 1),
            sizeFactor: 1,
          )),
          Flexible(
              child: ActionButton(
                  buildContext: context,
                  actionTag: defenseActionMapping[StringsGameScreen.lTimePenalty]!,
                  actionContext: actionContextDefense,
                  buttonText: StringsGameScreen.lTimePenalty,
                  buttonColor: Color.fromRGBO(199, 208, 244, 1),
                  sizeFactor: 1,
                  icon: Icon(Icons.timer)))
        ],
      ),
      Flexible(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
                child: ActionButton(
              buildContext: context,
              actionTag: defenseActionMapping[StringsGameScreen.lFoul7m]!,
              actionContext: actionContextDefense,
              buttonText: StringsGameScreen.lFoul7m,
              buttonColor: Color.fromRGBO(203, 206, 227, 1),
            )),
            Flexible(
                child: ActionButton(
              buildContext: context,
              actionTag: defenseActionMapping[StringsGameScreen.lTrf]!,
              actionContext: actionContextDefense,
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
              buildContext: context,
              actionTag: defenseActionMapping[StringsGameScreen.lBlockNoBall]!,
              actionContext: actionContextDefense,
              buttonText: StringsGameScreen.lBlockNoBall,
              buttonColor: Color.fromRGBO(99, 107, 171, 1),
            )),
            Flexible(
                child: ActionButton(
              buildContext: context,
              actionTag: defenseActionMapping[StringsGameScreen.lBlockAndSteal]!,
              actionContext: actionContextDefense,
              buttonText: StringsGameScreen.lBlockAndSteal,
              buttonColor: Color.fromRGBO(99, 107, 171, 1),
            ))
          ],
        ),
      ),
    ]);
  }
}
