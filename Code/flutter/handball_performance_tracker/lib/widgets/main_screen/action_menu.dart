import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/data/player.dart';
import 'package:handball_performance_tracker/utils/feed_logic.dart';
import 'package:handball_performance_tracker/utils/player_helper.dart';
import 'package:handball_performance_tracker/widgets/helper_screen/alert_message_widget.dart';
import 'package:handball_performance_tracker/widgets/main_screen/ef_score_bar.dart';
import 'package:handball_performance_tracker/widgets/main_screen/field.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import '../../constants/stringsGameScreen.dart';
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
  final PersistentController persController = Get.find<PersistentController>();

  String actionType = determineActionType();

  // do nothing if goal of others was clicked
  if (actionType == otherGoalkeeper) {
    return;
  }
  StopWatchTimer stopWatchTimer =
      persController.getCurrentGame().stopWatchTimer;
  // if game is not running give a warning
  if (stopWatchTimer.rawTime.value == 0) {
    showDialog(
        context: context,
        builder: (BuildContext bcontext) {
          return AlertDialog(
              scrollable: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(menuRadius),
              ),
              content: CustomAlertMessageWidget(
                  StringsGameScreen.lGameStartErrorMessage));
        });
    return;
  }

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
                width: MediaQuery.of(context).size.width * 0.72,
                height: MediaQuery.of(context).size.height * 0.7,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                          child: Scrollbar(
                        thumbVisibility: true,
                        child: PageView(
                            controller: new PageController(),
                            children:
                                buildPageViewChildren(context, actionType)),
                      )),
                    ] // Column of "Spieler", horizontal line and Button-Row
                    )));
      });
}

/// determine if action was attack, defense, goalkeeper
String determineActionType() {
  logger.d("Determining which actions should be displayed...");
  final TempController tempController = Get.find<TempController>();
  // decide whether attack or defense actions should be displayed depending
  //on what side the team goals is and whether they are attacking or defending
  String actionType = defense;
  bool attackIsLeft = tempController.getAttackIsLeft();
  bool fieldIsLeft = tempController.getFieldIsLeft();
  // when our goal is to the right (= attackIsLeft) and the field is left
  //display attack options
  if (tempController.getLastLocation()[0] == goal) {
    actionType = goalkeeper;
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
  logger.d("Actions should be displayed: $actionType");
  return actionType;
}

// a method for building the children of the pageview in the right order
// by arranging either the attack menu or defense menu first
List<Widget> buildPageViewChildren(BuildContext context, String actionType) {
  if (actionType == goalkeeper) {
    return [
      buildDialogButtonMenu(
          context, actionMapping[goalkeeper]!.keys.toList(), false, true),
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
      buildDialogButton(
          context, buttonTexts[0], Colors.red, 0, Icons.style, ""),
      buildDialogButton(
          context, buttonTexts[1], Colors.yellow, 0, Icons.style, ""),
      buildDialogButton(context, buttonTexts[2],
          Color.fromRGBO(199, 208, 244, 1), 0, Icons.timer, ""),
      buildDialogButton(
          context, buttonTexts[3], Color.fromRGBO(199, 208, 244, 1), 2),
      buildDialogButton(
          context, buttonTexts[4], Color.fromRGBO(199, 208, 244, 1), 2),
      buildDialogButton(
          context, buttonTexts[5], Color.fromRGBO(99, 107, 171, 1)),
      buildDialogButton(
          context, buttonTexts[6], Color.fromRGBO(203, 206, 227, 1)),
      buildDialogButton(
          context, buttonTexts[7], Color.fromRGBO(99, 107, 171, 1)),
      buildDialogButton(
          context, buttonTexts[8], Color.fromRGBO(203, 206, 227, 1)),
    ];
    buttonRow = Row(children: [
      Column(children: [
        Flexible(
          child: Row(
            children: [
              dialogButtons[1],
              dialogButtons[0],
              dialogButtons[2],
            ],
          ),
        ),
        Flexible(child: dialogButtons[3]),
        Flexible(child: dialogButtons[4]),
      ]),
      Flexible(
        child: Column(children: [
          Flexible(child: dialogButtons[5]),
          Flexible(child: dialogButtons[6]),
        ]),
      ),
      Flexible(
        child: Column(
          children: [
            Flexible(child: dialogButtons[7]),
            Flexible(child: dialogButtons[8])
          ],
        ),
      ),
    ]);
    header = StringsGameScreen.lGoalkeeperPopUpHeader;
  } else if (isAttack) {
    List<DialogButton> dialogButtons = [
      buildDialogButton(
          context, buttonTexts[0], Colors.red, 0, Icons.style, ""),
      buildDialogButton(
          context, buttonTexts[1], Colors.yellow, 0, Icons.style, ""),
      buildDialogButton(context, buttonTexts[2],
          Color.fromRGBO(199, 208, 244, 1), 1, Icons.timer),
      buildDialogButton(
        context,
        buttonTexts[3],
        Color.fromRGBO(99, 107, 171, 1),
      ),
      buildDialogButton(
        context,
        buttonTexts[4],
        Color.fromRGBO(99, 107, 171, 1),
      ),
      buildDialogButton(
          context, buttonTexts[5], Color.fromRGBO(199, 208, 244, 1), 1),
      buildDialogButton(
          context, buttonTexts[6], Color.fromRGBO(203, 206, 227, 1)),
      buildDialogButton(
          context, buttonTexts[7], Color.fromRGBO(203, 206, 227, 1))
    ];
    buttonRow =
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Column(children: [
        Row(children: [dialogButtons[1], dialogButtons[0]]),
        Flexible(child: dialogButtons[5]),
        Flexible(child: dialogButtons[2])
      ]),
      Flexible(
        child: Column(
          children: [
            Flexible(child: dialogButtons[6]),
            Flexible(child: dialogButtons[7])
          ],
        ),
      ),
      Flexible(
        child: Column(
          children: [
            Flexible(child: dialogButtons[3]),
            Flexible(child: dialogButtons[4])
          ],
        ),
      ),
    ]);
    header = StringsGameScreen.lOffensePopUpHeader;
  } else {
    List<DialogButton> dialogButtons = [
      buildDialogButton(
          context, buttonTexts[0], Colors.red, 0, Icons.style, ""),
      buildDialogButton(
          context, buttonTexts[1], Colors.yellow, 0, Icons.style, ""),
      buildDialogButton(
          context, buttonTexts[2], Color.fromRGBO(203, 206, 227, 1)),
      buildDialogButton(context, buttonTexts[3],
          Color.fromRGBO(199, 208, 244, 1), 1, Icons.timer),
      buildDialogButton(
          context, buttonTexts[4], Color.fromRGBO(99, 107, 171, 1)),
      buildDialogButton(
          context, buttonTexts[5], Color.fromRGBO(99, 107, 171, 1)),
      buildDialogButton(
          context, buttonTexts[6], Color.fromRGBO(203, 206, 227, 1)),
      buildDialogButton(
          context, buttonTexts[7], Color.fromRGBO(199, 208, 244, 1), 1)
    ];
    buttonRow =
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Column(
        children: [
          Row(children: [dialogButtons[1], dialogButtons[0]]),
          Flexible(child: dialogButtons[7]),
          Flexible(child: dialogButtons[3])
        ],
      ),
      Flexible(
        child: Column(
          children: [
            Flexible(child: dialogButtons[2]),
            Flexible(child: dialogButtons[6])
          ],
        ),
      ),
      Flexible(
        child: Column(
          children: [
            Flexible(child: dialogButtons[4]),
            Flexible(child: dialogButtons[5])
          ],
        ),
      ),
    ]);
    header = StringsGameScreen.lDeffensePopUpHeader;
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
        Align(
          alignment: Alignment.topRight,
          // Change from "" to "Assist" after a goal.
          child: GetBuilder<TempController>(
              id: "action-menu-text",
              builder: (tempController) {
                return Text(
                  tempController.getActionMenuText(),
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Colors.purple,
                    fontSize: 20,
                  ),
                );
              }),
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
    Expanded(child: buttonRow)
  ]);
}

