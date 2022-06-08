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
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'dart:math';

void callActionMenu(BuildContext context) {
  final GlobalController globalController = Get.find<GlobalController>();

  // if game is not running give a warning
  if (globalController.gameRunning.value == false) {
    Alert(
      context: context,
      title: "Error game did not start yet",
      type: AlertType.error,
    ).show();
    return;
  }

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
      content: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.88,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: PageView(children: buildPageViewChildren(context))),
              ] // Column of "Spieler", horizontal line and Button-Row
              ))).show();
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

// a method for building the children of the pageview in the right order
// by arranging either the attack menu or defense menu first
List<Widget> buildPageViewChildren(BuildContext context) {
  if (determineAttack() == true) {
    return [
      buildDialogButtonMenu(
          context, actionMapping[attack]!.keys.toList(), true),
      buildDialogButtonMenu(
          context, actionMapping[defense]!.keys.toList(), false),
    ];
  } else {
    return [
      buildDialogButtonMenu(
          context, actionMapping[defense]!.keys.toList(), false),
      buildDialogButtonMenu(
          context, actionMapping[attack]!.keys.toList(), true),
    ];
  }
}

/// @return a menu of differently arranged buttons depending on action or defense
Widget buildDialogButtonMenu(
    BuildContext context, List<String> buttonTexts, isAttack) {
  if (isAttack) {
    List<DialogButton> dialogButtons = [
      buildDialogButton(context, actionMapping[defense]!.keys.toList()[0],
          Colors.red, Icons.style),
      buildDialogButton(context, actionMapping[defense]!.keys.toList()[1],
          Colors.yellow, Icons.style),
      buildDialogButton(context, actionMapping[defense]!.keys.toList()[2],
          Colors.grey, Icons.timer),
      buildDialogButton(
          context, actionMapping[attack]!.keys.toList()[3], Colors.grey),
      buildDialogButton(
          context, actionMapping[attack]!.keys.toList()[4], Colors.grey),
      buildDialogButton(
          context, actionMapping[attack]!.keys.toList()[5], Colors.blue),
      buildDialogButton(
          context, actionMapping[attack]!.keys.toList()[6], Colors.blue),
      buildDialogButton(
          context, actionMapping[attack]!.keys.toList()[7], Colors.blue)
    ];
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Offensive Aktionen",
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
      // horizontal line
      const Divider(
        thickness: 2,
        color: Colors.black,
        height: 6,
      ),
      // Button-Row: one Row with 3 Columns of 3, 3 and 2 buttons
      Row(children: [
        Column(
          children: [dialogButtons[0], dialogButtons[1], dialogButtons[2]],
        ),
        Column(
          children: [dialogButtons[3], dialogButtons[4], dialogButtons[5]],
        ),
        Column(
          children: [dialogButtons[6], dialogButtons[7]],
        ),
      ])
    ]);
  } else {
    List<DialogButton> dialogButtons = [
      buildDialogButton(context, actionMapping[defense]!.keys.toList()[0],
          Colors.red, Icons.style),
      buildDialogButton(context, actionMapping[defense]!.keys.toList()[1],
          Colors.yellow, Icons.style),
      buildDialogButton(context, actionMapping[defense]!.keys.toList()[2],
          const Color.fromRGBO(15, 66, 199, 32), Icons.timer),
      buildDialogButton(
          context, actionMapping[defense]!.keys.toList()[3], Colors.grey),
      buildDialogButton(
          context, actionMapping[defense]!.keys.toList()[4], Colors.grey),
      buildDialogButton(
          context, actionMapping[defense]!.keys.toList()[5], Colors.blue),
      buildDialogButton(
          context, actionMapping[defense]!.keys.toList()[6], Colors.blue)
    ];
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Defensive Aktionen",
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
      // horizontal line
      const Divider(
        thickness: 2,
        color: Colors.black,
        height: 6,
      ),
      // Button-Row: one Row with 3 Columns of 3, 2 and 2 buttons
      Row(children: [
        Column(
          children: [dialogButtons[0], dialogButtons[1], dialogButtons[2]],
        ),
        Column(
          children: [dialogButtons[3], dialogButtons[4]],
        ),
        Column(
          children: [dialogButtons[5], dialogButtons[6]],
        ),
      ])
    ]);
  }
}

/// @return
/// builds a single dialog button that logs its text (=action) to firestore
//  and updates the game state. Its color and icon can be specified as parameters
DialogButton buildDialogButton(
    BuildContext context, String buttonText, Color color,
    [icon]) {
  final GlobalController globalController = Get.find<GlobalController>();
  DatabaseRepository repository = globalController.repository;
  void logAction() async {
    DateTime dateTime = DateTime.now();
    int unixTime = dateTime.toUtc().millisecondsSinceEpoch;
    int secondsSinceGameStart =
        globalController.currentGame.value.stopWatch.secondTime.value;

    // get most recent game id from DB
    String currentGameId = globalController.currentGame.value.id!;
    String actionType = determineAttack() ? attack : defense;

    GameAction action = GameAction(
        teamId: globalController.selectedTeam.value.id!,
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

  final double width = MediaQuery.of(context).size.width;
  final double height = MediaQuery.of(context).size.height;
  return DialogButton(
      margin: EdgeInsets.all(min(height, width) * 0.013),
      // have round edges with same degree as Alert dialog
      radius: const BorderRadius.all(Radius.circular(15)),
      // set height and width of buttons so the shirt and name are fitting inside
      height: width * 0.10,
      width: width * 0.10,
      color: color,
      child: Center(
        child: Column(
          children: [
            (icon != null) ? Icon(icon) : Container(),
            Text(
              buttonText,
              style: TextStyle(color: Colors.white, fontSize: 20),
            )
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
      onPressed: () {
        // reset the feed timer
        logAction();
        Navigator.pop(context);
        callPlayerMenu(context);
      });
}
