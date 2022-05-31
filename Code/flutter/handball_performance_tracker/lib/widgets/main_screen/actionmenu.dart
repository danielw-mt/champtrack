import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/data/database_repository.dart';
import '../../controllers/globalController.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../data/game_action.dart';
import 'playermenu.dart';
import 'dart:math';

// TODO add to constants file
List<String> attackActions = [
  "Rote Karte",
  "Gelbe Karte",
  "Zeitstrafe",
  "2min ziehen",
  "Fehlwurf",
  "TRF",
  "Tor",
  "1v1 & 7m",
];
List<String> defenseActions = [
  "Rote Karte",
  "Gelbe Karte",
  "Zeitstrafe",
  "Foul => 7m",
  "TRF",
  "Block",
  "Block & Steal"
];

Map<String, String> actionMapping = {
  "Tor": "goal",
  "1v1 & 7m": "1v1",
  "2min ziehen": "2min",
  "Fehlwurf": "err-throw",
  "TRF": "trf",
  "Rote Karte": "red",
  "Gelbe Karte": "yellow",
  "Foul => 7m": "foul",
  "Zeitstrafe": "penalty",
  "Block ohne Ballgewinn": "block",
  "Block & Steal": "block-steal"
};

void callActionMenu(BuildContext context) {
  final GlobalController globalController = Get.find<GlobalController>();

  // if game is not running give a warning
  if (globalController.gameStarted.value == false) {
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
      buildDialogButtonMenu(context, attackActions, true),
      buildDialogButtonMenu(context, defenseActions, false),
    ];
  } else {
    return [
      buildDialogButtonMenu(context, defenseActions, false),
      buildDialogButtonMenu(context, attackActions, true),
    ];
  }
}

/// @return a menu of differently arranged buttons depending on action or defense
Widget buildDialogButtonMenu(
    BuildContext context, List<String> buttonTexts, isAttack) {
  if (isAttack) {
    List<DialogButton> dialogButtons = [
      buildDialogButton(context, defenseActions[0], Colors.red, Icons.style),
      buildDialogButton(context, defenseActions[1], Colors.yellow, Icons.style),
      buildDialogButton(context, defenseActions[2], Colors.grey, Icons.timer),
      buildDialogButton(context, attackActions[3], Colors.grey),
      buildDialogButton(context, attackActions[4], Colors.grey),
      buildDialogButton(context, attackActions[5], Colors.blue),
      buildDialogButton(context, attackActions[6], Colors.blue),
      buildDialogButton(context, attackActions[7], Colors.blue)
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
      buildDialogButton(context, defenseActions[0], Colors.red, Icons.style),
      buildDialogButton(context, defenseActions[1], Colors.yellow, Icons.style),
      buildDialogButton(context, defenseActions[2],
          const Color.fromRGBO(15, 66, 199, 32), Icons.timer),
      buildDialogButton(context, defenseActions[3], Colors.grey),
      buildDialogButton(context, defenseActions[4], Colors.grey),
      buildDialogButton(context, defenseActions[5], Colors.blue),
      buildDialogButton(context, defenseActions[6], Colors.blue)
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
  //TODO add repository instance to global controller?
  DatabaseRepository repository = DatabaseRepository();
  void logAction() async {
    DateTime dateTime = DateTime.now();
    int unixTime = dateTime.toUtc().millisecondsSinceEpoch;
    int secondsSinceGameStart =
        globalController.stopWatchTimer.value.secondTime.value;

    // get most recent game id from DB
    String currentGameId = globalController.currentGame.value.id!;
    GameAction action = GameAction(
        clubId: globalController.currentClub.value.id!,
        gameId: currentGameId,
        type: determineAttack() ? "attack" : "defense",
        actionType: actionMapping[buttonText]!,
        throwLocation: globalController.lastLocation.value,
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
        logAction();
        Navigator.pop(context);
        callPlayerMenu(context);
      });
}
