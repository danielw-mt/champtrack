import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../controllers/globalController.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void callPlayerMenu(context) {
  final GlobalController globalController = Get.find<GlobalController>();
  Alert(
          context: context,
          title: "Choose Player",
          // alert contains a list of DialogButton objects
          desc: globalController.playerMenuText.value,
          buttons: buildDialogButtonList(context))
      .show();
}

/// builds a list of Dialog buttons
List<DialogButton> buildDialogButtonList(BuildContext context) {
  final GlobalController globalController = Get.find<GlobalController>();
  var playerNames = globalController.chosenPlayers;
  List<DialogButton> dialogButtons = [];
  playerNames.forEach((rXString) {
    DialogButton dialogButton = buildDialogButton(context, rXString.toString());
    dialogButtons.add(dialogButton);
  });
  return dialogButtons;
}

/// builds a single dialog button that logs its text (=player name) to firestore
/// and updates the game state
DialogButton buildDialogButton(BuildContext context, String buttonText) {
  final GlobalController globalController = Get.find<GlobalController>();
  FirebaseFirestore db = FirebaseFirestore.instance;

  /// @return "" if action wasn't a goal, "solo" when player scored without
  /// assist and "assist" when player click was assist
  bool wasAssist() {
    // check if action was a goal
    // if it was a goal allow the player to be pressed twice or select and assist player
    globalController.playerMenuText.value =
        "Press again for solo or other player for assist";
    globalController.refresh();
    // if the player is clicked again it is a solo action
    if (globalController.lastClickedPlayer.value == buttonText) {
      return false;
    }
    if (globalController.lastClickedPlayer.value != buttonText) {
      return true;
    }
    return false;
  }

  void logPlayerSelection() async {
    String mostRecentActionId = globalController.lastGameActionId.value;
    Map<String, dynamic> lastActionData = globalController.actions.last;
    String goalScorer = globalController.lastClickedPlayer.value;
    DateTime dateTime = DateTime.now();
    final gameDocument = db.collection("gameData").doc(mostRecentActionId);
    // if goal was pressed but no player was selected yet do nothing
    if (lastActionData["action_type"] == "Tor" && goalScorer == "") {
      print("goal player clicked once");
      globalController.lastClickedPlayer.value = buttonText;
      globalController.refresh();
      return;
    }
    // if goal was pressed and a player was already clicked once
    if (lastActionData["action_type"] == "Tor") {
      print("goal player clicked twice");
      // if it was a solo goal the action type has to be updated to "Tor Solo"
      if (wasAssist() == false) {
        // update data for person that shot the goal
        lastActionData["player_id"] = goalScorer;
        lastActionData["action_type"] == "Tor solo";
        await db
            .collection("gameData")
            .doc(mostRecentActionId)
            .update(lastActionData);
        globalController.lastClickedPlayer.value = "";
      } else {
        // if it was an assist update data for both
        // person that scored goal
        lastActionData["player_id"] = goalScorer;
        lastActionData["action_type"] == "Tor solo";
        await db
            .collection("gameData")
            .doc(mostRecentActionId)
            .update(lastActionData);
        globalController.actions.last = lastActionData;
        // person that scored assist
        // deep clone a new action from the most recent action
        Map<String, dynamic> assistAction = new Map.from(lastActionData);
        assistAction["player_id"] = buttonText;
        assistAction["action_type"] = "Assist";
        db.collection("gameData").add(assistAction).then(
            (DocumentReference doc) =>
                globalController.lastGameActionId.value = doc.id);
        globalController.actions.add(assistAction);
        globalController.lastClickedPlayer.value = "";
      }
    } else {
      // if the action was not a goal just update the player id in firebase and gamestate
      lastActionData["player_id"] = buttonText;
      globalController.actions.last = lastActionData;
      await db
          .collection("gameData")
          .doc(mostRecentActionId)
          .update(lastActionData);
      globalController.lastClickedPlayer.value = "";
    }
    print("last action saved in database: ");
    print(globalController.actions.last.toString());
    globalController.refresh();
    Navigator.pop(context);
  }

  return DialogButton(
      child: Text(
        buttonText,
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      onPressed: () {
        logPlayerSelection();
      });
}
