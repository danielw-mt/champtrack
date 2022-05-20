import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import './../../controllers/globalController.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class PlayerMenu extends GetView<GlobalController> {
  // menu that allows to add log actions that happen during the game

  final GlobalController globalController = Get.find<GlobalController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // text button that triggers an alert to choose the action
        TextButton(
            onPressed: () {
              Alert(
                      context: context,
                      title: "Select a player",
                      // alert contains a list of DialogButton objects
                      buttons: buildDialogButtonList(context))
                  .show();
            },
            child: Text("Select Player")),
      ],
    );
  }

  /// builds a list of Dialog buttons
  List<DialogButton> buildDialogButtonList(BuildContext context) {
    var playerNames = globalController.chosenPlayers;
    List<DialogButton> dialogButtons = [];
    playerNames.forEach((rXString) {
      DialogButton dialogButton =
          buildDialogButton(context, rXString.toString());
      dialogButtons.add(dialogButton);
    });
    return dialogButtons;
  }

  /// builds a single dialog button that logs its text (=player name) to firestore
  /// and updates the game state
  DialogButton buildDialogButton(BuildContext context, String buttonText) {
    FirebaseFirestore db = FirebaseFirestore.instance;

    void logPlayerSelection() async {
      DateTime dateTime = DateTime.now();
      int unixTime = dateTime.toUtc().millisecondsSinceEpoch;
      int secondsSinceGameStart =
          globalController.stopWatchTimer.value.secondTime.value;

      // TODO get most recent game id from DB gamestate or db instead of hardcoding (wait for merge with start stop game)
      String mostRecentGame = "zqKzCZB5nGPVuF7H3CGe";

      // TODO maybe replace with actual player_id (wait for Anni to finish player model)
      globalController.actions.last["player_id"] = buttonText;

      // TODO update most recent action in firebase with player id (wait for merge with actionmenu)

      // update the firebase document containing the action details with the player id
      String mostRecentAction = "mostRecentAction";
      final gameDocument = db.collection("gameData").doc(mostRecentAction);
      DocumentSnapshot documentSnapshot = await gameDocument.get();
      Map<String, dynamic> documentData =
          documentSnapshot.data() as Map<String, dynamic>;
      documentData["player_id"] = buttonText;
      await db
          .collection("gameData")
          .doc(mostRecentAction)
          .update(documentData);
    }

    return DialogButton(
        child: Text(
          buttonText,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () {
          logPlayerSelection();
          Navigator.pop(context);
        });
  }
}
