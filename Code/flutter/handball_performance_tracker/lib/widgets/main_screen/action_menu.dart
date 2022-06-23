import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/data/database_repository.dart';
import 'package:handball_performance_tracker/utils/feed_logic.dart';
import 'package:handball_performance_tracker/widgets/main_screen/seven_meter_menu.dart';
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
bool determineAttack() {
  logger.d("Determining whether attack actions should be displayed...");
  final TempController tempController = Get.find<TempController>();
  // decide whether attack or defense actions should be displayed depending
  //on what side the team goals is and whether they are attacking or defending
  bool attacking = false;
  bool attackIsLeft = tempController.getAttackIsLeft();
  bool fieldIsLeft = tempController.getFieldIsLeft();

  // when our goal is to the right (= attackIsLeft) and the field is left
  //display attack options
  if (attackIsLeft && fieldIsLeft) {
    attacking = true;
    // when our goal is to the left (=attack is right) and the field is to the
    //right display attack options
  } else if (attackIsLeft == false && fieldIsLeft == false) {
    attacking = true;
  }
  logger.d("Attack actions should be displayed: $attacking");
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
      buildDialogButton(context, actionMapping[attack]!.keys.toList()[0],
          Colors.red, Icons.style),
      buildDialogButton(context, actionMapping[attack]!.keys.toList()[1],
          Colors.yellow, Icons.style),
      buildDialogButton(context, actionMapping[attack]!.keys.toList()[2],
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
              Strings.lOffensePopUpHeader,
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
              Strings.lDeffensePopUpHeader,
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
    String type = determineAttack() ? attack : defense;
    print(buttonText);
    String actionType = actionMapping[type]![buttonText]!;
    GameAction action = GameAction(
        teamId: tempController.getSelectedTeam().id!,
        gameId: currentGameId,
        type: type,
        actionType: actionType,
        throwLocation: tempController.getLastLocation().cast<String>(),
        timestamp: unixTime,
        relativeTime: secondsSinceGameStart);
    logger.d("GameAction object created: ");
    logger.d(action.actionType);

    // add action to firebase

    // store most recent action id in game state for the player menu
    // when a player was selected in that menu the action document can be
    // updated in firebase with their player_id using the action_id
    logger.d("Adding gameaction to firebase");
    // repository
    //     .addActionToGame(action)
    //     .then((DocumentReference doc) => action.id = doc.id);

    // close action menu
    Navigator.pop(context);
    // if we perform a 7m foul go straight to 7m screen and skip player screen
    if (action.actionType == "foul") {
      logger.d("7m foul. Going to 7m screen");
      // TODO add 7m action data to repository here and not in player screen
      // TODO add action to feedItems (causes an error for some reason)
      //addFeedItem(action);
      callSevenMeterMenu(context, false);
      return;
      // go to player menu for all other actions
    } else {
      callPlayerMenu(context);
    }
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
        logAction();
      });
}
