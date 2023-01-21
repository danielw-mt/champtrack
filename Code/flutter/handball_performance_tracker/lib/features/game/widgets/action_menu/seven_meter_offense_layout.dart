import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/core/core.dart';
import 'action_button.dart';

class SevenMeterOffenseLayout extends StatelessWidget {
  const SevenMeterOffenseLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ActionButton(
          actionTag: goal7mTag,
          actionContext: actionContextSevenMeter,
          buttonText: StringsGameScreen.lGoal,
          buttonColor: Colors.lightBlue,
        ),
        ActionButton(
          actionTag: missed7mTag,
          actionContext: actionContextSevenMeter,
          buttonText: StringsGameScreen.lMiss,
          buttonColor: Colors.deepPurple,
        ),
      ],
    );
  }
}
