import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/core/core.dart';
import 'action_button.dart';

class SevenMeterPromptLayout extends StatelessWidget {
  const SevenMeterPromptLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ActionButton(
          actionTag: no7mTag,
          actionContext: actionContextSevenMeter,
          buttonText: StringsGameScreen.lNoSevenMeter,
          buttonColor: Colors.lightBlue,
        ),
        ActionButton(
          actionTag: yes7mTag,
          actionContext: actionContextSevenMeter,
          buttonText: StringsGameScreen.lYesSevenMeter,
          buttonColor: Colors.deepPurple,
        ),
      ],
    );
  }
}
