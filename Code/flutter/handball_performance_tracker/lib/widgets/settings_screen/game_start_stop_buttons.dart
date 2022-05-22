import 'package:flutter/material.dart';
import './../../controllers/globalController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class GameStartStopButtons extends StatelessWidget {
  GlobalController globalController = Get.find<GlobalController>();
  var db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    var gameStarted = globalController.gameStarted;
    return GetBuilder<GlobalController>(
        builder: (_) => Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextButton(
                    onPressed: () {
                      if (gameStarted.value == false) startGame(context);
                    },
                    child: const Text("Start Game"),
                    // start button is grey when the game is started and blue when not
                    style: ButtonStyle(
                        backgroundColor: gameStarted.value
                            ? MaterialStateProperty.all<Color>(Colors.grey)
                            : MaterialStateProperty.all<Color>(Colors.red)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextButton(
                      onPressed: () {
                        if (gameStarted.value == true) stopGame();
                      },
                      child: const Text("Stop Game")),
                )
              ],
            ));
  }

  void startGame(BuildContext context) {
    // check if enough players have been selected
    var numPlayersOnField =
        globalController.playersOnField.where((c) => c == true).toList().length;
    if (numPlayersOnField != 7) {
      // create alert if someone tries to start the game without enough players
      Alert(
              context: context,
              title: "Warning",
              type: AlertType.error,
              desc: "You can only start the game with 7 players on the field")
          .show();
      return;
    }

    // start a new game in firebase
    DateTime dateTime = DateTime.now();
    int unixTimeStamp = dateTime.toUtc().millisecondsSinceEpoch;
    final game = {
      "date": dateTime,
      "start_time": unixTimeStamp,
      "stop_time": "",
      "score_home": "",
      "score_guest": "",
      "players": globalController.chosenPlayers
    };

    db.collection("games").add(game).then((DocumentReference doc) =>
        globalController.currentGameId.value = doc.id);

    // activate the game timer
    globalController.stopWatchTimer.value.onExecute.add(StopWatchExecute.start);

    globalController.gameStarted.value = true;
    globalController.refresh();
  }

  void stopGame() async {
    // update game document in firebase
    String currentGameId = globalController.currentGameId.value;
    final gameDocument = db.collection("games").doc(currentGameId);
    DocumentSnapshot documentSnapshot = await gameDocument.get();
    Map<String, dynamic> documentData =
        documentSnapshot.data() as Map<String, dynamic>;
    DateTime dateTime = DateTime.now();
    int unixTimeStamp = dateTime.toUtc().millisecondsSinceEpoch;
    documentData["stop_time"] = unixTimeStamp;
    documentData["score_home"] = globalController.homeTeamGoals.value;
    documentData["score_guest"] = globalController.guestTeamGoals.value;
    documentData["players"] = globalController.chosenPlayers;
    await db.collection("games").doc(currentGameId).update(documentData);

    // stop the game timer
    globalController.stopWatchTimer.value.onExecute.add(StopWatchExecute.stop);

    globalController.gameStarted.value = false;
    globalController.refresh();
  }
}
