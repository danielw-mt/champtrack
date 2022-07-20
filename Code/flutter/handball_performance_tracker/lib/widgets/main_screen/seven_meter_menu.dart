import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/constants/stringsGeneral.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/data/player.dart';
import 'package:handball_performance_tracker/utils/feed_logic.dart';
import 'package:handball_performance_tracker/utils/player_helper.dart';
import 'package:handball_performance_tracker/widgets/main_screen/ef_score_bar.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../constants/stringsGameScreen.dart';
import '../../data/game_action.dart';
import '../../constants/game_actions.dart';
import '../../controllers/tempController.dart';
import '../../controllers/persistentController.dart';
import 'dart:math';
import 'package:logger/logger.dart';
import '../../utils/field_control.dart';

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

void callSevenMeterMenu(BuildContext context, bool belongsToHomeTeam) {
  logger.d("Calling 7m menu");

  showDialog(
      context: context,
      builder: (BuildContext bcontext) {
        return AlertDialog(
            scrollable: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(menuRadius),
            ),

            // alert contains a list of DialogButton objects
            content: Container(
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.height * 0.4,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                          child: buildDialogButtonMenu(
                              context, belongsToHomeTeam)),
                    ] // Column of "Spieler", horizontal line and Button-Row
                    )));
      });
}

/// @return true if attacking false if defending
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

/// @return a menu of the 2 7 meter outcomes with different text depending
/// whether it belongs to the home team or opponent team
Widget buildDialogButtonMenu(BuildContext context, bool belongsToHomeTeam) {
  List<DialogButton> dialogButtons = [];
  if (belongsToHomeTeam) {
    dialogButtons = [
      buildDialogButton(
          context,
          actionMapping[seven_meter]!.values.toList()[0],
          actionMapping[seven_meter]!.keys.toList()[0],
          Colors.lightBlue,
          Icons.style),
      buildDialogButton(
          context,
          actionMapping[seven_meter]!.values.toList()[1],
          actionMapping[seven_meter]!.keys.toList()[1],
          Colors.deepPurple,
          Icons.style),
    ];
  } else {
    dialogButtons = [
      buildDialogButton(
          context,
          actionMapping[seven_meter]!.values.toList()[2],
          actionMapping[seven_meter]!.keys.toList()[2],
          Colors.red,
          Icons.style),
      buildDialogButton(
          context,
          actionMapping[seven_meter]!.values.toList()[3],
          actionMapping[seven_meter]!.keys.toList()[3],
          Colors.yellow,
          Icons.style)
    ];
  }
  return Column(children: [
    Row(
      children: [Icon(Icons.sports_handball), Text(StringsGeneral.lSevenMeter)],
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            StringsGameScreen.lOffensePopUpHeader,
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
    Row(children: [dialogButtons[0], dialogButtons[1]])
  ]);
}

/// @return
/// builds a single dialog button that logs its text (=action) to firestore
//  and updates the game state. Its color and icon can be specified as parameters
DialogButton buildDialogButton(
    BuildContext context, String actionType, String buttonText, Color color,
    [icon]) {
  final PersistentController persistentController =
      Get.find<PersistentController>();
  final TempController tempController = Get.find<TempController>();
  void logAction() async {
    logger.d("logging an action");
    DateTime dateTime = DateTime.now();
    int unixTime = dateTime.toUtc().millisecondsSinceEpoch;
    int secondsSinceGameStart =
        persistentController.getCurrentGame().stopWatch.secondTime.value;

    // get most recent game id from DB
    String currentGameId = persistentController.getCurrentGame().id!;

    GameAction action = GameAction(
        teamId: tempController.getSelectedTeam().id!,
        gameId: currentGameId,
        type: determineAttack() ? 'attack' : 'defense',
        actionType: actionType,
        throwLocation: tempController.getLastLocation().cast<String>(),
        timestamp: unixTime,
        relativeTime: secondsSinceGameStart);
    logger.d("GameAction object created: ");
    logger.d(action);
    Player activePlayer;
    if (actionType == goal || actionType == missed7m) {
      // own player did 7m
      activePlayer = tempController.getLastClickedPlayer();
      tempController.setLastClickedPlayer(Player());
    } else {
      // opponent player did 7m
      // get id of goalkeeper by going through players on field and searching for position
      Player goalKeeperId = tempController.getPlayersFromSelectedTeam()[0];
      for (int k in getOnFieldIndex()) {
        Player player = tempController.getPlayersFromSelectedTeam()[k];
        if (player.positions.contains("TW")) {
          goalKeeperId = player;
          break;
        }
      }
      activePlayer = goalKeeperId;
    }
    // add action to firebase
    persistentController.addAction(action);
    persistentController.setLastActionPlayer(activePlayer);

    tempController.updatePlayerEfScore(
        activePlayer.id!, persistentController.getLastAction());
    // add action to feed
    addFeedItem(action);

    // goal
    if (actionType == actionMapping[seven_meter]!.values.toList()[0]) {
      tempController.incOwnScore();
      offensiveFieldSwitch();
    }
    // missed 7m
    if (actionType == actionMapping[seven_meter]!.values.toList()[1]) {
      offensiveFieldSwitch();
    }
    // opponent goal
    if (actionType == actionMapping[seven_meter]!.values.toList()[2]) {
      tempController.incOpponentScore();
      defensiveFieldSwitch();
    }
    // opponent missed
    if (actionType == actionMapping[seven_meter]!.values.toList()[3]) {
      defensiveFieldSwitch();
    }
  }

  final double width = MediaQuery.of(context).size.width;
  final double height = MediaQuery.of(context).size.height;
  return DialogButton(
      margin: EdgeInsets.all(min(height, width) * 0.013),
      // have round edges with same degree as Alert dialog
      radius: const BorderRadius.all(Radius.circular(15)),
      // set height and width of buttons so the shirt and name are fitting inside
      height: width * 0.15,
      width: width * 0.15,
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
        tempController.setPlayerMenutText("");
      });
}
