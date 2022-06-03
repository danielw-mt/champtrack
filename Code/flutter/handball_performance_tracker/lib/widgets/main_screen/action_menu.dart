import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/data/database_repository.dart';
import '../../controllers/globalController.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../data/game_action.dart';
import '../../data/database_repository.dart';
import '../../constants/game_actions.dart';
import 'playermenu.dart';

void callActionMenu(BuildContext context) {
  final GlobalController globalController = Get.find<GlobalController>();
  // if game is not running give a warning
  if (globalController.gameStarted.value == false) {
    Alert(
      context: context,
      title: "Error game did not start yet",
      type: AlertType.error,
    )
        // when displayAttackActions is true display buttonlist with attack
        //options otherwise with defense options

        .show();
    return;
  }
  // alert contains a list of DialogButton objects
  Alert(
          context: context,
          title: "Select an action",
          // when displayAttackActions is true display buttonlist with attack
          //options otherwise with defense options
          buttons: determineAttack()
              ? buildDialogButtonList(context, actionMapping[attack]!.keys.toList())
              : buildDialogButtonList(context, actionMapping[defense]!.keys.toList()))
      .show();
}

///
bool determineAttack() {
  final GlobalController globalController = Get.find<GlobalController>();
  // decide whether attack or defense actions should be displayed depending
  //on what side the team goals is and whether they are attacking or defending
  bool attacking = false;
  bool attackIsLeft = globalController.attackIsLeft.value;
  bool fieldIsLeft = globalController.fieldIsLeft.value;

  // when our goal is to the right (= attackIsLeft) and the field is left
  //display attack options
  if (attackIsLeft && fieldIsLeft) {
    attacking = true;
    // when our goal is to the left (=attack is right) and the field is to the
    //right display attack options
  } else if (attackIsLeft == false && fieldIsLeft == false) {
    attacking = true;
  }
  return attacking;
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
  final GlobalController globalController = Get.find<GlobalController>();
  DatabaseRepository repository = DatabaseRepository();
  void logAction() async {
    DateTime dateTime = DateTime.now();
    int unixTime = dateTime.toUtc().millisecondsSinceEpoch;
    int secondsSinceGameStart =
        globalController.stopWatchTimer.value.secondTime.value;

    // get most recent game id from DB
    String currentGameId = globalController.currentGame.value.id!;
    String actionType = determineAttack() ? attack : defense;

    GameAction action = GameAction(
        clubId: globalController.currentClub.value.id!,
        gameId: currentGameId,
        type: actionType,
        actionType: actionMapping[actionType]![buttonText]!,
        throwLocation: globalController.lastLocation.cast<String>(),
        timestamp: unixTime,
        relativeTime: secondsSinceGameStart);
    globalController.actions.add(action);

    // add action to firebase

    // store most recent action id in game state for the player menu
    // when a player was selected in that menu the action document can be
    // updated in firebase with their player_id using the action_id
    repository
        .addActionToGame(action)
        .then((DocumentReference doc) => action.id = doc.id);
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
