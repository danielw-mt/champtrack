import 'package:flutter/material.dart';
import '../../strings.dart';
import '../../controllers/persistentController.dart';
import '../../controllers/tempController.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../data/game_action.dart';
import '../../constants/game_actions.dart';
import 'playermenu.dart';
import 'dart:math';
import 'package:logger/logger.dart';

var logger = Logger(
  printer: PrettyPrinter(
      methodCount: 2, // number of method calls to be displayed
      errorMethodCount: 8, // number of method calls if stacktrace is provided
      lineLength: 120, // width of the output
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
      printTime: false // Should each log print contain a timestamp
      ),
);

void callActionMenu(BuildContext context) {
  logger.d("Calling action menu");
  final TempController tempController = Get.find<TempController>();

  // if game is not running give a warning
  if (tempController.getGameIsRunning() == false) {
    Alert(
      context: context,
      title: Strings.lGameStartErrorMessage,
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
                    child: PageView(
                        controller: new PageController(),
                        children: buildPageViewChildren(context))),
              ] // Column of "Spieler", horizontal line and Button-Row
              ))).show();
}

///
String determineActionType() {
  logger.d("Determining whether attack actions should be displayed...");
  final TempController tempController = Get.find<TempController>();
  // decide whether attack or defense actions should be displayed depending
  //on what side the team goals is and whether they are attacking or defending
  String actionType = defense;
  bool attackIsLeft = tempController.getAttackIsLeft();
  bool fieldIsLeft = tempController.getFieldIsLeft();

  // when our goal is to the right (= attackIsLeft) and the field is left
  //display attack options
  if (tempController.getLastLocation()[0] == goal) {
    actionType = ownGoalkeeper;
    if (attackIsLeft && fieldIsLeft) {
      actionType = otherGoalkeeper;
      // when our goal is to the left (=attack is right) and the field is to the
      //right display attack options
    } else if (attackIsLeft == false && fieldIsLeft == false) {
      actionType = otherGoalkeeper;
    }
  } else {
    if (attackIsLeft && fieldIsLeft) {
      actionType = attack;
      // when our goal is to the left (=attack is right) and the field is to the
      //right display attack options
    } else if (attackIsLeft == false && fieldIsLeft == false) {
      actionType = attack;
    }
  }
  logger.d("Attack actions should be displayed: $actionType");
  return actionType;
}

// a method for building the children of the pageview in the right order
// by arranging either the attack menu or defense menu first
List<Widget> buildPageViewChildren(BuildContext context) {
  String actionType = determineActionType();
  if (actionType == ownGoalkeeper) {
    return [
      buildDialogButtonMenu(
          context, actionMapping[ownGoalkeeper]!.keys.toList(), false, true),
    ];
  } else if (actionType == otherGoalkeeper) {
    return [
      buildDialogButtonMenu(
          context, actionMapping[otherGoalkeeper]!.keys.toList(), false, true),
    ];
  } else if (actionType == attack) {
    return [
      buildDialogButtonMenu(
          context, actionMapping[attack]!.keys.toList(), true, false),
      buildDialogButtonMenu(
          context, actionMapping[defense]!.keys.toList(), false, false),
    ];
  } else {
    return [
      buildDialogButtonMenu(
          context, actionMapping[defense]!.keys.toList(), false, false),
      buildDialogButtonMenu(
          context, actionMapping[attack]!.keys.toList(), true, false),
    ];
  }
}

