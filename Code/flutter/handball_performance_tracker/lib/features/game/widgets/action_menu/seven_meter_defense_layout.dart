import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/core/core.dart';
import 'action_button.dart';

class SevenMeterDefenseLayout extends StatelessWidget {
  const SevenMeterDefenseLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ActionButton(
          actionTag: parade7mTag,
          actionContext: actionContextSevenMeter,
          buttonText: StringsGameScreen.lParade,
          buttonColor: Colors.lightBlue,
        ),
        ActionButton(
          actionTag: goalOpponent7mTag,
          actionContext: actionContextSevenMeter,
          buttonText: StringsGameScreen.lGoalOpponent,
          buttonColor: Colors.deepPurple,
        ),
      ],
    );
  }
}
