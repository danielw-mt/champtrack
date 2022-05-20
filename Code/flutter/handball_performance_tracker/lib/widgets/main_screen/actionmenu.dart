import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../controllers/globalController.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'playermenu.dart';

List<String> attackActions = [
  "Tor",
  "1v1 & 7m",
  "2min ziehen",
  "Fehlwurf",
  "TRF"
];
List<String> defenseActions = [
  "Rote Karte",
  "Foul => 7m",
  "Zeitstrafe",
  "Block ohne Ballgewinn",
  "Block & Steal"
];

void callActionMenu(BuildContext context) {
  final GlobalController globalController = Get.find<GlobalController>();
  // decide whether attack or defense actions should be displayed depending
  //on what side the team goals is and whether they are attacking or defending
  bool displayAttackActions = false;
  bool attackIsLeft = globalController.attackIsLeft.value;
  bool fieldIsLeft = globalController.fieldIsLeft.value;

  // when our goal is to the right (= attackIsLeft) and the field is left
  //display attack options
  if (attackIsLeft && fieldIsLeft) {
    displayAttackActions = true;
    // when our goal is to the left (=attack is right) and the field is to the
    //right display attack options
  } else if (attackIsLeft == false && fieldIsLeft == false) {
    displayAttackActions = true;
  }
  // alert contains a list of DialogButton objects
  Alert(
          context: context,
          title: "Select an action",
          // when displayAttackActions is true display buttonlist with attack
          //options otherwise with defense options
          buttons: displayAttackActions
              ? buildDialogButtonList(context, attackActions)
              : buildDialogButtonList(context, defenseActions))
      .show();
}

/// @return a list of Dialog buttons
List<DialogButton> buildDialogButtonList(
    BuildContext context, List<String> buttonTexts) {
  List<DialogButton> dialogButtons = [];
  buttonTexts.forEach((text) {
    DialogButton dialogButton = buildDialogButton(context, text);
    dialogButtons.add(dialogButton);
  });
  return dialogButtons;
}

/// @return
/// builds a single dialog button that logs its text (=action) to firestore
//  and updates the game state
DialogButton buildDialogButton(BuildContext context, String buttonText) {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final GlobalController globalController = Get.find<GlobalController>();
  void logAction() async {
    DateTime dateTime = DateTime.now();
    int unixTime = dateTime.toUtc().millisecondsSinceEpoch;
    int secondsSinceGameStart =
        globalController.stopWatchTimer.value.secondTime.value;

    // TODO get most recent game id from DB gamestate or db instead of hardcoding
    String mostRecentGame = "zqKzCZB5nGPVuF7H3CGe";

    Map<String, dynamic> action = {
      "club_id": "-1",
      "game_id": mostRecentGame,
      "player_id": "",
      "type": globalController.fieldIsLeft.value ? "attack" : "defense",
      "action_type": buttonText,
      "position": "",
      "timestamp": unixTime,
      "relative_time": secondsSinceGameStart
    };
    globalController.actions.add(buttonText);

    // add action to firebase

    // store most recent action id in game state for the player menu
    // when a player was selected in that menu the action document can be
    // updated in firebase with their player_id using the action_id
    db.collection("gameData").add(action).then((DocumentReference doc) =>
        globalController.lastGameActionId.value = doc.id);
  }

  return DialogButton(
      child: Text(
        buttonText,
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      onPressed: () {
        logAction();
        Navigator.pop(context);
        callPlayerMenu(context);
      });
}

// class ActionMenu extends GetView<GlobalController> {
//   // menu that allows to add log actions that happen during the game

//   final GlobalController globalController = Get.find<GlobalController>();

//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }

//

//

// }
