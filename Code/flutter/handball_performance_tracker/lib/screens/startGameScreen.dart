import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/controllers/globalController.dart';
import 'package:handball_performance_tracker/widgets/start_game_screen/start_game_form.dart';
import 'package:handball_performance_tracker/strings.dart';

// TODO change this to Statefulwidget
// turn team selection screen into team selection screen and teamSelectionWidget
// build player position widget as a simple list
// build halbzeit seite auswählen widget
// dependign on the State of StartGameScreen build StartGameForm,teamSelectionDropdown, PlayersList, PlayerPositionWidget, halbzeit seite auswählen widget, check everything widget

class StartScreen extends StatefulWidget {
  StartScreen({Key? key}) : super(key: key);

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  int startScreenStep = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildStartScreenContent(),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          ElevatedButton(
            onPressed: () {
              if (startScreenStep > 0) {
                startScreenStep -= 1;
              }
            },
            child: startScreenStep == 0 ? Container() : Text(Strings.lBack),
          ),
          ElevatedButton(
              onPressed: () {
                startScreenStep += 1;
              },
              child: startScreenStep == 3
                  ? Text(Strings.lStartGameButton)
                  : Text(Strings.lNext))
        ])
      ],
    );
  }

  Widget buildStartScreenContent() {
    if (startScreenStep == 0) {
      return StartGameForm();
    }
    // TODO Implement playerselection
    if (startScreenStep == 1) {
      // return PlayerSelection;
    }

    if (startScreenStep == 2) {
      // return PlayerPositioningWidget;
    }

    if (startScreenStep == 3) {
      // return
    }
    return Container();
  }
}