/// @return a menu of differently arranged buttons depending on action or defense
Widget buildDialogButtonMenu(BuildContext context, List<String> buttonTexts,
    bool isAttack, bool isGoalkeeper) {
  String header;
  Row buttonRow;
  if (isGoalkeeper) {
    List<DialogButton> dialogButtons = [
      buildDialogButton(context, buttonTexts[0], Colors.red, Icons.style),
      buildDialogButton(context, buttonTexts[1], Colors.yellow, Icons.style),
      buildDialogButton(context, buttonTexts[2], Colors.grey, Icons.timer),
      buildDialogButton(context, buttonTexts[3], Colors.grey),
      buildDialogButton(context, buttonTexts[4], Colors.grey),
      buildDialogButton(context, buttonTexts[5], Colors.blue),
      buildDialogButton(context, buttonTexts[6], Colors.blue),
      buildDialogButton(context, buttonTexts[7], Colors.blue),
    ];
    buttonRow = Row(children: [
      Column(
        children: [dialogButtons[0], dialogButtons[1], dialogButtons[2]],
      ),
      Column(children: [dialogButtons[3], dialogButtons[4], dialogButtons[5]]),
      Column(
        children: [dialogButtons[6], dialogButtons[7]],
      ),
    ]);
    header = Strings.lGoalkeeperPopUpHeader;
  } else if (isAttack) {
    List<DialogButton> dialogButtons = [
      buildDialogButton(context, buttonTexts[0], Colors.red, Icons.style),
      buildDialogButton(context, buttonTexts[1], Colors.yellow, Icons.style),
      buildDialogButton(context, buttonTexts[2], Colors.grey, Icons.timer),
      buildDialogButton(context, buttonTexts[3], Colors.grey),
      buildDialogButton(context, buttonTexts[4], Colors.grey),
      buildDialogButton(context, buttonTexts[5], Colors.blue),
      buildDialogButton(context, buttonTexts[6], Colors.blue),
      buildDialogButton(context, buttonTexts[7], Colors.blue)
    ];
    buttonRow = Row(children: [
      Column(
        children: [dialogButtons[0], dialogButtons[1], dialogButtons[2]],
      ),
      Column(
        children: [dialogButtons[3], dialogButtons[4], dialogButtons[5]],
      ),
      Column(
        children: [dialogButtons[6], dialogButtons[7]],
      ),
    ]);
    header = Strings.lOffensePopUpHeader;
  } else {
    List<DialogButton> dialogButtons = [
      buildDialogButton(context, buttonTexts[0], Colors.red, Icons.style),
      buildDialogButton(context, buttonTexts[1], Colors.yellow, Icons.style),
      buildDialogButton(context, buttonTexts[2],
          const Color.fromRGBO(15, 66, 199, 32), Icons.timer),
      buildDialogButton(context, buttonTexts[3], Colors.grey),
      buildDialogButton(context, buttonTexts[4], Colors.grey),
      buildDialogButton(context, buttonTexts[5], Colors.blue),
      buildDialogButton(context, buttonTexts[6], Colors.blue)
    ];
    buttonRow = Row(children: [
      Column(
        children: [dialogButtons[0], dialogButtons[1], dialogButtons[2]],
      ),
      Column(
        children: [dialogButtons[3], dialogButtons[4]],
      ),
      Column(
        children: [dialogButtons[5], dialogButtons[6]],
      ),
    ]);
    header = Strings.lDeffensePopUpHeader;
  }
  return Column(children: [
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            header,
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
    buttonRow
  ]);
}

/// @return
/// builds a single dialog button that logs its text (=action) to firestore
//  and updates the game state. Its color and icon can be specified as parameters
DialogButton buildDialogButton(
    BuildContext context, String buttonText, Color color,
    [icon]) {
  TempController tempController = Get.find<TempController>();
  PersistentController persistentController = Get.find<PersistentController>();
  void logAction() async {
    logger.d("logging an action");
    DateTime dateTime = DateTime.now();
    int unixTime = dateTime.toUtc().millisecondsSinceEpoch;
    int secondsSinceGameStart =
        persistentController.getCurrentGame().stopWatch.secondTime.value;

    // get most recent game id from DB
    String currentGameId = persistentController.getCurrentGame().id!;
    String actionType = determineActionType();

    GameAction action = GameAction(
        teamId: tempController.getSelectedTeam().id!,
        gameId: currentGameId,
        type: actionType,
        actionType: buttonText,
        throwLocation: tempController.getLastLocation().cast<String>(),
        timestamp: unixTime,
        relativeTime: secondsSinceGameStart);
    logger.d("GameAction object created: ");
    logger.d(action);

    // add action to firebase

    // store most recent action id in game state for the player menu
    // when a player was selected in that menu the action document can be
    // updated in firebase with their player_id using the action_id
    logger.d("Adding gameaction to firebase");
    persistentController.addAction(action);
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
