import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/constants/game_actions.dart';
import 'package:handball_performance_tracker/utils/icons.dart';
import '../../strings.dart';
import 'package:handball_performance_tracker/widgets/main_screen/field.dart';
import 'package:handball_performance_tracker/controllers/persistentController.dart';
import '../../controllers/tempController.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:math';
import '../../utils/feed_logic.dart';
import '../../data/game_action.dart';
import '../../data/player.dart';
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

void callPlayerMenu(context) {
  logger.d("Calling player menu");
  final TempController tempController = Get.find<TempController>();
  List<Obx> dialogButtons = buildDialogButtonList(context);
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
        // upper row: "Spieler" Text on left and "Assist" will pop up on right after a goal.
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                Strings.lPlayer,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              // Change from "" to "Assist" after a goal.
              child: Obx(
                () => Text(
                  tempController.getPlayerMenuText(),
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Colors.purple,
                    fontSize: 20,
                  ),
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
        // Button-Row: one Row with four Columns of one or two buttons

        tempController.getOnFieldPlayers().length == 7
            ? Row(children: [
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
              ])
            : Text("7 Players were not selected. Cannot display this Menu!"),
      ],
    ),
  ).show();
}

/// builds a list of Dialog buttons
List<Obx> buildDialogButtonList(BuildContext context) {
  final TempController tempController = Get.find<TempController>();
  List<Obx> dialogButtons = [];
  for (Player player in tempController.getOnFieldPlayers()) {
    Obx dialogButton = buildDialogButton(context, player);
    dialogButtons.add(dialogButton);
  }
  return dialogButtons;
}

