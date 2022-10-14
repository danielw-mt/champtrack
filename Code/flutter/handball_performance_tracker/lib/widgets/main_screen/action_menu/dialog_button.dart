import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/data/player.dart';
import 'package:handball_performance_tracker/utils/feed_logic.dart';
import 'package:handball_performance_tracker/utils/player_helper.dart';
import 'package:handball_performance_tracker/widgets/main_screen/field.dart';
import '../../../controllers/persistentController.dart';
import '../../../controllers/tempController.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../../data/game_action.dart';
import '../../../constants/game_actions.dart';
import '../playermenu.dart';
import 'dart:math';

/// @return
/// builds a single dialog button that logs its text (=action) to firestore
//  and updates the game state. Its color and icon can be specified as parameters
// @params - sizeFactor: 0 for small buttons, 1 for middle big buttons, 2 for long buttons, anything else for big buttons
//         - otherText: Text to display if it should not equal the text in actionMapping
class CustomDialogButton extends StatelessWidget {
  final BuildContext context;
  final String buttonText;
  final Color buttonColor;
  int? sizeFactor;
  Icon? icon;
  String? otherText;
  final String actionTag;
  CustomDialogButton(
      {super.key,
      required this.context,
      this.actionTag = "red",
      this.buttonText = "",
      this.buttonColor = Colors.blue,
      this.sizeFactor,
      this.icon,
      this.otherText});

  @override
  Widget build(BuildContext context) {
    print("building button $buttonText");
    TempController tempController = Get.find<TempController>();
    PersistentController persistentController = Get.find<PersistentController>();
    void handleAction(String actionType) async {
      logger.d("logging an action");
      DateTime dateTime = DateTime.now();
      int unixTime = dateTime.toUtc().millisecondsSinceEpoch;
      print(persistentController.getCurrentGame().id);
      int secondsSinceGameStart = persistentController.getCurrentGame().stopWatchTimer.secondTime.value;
      // get most recent game id from DB
      String currentGameId = persistentController.getCurrentGame().id!;

      // switch field side after hold of goalkeeper
      logger.d("switching field side if applicable");
      if (actionMapping[actionStateAllActions]![buttonText]! == parade ||
          actionMapping[actionStateAllActions]![buttonText]! == emptyGoal ||
          actionMapping[actionStateAllActions]![buttonText]! == goalOthers) {
        while (FieldSwitch.pageController.positions.length > 1) {
          FieldSwitch.pageController.detach(FieldSwitch.pageController.positions.first);
        }
        if (tempController.getAttackIsLeft() == true) {
          logger.d("Switching to left field after hold");
          FieldSwitch.pageController.jumpToPage(0);
        } else {
          logger.d("Switching to right field after hold");
          FieldSwitch.pageController.jumpToPage(1);
        }
      }
      GameAction action = GameAction(
          teamId: tempController.getSelectedTeam().id!,
          gameId: currentGameId,
          tag: actionType,
          actionType: actionMapping[actionStateAllActions]![buttonText]!,
          throwLocation: List.from(tempController.getLastLocation().cast<String>()),
          timestamp: unixTime,
          relativeTime: secondsSinceGameStart);
      logger.d("GameAction object created: ${action.actionType}");
      logger.d(action.actionType);

      // add action to firebase

      // store most recent action id in game state for the player menu
      // when a player was selected in that menu the action document can be
      // updated in firebase with their player_id using the action_id
      logger.d("Adding gameaction to firebase");
      // Save action directly if goalkeeper action
      if (actionType == actionStateGoalkeeper) {
        String? goalKeeperId = "goalkeeper";
        // get id of goalkeeper by going through players on field and searching for position
        for (int k in getOnFieldIndex()) {
          Player player = tempController.getPlayersFromSelectedTeam()[k];
          if (player.positions.contains("TW")) {
            goalKeeperId = player.id;
            break;
          }
        }

        action.playerId = goalKeeperId.toString();
        persistentController.addAction(action);
        addFeedItem(action);
        logger.d("last action saved in database: ${persistentController.getLastAction().toMap()}");
        if (action.actionType == goal) {
          tempController.incOwnScore();
        } else if (action.actionType == goalOthers || action.actionType == emptyGoal) {
          tempController.incOpponentScore();
        }
      } else {
        persistentController.addAction(action);
      }
      Navigator.pop(context);
      // close action menu if goalkeeper action
      if (actionType != actionStateGoalkeeper) {
        print("stepping in here: $actionType");
        callPlayerMenu(context);
      }
    }

    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    double buttonWidth;
    double buttonHeight;
    if (sizeFactor == 0) {
      // Small buttons, eg red and yellow card
      buttonWidth = width * 0.07;
      buttonHeight = buttonWidth;
    } else if (sizeFactor == 1) {
      // Middle big buttons, eg 2m
      buttonWidth = width * 0.13;
      buttonHeight = buttonWidth;
    } else if (sizeFactor == 2) {
      // Long buttons like in goalkeeper menu
      buttonWidth = width * 0.25;
      buttonHeight = width * 0.17;
    // if no size factor provided
    } else {
      // Big buttons like goal
      buttonWidth = width * 0.17;
      buttonHeight = buttonWidth;
    }
    return DialogButton(
        margin: sizeFactor == 0 // less margin for smallest buttons
            ? EdgeInsets.all(min(height, width) * 0.013)
            : EdgeInsets.all(min(height, width) * 0.02),
        // have round edges with same degree as Alert dialog
        radius: const BorderRadius.all(Radius.circular(15)),
        // set height and width of buttons so the shirt and name are fitting inside
        height: buttonHeight,
        width: buttonWidth,
        color: buttonColor,
        child: Center(
          child: Column(
            children: [
              // if icon is null use a container
              icon ?? Container(),
              Text(
                // if otherText is null use buttonText
                otherText ?? buttonText,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 20),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
        onPressed: () {
          // reset the feed timer
          handleAction(actionTag);
        });
  }
}
