import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/core/core.dart';
import 'action_button.dart';

class DefenseLayout extends StatelessWidget {
  const DefenseLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(children: [
            ActionButton(
                actionTag: yellowCardTag,
                actionContext: actionContextDefense,
                buttonText: StringsGameScreen.lYellowCard,
                buttonColor: Colors.yellow,
                sizeFactor: 0,
                icon: Icon(Icons.style)),
            ActionButton(
                actionTag: redCardTag,
                actionContext: actionContextDefense,
                buttonText: StringsGameScreen.lRedCard,
                buttonColor: Colors.red,
                sizeFactor: 0,
                icon: Icon(Icons.style))
          ]),
          Flexible(
              child: ActionButton(
            actionTag: forceTwoMinTag,
            actionContext: actionContextDefense,
            buttonText: StringsGameScreen.lForceTwoMin,
            buttonColor: Color.fromRGBO(199, 208, 244, 1),
            sizeFactor: 1,
          )),
          Flexible(
              child: ActionButton(
                  actionTag: timePenaltyTag,
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
              actionTag: foulSevenMeterTag,
              actionContext: actionContextDefense,
              buttonText: StringsGameScreen.lFoul7m,
              buttonColor: Color.fromRGBO(203, 206, 227, 1),
            )),
            Flexible(
                child: ActionButton(
              actionTag: trfTag,
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
              actionTag: blockNoBallTag,
              actionContext: actionContextDefense,
              buttonText: StringsGameScreen.lBlockNoBall,
              buttonColor: Color.fromRGBO(99, 107, 171, 1),
            )),
            Flexible(
                child: ActionButton(
              actionTag: blockAndStealTag,
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