/// builds a single dialog button that logs its text (=player name) to firestore
/// and updates the game state
Obx buildDialogButton(BuildContext context, Player associatedPlayer) {
  String buttonText = associatedPlayer.lastName;
  String buttonNumber = (associatedPlayer.number).toString();
  PersistentController persistentController = Get.find<PersistentController>();
  TempController tempController = Get.find<TempController>();

  // Get width and height, so the sizes can be calculated relative to those. So it should look the same on different screen sizes.
  final double width = MediaQuery.of(context).size.width;
  final double height = MediaQuery.of(context).size.height;

  /// @return "" if action wasn't a goal, "solo" when player scored without
  /// assist and "assist" when player click was assist
  bool _wasAssist() {
    // check if action was a goal
    // if it was a goal allow the player to be pressed twice or select and assist player
    // if the player is clicked again it is a solo action
    if (tempController.getLastClickedPlayer().id == associatedPlayer.id) {
      logger.d("Action was not an assist");
      return false;
    }
    if (tempController.getLastClickedPlayer().id != associatedPlayer.id) {
      logger.d("Action was an assist");
      return true;
    }
    logger.d("Action was not an assist");
    return false;
  }

  void _setFieldBasedOnLastAction(GameAction lastAction) {
    // TODO debug if there are no cases missing here because when you switch back it doesnt get triggered again
    if (lastAction.actionType == goal || lastAction.actionType == errThrow) {
      // if our action is left (page 0) and we are attacking (on page 0) jump back to defense (page 1) after the action
      if (tempController.getFieldIsLeft() == true &&
          tempController.getAttackIsLeft() == true) {
        logger.d("Switching to right field after action");
        while (FieldSwitch.pageController.positions.length > 1) {
          FieldSwitch.pageController
              .detach(FieldSwitch.pageController.positions.first);
        }
        FieldSwitch.pageController.jumpToPage(1);

        // if out action is right (page 1) and we are attacking (on page 1) jump back to defense (page 0) after the action
      } else if (tempController.getFieldIsLeft() == false &&
          tempController.getAttackIsLeft() == false) {
        logger.d("Switching to left field after action");
        while (FieldSwitch.pageController.positions.length > 1) {
          FieldSwitch.pageController
              .detach(FieldSwitch.pageController.positions.first);
        }
        FieldSwitch.pageController.jumpToPage(0);
      }
    } else if (lastAction.actionType == "block_st") {
      // if our action is left (page 0) and we are defensing (on page 0) jump back to attack (page 1) after the action
      if (tempController.getFieldIsLeft() == true &&
          tempController.getAttackIsLeft() == false) {
        logger.d("Switching to right field after action");
        while (FieldSwitch.pageController.positions.length > 1) {
          FieldSwitch.pageController
              .detach(FieldSwitch.pageController.positions.first);
        }
        FieldSwitch.pageController.jumpToPage(1);

        // if out action is right (page 1) and we are defensing (on page 1) jump back to attack (page 0) after the action
      } else if (tempController.getFieldIsLeft() == false &&
          tempController.getAttackIsLeft() == true) {
        logger.d("Switching to left field after action");
        while (FieldSwitch.pageController.positions.length > 1) {
          FieldSwitch.pageController
              .detach(FieldSwitch.pageController.positions.first);
        }
        FieldSwitch.pageController.jumpToPage(0);
      }
    }
  }

  void logPlayerSelection() async {
    logger.d("Logging the player selection");
    GameAction lastAction = persistentController.getLastAction();
    Player lastClickedPlayer = tempController.getLastClickedPlayer();
    // if goal was pressed but no player was selected yet
    //(lastClickedPlayer is default Player Object) do nothing
    if (lastAction.actionType == "goal" && lastClickedPlayer.id! == "") {
      tempController.updatePlayerMenuText();
      // update last Clicked player value with the Player from selected team
      // who was clicked
      tempController.setLastClickedPlayer(
          tempController.getPlayerFromSelectedTeam(associatedPlayer.id!));
      return;
    }
    // if goal was pressed and a player was already clicked once
    if (lastAction.actionType == "goal") {
      // update data for person that shot the goal
      persistentController.setLastActionPlayer(lastClickedPlayer);
      tempController.updatePlayerEfScore(lastClickedPlayer.id!, persistentController.getLastAction());
      addFeedItem(persistentController.getLastAction());
      // add goal to feed
      // if it was a solo goal the action type has to be updated to "Tor Solo"
      if (!_wasAssist()) {
        logger.d("Logging solo goal for ${lastClickedPlayer.lastName}");
      } else {
        logger.d(
            "Logging goal of ${lastClickedPlayer.lastName} with assist from ${associatedPlayer.lastName}");
        // deep clone a new action from the most recent action
        GameAction assistAction = GameAction.clone(lastAction);
        // person that scored assist
        Player assistPlayer = associatedPlayer;
        assistAction.actionType = "assist";
        await persistentController.addAction(assistAction);
        persistentController.setLastActionPlayer(assistPlayer);
        tempController.updatePlayerEfScore(assistPlayer.id!, persistentController.getLastAction());
        logger.d("assist action: ${assistAction.toMap()}");
        // add assist to the feed
        addFeedItem(assistAction);
      }
    } else {
      logger.d(
          "Logging ${lastAction.actionType} of ${associatedPlayer.lastName}");
      // if the action was not a goal just update the player id in firebase and gamestate
      persistentController.setLastActionPlayer(associatedPlayer);
      tempController.updatePlayerEfScore(associatedPlayer.id!, persistentController.getLastAction());
      // add action to feed
      addFeedItem(persistentController.getLastAction());
    }
    logger.d(
        "last action saved in database: ${persistentController.getLastAction().toMap()}");
    // reset last clicked player
    tempController.setLastClickedPlayer(Player());
    _setFieldBasedOnLastAction(lastAction);
    Navigator.pop(context);
  }

  // Button with shirt with buttonNumber inside and buttonText below.
  // Obx so the color changes if player == goalscorer,
  return Obx(() {
    // Dialog button that shows "No Assist" instead of the player name and shirt
    // at the place where the first player was clicked
    if (tempController.getLastClickedPlayer().lastName == buttonText) {
      return DialogButton(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                Strings.lNoAssist,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: (width * 0.03),
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Shirt
            ],
          ),
          // have some space between the buttons
          margin: EdgeInsets.all(min(height, width) * 0.013),
          // have round edges with same degree as Alert dialog
          radius: const BorderRadius.all(Radius.circular(15)),
          // set height and width of buttons so the shirt and name are fitting inside
          height: width * 0.14,
          width: width * 0.14,
          color: tempController.getLastClickedPlayer() == associatedPlayer
              ? Colors.purple
              : Color.fromARGB(255, 180, 211, 236),
          onPressed: () {
            logPlayerSelection();
          });
    }
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
        color: tempController.getLastClickedPlayer() == associatedPlayer
            ? Colors.purple
            : Color.fromARGB(255, 180, 211, 236),
        onPressed: () {
          logPlayerSelection();
        });
  });
}
