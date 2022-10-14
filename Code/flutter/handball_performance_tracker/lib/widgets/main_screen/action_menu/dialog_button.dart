import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/constants/stringsGameScreen.dart';
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
import '../../../constants/positions.dart';
import '../../../utils/field_control.dart';
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

/// @return
/// builds a single dialog button that logs its text (=action) to firestore
//  and updates the game state. Its color and icon can be specified as parameters
// @params - sizeFactor: 0 for small buttons, 1 for middle big buttons, 2 for long buttons, anything else for big buttons
//         - otherText: Text to display if it should not equal the text in actionMapping
class CustomDialogButton extends StatelessWidget {
  final BuildContext buildContext;
  final String buttonText;
  final Color buttonColor;
  int? sizeFactor;
  Icon? icon;
  String? otherText;
  final String actionTag;
  final String actionContext;
  CustomDialogButton(
      {super.key,
      required this.buildContext,
      required this.actionTag,
      required this.actionContext,
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
    void handleAction(String actionTag) async {
      logger.d("logging an action");
      DateTime dateTime = DateTime.now();
      int unixTime = dateTime.toUtc().millisecondsSinceEpoch;
      int secondsSinceGameStart = persistentController.getCurrentGame().stopWatchTimer.secondTime.value;
      // get most recent game id from DB
      String currentGameId = persistentController.getCurrentGame().id!;

      // switch field side after hold of goalkeeper
      if (actionTag == paradeTag || actionTag == emptyGoalTag || actionTag == goalOpponentTag) {
        defensiveFieldSwitch();
      }
      GameAction action = GameAction(
          teamId: tempController.getSelectedTeam().id!,
          gameId: currentGameId,
          context: actionContext,
          tag: actionTag,
          throwLocation: List.from(tempController.getLastLocation().cast<String>()),
          timestamp: unixTime,
          relativeTime: secondsSinceGameStart);
      logger.d("GameAction object created: ${action.tag}");
      // store most recent action id in game state for the player menu
      // when a player was selected in that menu the action document can be
      // updated in firebase with their player_id using the action_id

      // if an action inside goalkeeper menu that does not correspond to the opponent was hit try to assign this action directly to the goalkeeper
      if (actionTag == paradeTag) {
        List<Player> goalKeepers = [];
        tempController.getOnFieldPlayers().forEach((Player player) {
          if (player.positions.contains(goalkeeperPos)) {
            goalKeepers.add(player);
          }
        });
        // if there is only one player with a goalkeeper position on field right now assign the action to him
        if (goalKeepers.length == 1) {
          // we know the player id so we assign it here. For all other actions it is assigned in the player menu
          action.playerId = goalKeepers[0].id!;
          persistentController.addActionToCache(action);
          persistentController.addActionToFirebase(action);
          addFeedItem(action);
          Navigator.pop(context);
          // if there is more than one player with a goalkeeper position on field right now
        } else {
          tempController.setPlayerMenuText(StringsGameScreen.lChooseGoalkeeper);
          logger.d("More than one goalkeeper on field. Waiting for player selection");
          persistentController.addActionToCache(action);
          Navigator.pop(context);
          callPlayerMenu(context);
        }
      }
      if (action.tag == goalTag) {
        tempController.incOwnScore();
      }
      if (action.tag == oneVOneSevenTag) {
        tempController.setPlayerMenuText(StringsGameScreen.lChoose7mReceiver);
      }
      if (action.tag == goalOpponentTag || action.tag == emptyGoalTag) {
        tempController.incOpponentScore();
        // we can add a gameaction here to DB because the player does not need to be selected in the player menu later
        action.playerId = "opponent";
        persistentController.addActionToCache(action);
        persistentController.addActionToFirebase(action);
        addFeedItem(action);
        Navigator.pop(context);
      }
      // don't show player menu if a goalkeeper action or opponent action was logged
      // for all other actions show player menu
      if (actionContext != actionContextGoalkeeper && actionTag != goalOpponentTag) {
        Navigator.pop(context);
        callPlayerMenu(context);
        persistentController.addActionToCache(action);
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
