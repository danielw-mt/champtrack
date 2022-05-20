import 'package:flutter/material.dart';
import './../../controllers/globalController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class GameStartStopButtons extends StatelessWidget {
  GlobalController globalController = Get.find<GlobalController>();

  @override
  Widget build(BuildContext context) {
    bool gameStarted = globalController.gameStarted.value;
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextButton(
            onPressed: () {
              if (!gameStarted) startGame(context);
            },
            child: const Text("Start Game"),
            // start button is grey when the game is started and blue when not
            style: ButtonStyle(
                backgroundColor: gameStarted
                    ? MaterialStateProperty.all<Color>(Colors.grey)
                    : MaterialStateProperty.all<Color>(Colors.red)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextButton(
              onPressed: () {
                if (gameStarted) stopGame();
              },
              child: const Text("Stop Game")),
        )
      ],
    );
  }

  void startGame(BuildContext context) {
    // check if enough players have been selected
    if (globalController.playersOnField.length < 7) {
      // create alert if someone tries to start the game without enough players
      Alert(
              context: context,
              title: "Warning",
              type: AlertType.error,
              desc: "You have tried to start the game without enough players")
          .show();
      return;
    }
    // start a new game in firebase
    
    // activate the game timer
  }

  void stopGame() {}
}
