import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/utils/icons.dart';
import '../../controllers/globalController.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:math';

void callPlayerMenu(context) {
  final GlobalController globalController = Get.find<GlobalController>();
  List<DialogButton> dialogButtons = buildDialogButtonList(context);
  Alert(
    style: AlertStyle(
      // make round edges
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      // false so there is no big close-Button at the bottom
      isButtonVisible: false,
    ),
    context: context,
    // alert contains a list of DialogButton objects
    content:
        // Column of "Spieler", horizontal line and Button-Row
        Column(
      children: [
        const Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Spieler",
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ),
        // horizontal line
        const Divider(
          thickness: 2,
          color: Colors.black,
          height: 6,
        ),
        // Button-Row: one Row with four Columns of one or two buttons
        Row(children: [
          dialogButtons[0],
          Column(
            children: [dialogButtons[1], dialogButtons[2]],
          ),
          Column(
            children: [dialogButtons[3], dialogButtons[4]],
          ),
          Column(
            children: [dialogButtons[5], dialogButtons[6]],
          ),
        ]),
      ],
    ),
  ).show();
}

/// builds a list of Dialog buttons
List<DialogButton> buildDialogButtonList(BuildContext context) {
  final GlobalController globalController = Get.find<GlobalController>();
  var playerNames = globalController.chosenPlayers;
  List<DialogButton> dialogButtons = [];
  playerNames.forEach((rXString) {
    DialogButton dialogButton =
        buildDialogButton(context, rXString.toString(), "1");
    dialogButtons.add(dialogButton);
  });
  return dialogButtons;
}

/// builds a single dialog button that logs its text (=player name) to firestore
/// and updates the game state
DialogButton buildDialogButton(
    BuildContext context, String buttonText, String buttonNumber) {
  final GlobalController globalController = Get.find<GlobalController>();
  FirebaseFirestore db = FirebaseFirestore.instance;

  // Get width and height, so the sizes can be calculated relative to those. So it should look the same on different screen sizes.
  final double width = MediaQuery.of(context).size.width;
  final double height = MediaQuery.of(context).size.height;

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
        print("solo goal");
        // update data for person that shot the goal
        lastActionData["player_id"] = goalScorer;
        lastActionData["action_type"] = "Tor solo";
        await db
            .collection("gameData")
            .doc(mostRecentActionId)
            .update(lastActionData);
        globalController.actions.last = lastActionData;
        globalController.lastClickedPlayer.value = "";
        globalController.refresh();
      } else {
        // if it was an assist update data for both
        // person that scored goal
        lastActionData["player_id"] = goalScorer;
        lastActionData["action_type"] = "Tor nach Assist";
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

  // Button with shirt with buttonNumber inside and buttonText below.
  return DialogButton(
      child:
          // Column with 2 entries: 1. a Stack with Shirt & buttonNumber and 2. buttonText
          Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // ButtonNumber
              Text(
                buttonNumber,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: (width * 0.03),
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Shirt
              Center(
                child: Icon(
                  MyFlutterApp.t_shirt,
                  size: (width * 0.11),
                ),
              ),
            ],
          ),
          // ButtonName
          Text(
            buttonText,
            style: TextStyle(
              color: Colors.black,
              fontSize: (width * 0.02),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      // have some space between the buttons
      margin: EdgeInsets.all(min(height, width) * 0.013),
      // have round edges with same degree as Alert dialog
      radius: const BorderRadius.all(Radius.circular(15)),
      // set height and width of buttons so the shirt and name are fitting inside
      height: width * 0.14,
      width: width * 0.14,
      color: Color.fromARGB(255, 180, 211, 236),
      onPressed: () {
        logPlayerSelection();
      });
}