/// @return
/// builds a single dialog button that logs its text (=action) to firestore
//  and updates the game state. Its color and icon can be specified as parameters
// @params - sizeFactor: 0 for small buttons, 1 for middle big buttons, 2 for long buttons, anything else for big buttons
//         - otherText: Text to display if it should not equal the text in actionMapping
DialogButton buildDialogButton(
    BuildContext context, String buttonText, Color buttonColor,
    [sizeFactor, icon, otherText]) {
  TempController tempController = Get.find<TempController>();
  PersistentController persistentController = Get.find<PersistentController>();
  void logAction(String actionType) async {
    logger.d("logging an action");
    DateTime dateTime = DateTime.now();
    int unixTime = dateTime.toUtc().millisecondsSinceEpoch;
    print(persistentController.getCurrentGame().id);
    int secondsSinceGameStart =
        persistentController.getCurrentGame().stopWatchTimer.secondTime.value;
    // get most recent game id from DB
    String currentGameId = persistentController.getCurrentGame().id!;

    // switch field side after hold of goalkeeper
    logger.d("switching field side if applicable");
    if (actionMapping[allActions]![buttonText]! == parade ||
        actionMapping[allActions]![buttonText]! == emptyGoal ||
        actionMapping[allActions]![buttonText]! == goalOthers) {
      while (FieldSwitch.pageController.positions.length > 1) {
        FieldSwitch.pageController
            .detach(FieldSwitch.pageController.positions.first);
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
        type: actionType,
        actionType: actionMapping[allActions]![buttonText]!,
        throwLocation:
            List.from(tempController.getLastLocation().cast<String>()),
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
    if (actionType == goalkeeper) {
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
      logger.d(
          "last action saved in database: ${persistentController.getLastAction().toMap()}");
      if (action.actionType == goal) {
        tempController.incOwnScore();
      } else if (action.actionType == goalOthers ||
          action.actionType == emptyGoal) {
        tempController.incOpponentScore();
      }
    } else {
      persistentController.addAction(action);
    }
    Navigator.pop(context);
    // close action menu if goalkeeper action
    if (actionType != goalkeeper) {
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
            (icon != null) ? Icon(icon) : Container(),
            Text(
              otherText != null ? otherText : buttonText,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 20),
            )
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
      onPressed: () {
        // reset the feed timer
        String actionType = determineActionType();
        logAction(actionType);
      });
}
