import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/constants/game_actions.dart';
import 'package:handball_performance_tracker/utils/field_control.dart';
import 'package:handball_performance_tracker/utils/icons.dart';
import 'package:handball_performance_tracker/utils/player_helper.dart';
import 'package:handball_performance_tracker/widgets/main_screen/ef_score_bar.dart';
import 'package:handball_performance_tracker/widgets/main_screen/seven_meter_menu.dart';
import '../../constants/stringsGeneral.dart';
import '../../constants/stringsGameScreen.dart';
import 'package:handball_performance_tracker/widgets/main_screen/seven_meter_player_menu.dart';
import 'package:handball_performance_tracker/widgets/main_screen/field.dart';
import 'package:handball_performance_tracker/controllers/persistent_controller.dart';
import '../../controllers/temp_controller.dart';
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

// Variable is true if the player menu is open. After a player was selected and Navigator.pop
// is called, it is set to false. This is used to know if the menu closes without choosing a player
// by clicking just anywhere in the screen.
bool playerChanged = false;

void callPlayerMenu(context, [substitute_menu]) {
  PageController pageController = PageController();
  logger.d("Calling player menu");
  final TempController tempController = Get.find<TempController>();
  showDialog(
          context: context,
          builder: (BuildContext bcontext) {
            return AlertDialog(
              scrollable: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(menuRadius),
              ),
              // alert contains a list of DialogButton objects
              content:
                  // Column of "Player", horizontal line and Button-Row
                  Column(
                children: [
                  // upper row: "Player" Text on left and "Assist" will pop up on right after a goal.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          StringsGeneral.lPlayer,
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
                            id: "player-menu-text",
                            builder: (tempController) {
                              return Text(
                                substitute_menu == null
                                    ? tempController.getPlayerMenuText()
                                    : StringsGameScreen.lSubstitute,
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
                  // Substitute player text
                  Text(
                    substitute_menu == null
                        ? ""
                        : StringsGameScreen.lSubstitute1 +
                            tempController.getPlayersToChange()[0].lastName +
                            StringsGameScreen.lSubstitute2,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  // Button-Row: one Row with four Columns of one or two buttons
                  Scrollbar(
                    controller: pageController,
                    thumbVisibility: true,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.65,
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: Expanded(
                        child: PageView(
                          controller: pageController,
                          children:
                              buildPageViewChildren(bcontext, substitute_menu),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          })
      // When closing set player menu text to ""
      // if just pressed anywhere in screen)
      .then((_) {
    tempController.setPlayerMenuText("");
    tempController.setPreviousClickedPlayer(Player());
    (!playerChanged && substitute_menu != null)
        ? tempController.getLastPlayerToChange()
        : null; // delete player to change from list if player menu was closed
    playerChanged = false;
  });
  ;
}

// a method for building the children of the pageview with players on field on the first page and all others on the next.
List<Widget> buildPageViewChildren(BuildContext context, [substitute_menu]) {
  final TempController tempController = Get.find<TempController>();
  List<GetBuilder<TempController>> onFieldButtons =
      buildDialogButtonOnFieldList(context, substitute_menu);
  List<GetBuilder<TempController>> notOnFieldButtons =
      buildDialogButtonNotOnFieldList(context);

  // Build content for on field player page
  List<Widget> onFieldDisplay = [];
  for (int i = 0; i < tempController.getOnFieldPlayers().length - 1; i++) {
    onFieldDisplay.add(Flexible(
      child: Column(
        children: [onFieldButtons[i], onFieldButtons[i + 1]],
      ),
    ));
    i++;
  }
  // If number of player uneven, add the last which is not inside a row.
  if (tempController.getOnFieldPlayers().length % 2 != 0) {
    onFieldDisplay
        .add(onFieldButtons[tempController.getOnFieldPlayers().length - 1]);
  }

  // Build content for not on field player page
  List<Widget> notOnFieldDisplay = [];
  for (int i = 0; i < notOnFieldButtons.length - 1; i++) {
    notOnFieldDisplay.add(Flexible(
      child: Column(
        children: [notOnFieldButtons[i], notOnFieldButtons[i + 1]],
      ),
    ));
    i++;
  }
  // If number of player uneven, add the last which is not inside a row.
  if (notOnFieldButtons.length % 2 != 0) {
    notOnFieldDisplay
        .add(Flexible(child: notOnFieldButtons[notOnFieldButtons.length - 1]));
  }

  List<Widget> buttonRow = (substitute_menu == null)
      ? [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: onFieldDisplay),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: notOnFieldDisplay),
        ]
      : [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: onFieldDisplay),
        ];
  return buttonRow;
}

/// builds a list of Dialog buttons with players which are not on field
List<GetBuilder<TempController>> buildDialogButtonNotOnFieldList(
    BuildContext context) {
  final TempController tempController = Get.find<TempController>();
  List<GetBuilder<TempController>> dialogButtons = [];
  for (int i = 0; i < tempController.getSelectedTeam().players.length; i++) {
    if (tempController
            .getSelectedTeam()
            .onFieldPlayers
            .contains(tempController.getSelectedTeam().players[i]) ==
        false) {
      GetBuilder<TempController> dialogButton = buildDialogButton(
          context, tempController.getSelectedTeam().players[i], null, true);
      dialogButtons.add(dialogButton);
    }
  }
  return dialogButtons;
}

/// builds a list of Dialog buttons with players which are on field
List<GetBuilder<TempController>> buildDialogButtonOnFieldList(
    BuildContext context,
    [substitute_menu]) {
  final TempController tempController = Get.find<TempController>();
  List<GetBuilder<TempController>> dialogButtons = [];
  for (Player player in tempController.getOnFieldPlayers()) {
    GetBuilder<TempController> dialogButton =
        buildDialogButton(context, player, substitute_menu);
    dialogButtons.add(dialogButton);
  }
  return dialogButtons;
}

/// builds a single dialog button that logs its text (=player name) to firestore
/// and updates the game state
GetBuilder<TempController> buildDialogButton(
    BuildContext context, Player playerFromButton,
    [substitute_menu, isNotOnField]) {
  String buttonText = playerFromButton.lastName;
  String buttonNumber = (playerFromButton.number).toString();
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
    if (tempController.getPreviousClickedPlayer().id == playerFromButton.id) {
      logger.d("Action was not an assist");
      return false;
    }
    if (tempController.getPreviousClickedPlayer().id != playerFromButton.id) {
      logger.d("Action was an assist");
      return true;
    }
    logger.d("Action was not an assist");
    return false;
  }

  void _setFieldBasedOnLastAction(GameAction lastAction) {
    if (lastAction.tag == goalTag ||
        lastAction.tag == missTag ||
        lastAction.tag == trfTag) {
      offensiveFieldSwitch();
    } else if (lastAction.tag == blockAndStealTag) {
      defensiveFieldSwitch();
    }
  }

  void handlePlayerSelection() async {
    logger.d("Logging the player selection");
    GameAction lastAction = persistentController.getLastAction();
    logger.d("Last action was: " + lastAction.toString());
    Player previousClickedPlayer = tempController.getPreviousClickedPlayer();
    logger
        .d("Previous clicked player was: " + previousClickedPlayer.toString());
    // if goal was pressed but no player was selected yet
    //(lastClickedPlayer is default Player Object) do nothing
    if (lastAction.tag == goalTag && previousClickedPlayer.id! == "") {
      tempController.setPlayerMenuText("Assist");
      // update last Clicked player value with the Player from selected team
      // who was clicked
      tempController.setPreviousClickedPlayer(
          tempController.getPlayerFromSelectedTeam(playerFromButton.id!));
      return;
    }
    // if goal was pressed and a player was already clicked once
    if (lastAction.tag == goalTag) {
      logger.d("goal selected");
      // if it was a solo goal the action type has to be updated to "Tor Solo"
      persistentController.setLastActionPlayer(previousClickedPlayer);
      tempController.updatePlayerEfScore(
          previousClickedPlayer.id!, persistentController.getLastAction());
      addFeedItem(persistentController.getLastAction());
      tempController.incOwnScore();
      // add goal to feed
      // if it was a solo goal the action type has to be updated to "Tor Solo"

      if (!_wasAssist()) {
        logger.d("Logging solo goal");
        // don't need to do anything because ID was already set above
      } else {
        logger.d("Logging goal with assist");
        // person that scored assist
        // deep clone a new action from the most recent action
        GameAction assistAction = GameAction.clone(lastAction);
        print("assist action: $assistAction");
        assistAction.tag = assistTag;
        persistentController.addActionToCache(assistAction);
        Player assistPlayer = playerFromButton;
        assistAction.playerId = assistPlayer.id!;
        persistentController.setLastActionPlayer(assistPlayer);
        tempController.updatePlayerEfScore(
            assistPlayer.id!, persistentController.getLastAction());

        // add assist first to the feed and then the goal
        addFeedItem(assistAction);
        tempController.setPreviousClickedPlayer(Player());
      }
    } else {
      // if the action was not a goal just update the player id in firebase and gamestate
      persistentController.setLastActionPlayer(playerFromButton);
      tempController.setPreviousClickedPlayer(playerFromButton);
      tempController.updatePlayerEfScore(
          playerFromButton.id!, persistentController.getLastAction());
      // add action to feed
      lastAction.playerId = playerFromButton.id!;
      addFeedItem(persistentController.getLastAction());
      persistentController.addActionToCache(lastAction);
    }

    ///
    // start: time penalty logic
    // if you click on a penalized player the time penalty is removed
    ///
    if (tempController.isPlayerPenalized(playerFromButton)) {
      tempController.removePenalizedPlayer(playerFromButton);
    }
    if (lastAction.tag == timePenaltyTag) {
      Player player = tempController.getPreviousClickedPlayer();
      tempController.addPenalizedPlayer(player);
      logger.d("Penality for player: " + player.id.toString());
    }

    ///
    // end: time penalty logic
    ///

    // Check if associated player or lastClickedPlayer are notOnFieldPlayer. If yes, player menu appears to change the player.
    // We can click on not on field players if we swipe on the player menu and all the player not on field will be shown.
    if (!tempController.getOnFieldPlayers().contains(playerFromButton)) {
      tempController.addPlayerToChange(playerFromButton);
    }
    if (!tempController.getOnFieldPlayers().contains(previousClickedPlayer) &&
        !(previousClickedPlayer.id! == "")) {
      tempController.addPlayerToChange(previousClickedPlayer);
    }
    _setFieldBasedOnLastAction(lastAction);
    // If there are still player to change, open the player menu again but as a substitue player menu (true flag)
    if (!tempController.getPlayersToChange().isEmpty) {
      Navigator.pop(context);
      callPlayerMenu(context, true);
      return;
    }

    // if we get a 7m in our favor call the seven meter menu for us
    if (lastAction.tag == oneVOneSevenTag) {
      logger.d("1v1 detected => 7m menu");
      Navigator.pop(context);
      callSevenMeterPlayerMenu(context);
      return;
    }
    // if we perform a 7m foul call the seven meter menu for the other team
    else if (lastAction.tag == foulSevenMeterTag) {
      logger.d("7m foul. Going to 7m screen");
      Navigator.pop(context);
      callSevenMeterMenu(context, false);
      return;
    }
    // reset last clicked player and player menu hint text
    tempController.setPreviousClickedPlayer(Player());
    tempController.setPlayerMenuText("");
    Navigator.pop(context);
  }

  // function which is called is substitute_player param is not null
  // after a player was chosen for an action who is not on field
  void substitutePlayer() {
    playerChanged = true;
    // get player which was pressed in player menu in tempController.getOnFieldPlayers()
    Player playerToChange = tempController.getLastPlayerToChange();

    // Update player bar players
    int l = tempController.getPlayersFromSelectedTeam().indexOf(playerToChange);
    int k =
        tempController.getPlayersFromSelectedTeam().indexOf(playerFromButton);
    int indexToChange = tempController.getPlayerBarPlayers().indexOf(k);
    tempController.changePlayerBarPlayers(indexToChange, l);
    // Change the player which was pressed in player menu in tempController.getOnFieldPlayers()
    // to the player which was pressed in popup dialog.
    tempController.setOnFieldPlayer(
        tempController.getOnFieldPlayers().indexOf(playerFromButton),
        playerToChange,
        Get.find<PersistentController>().getCurrentGame());

    tempController.setPlayerMenuText("");
    Navigator.pop(context);
  }

  // Button with shirt with buttonNumber inside and buttonText below.
  // Getbuilder so the color changes if player == goalscorer,
  return GetBuilder<TempController>(
      id: "player-menu-button",
      builder: (tempController) {
        Color buttonColor = Color(0);
        if (tempController.getPreviousClickedPlayer() == playerFromButton) {
          buttonColor = Colors.purple;
        } else if (tempController.isPlayerPenalized(playerFromButton)) {
          buttonColor = Colors.grey;
        } else {
          buttonColor = Color.fromARGB(255, 180, 211, 236);
        }
        // Dialog button that shows "No Assist" instead of the player name and shirt
        // at the place where the first player was clicked
        if (tempController.getPreviousClickedPlayer().lastName == buttonText) {
          return DialogButton(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    StringsGameScreen.lNoAssist,
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
              color: buttonColor,
              onPressed: () {
                handlePlayerSelection();
              });
        } else {
          return DialogButton(
              child:
                  // Column with 2 entries: 1. a Stack with Shirt & buttonNumber and 2. buttonText
                  Flexible(
                child: Column(
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
                            // make shirt smaller if there are more than 7 player displayed
                            size: (isNotOnField == null ||
                                    getNotOnFieldIndex().length <= 7)
                                ? (width * 0.11)
                                : (width *
                                    0.11 /
                                    getNotOnFieldIndex().length *
                                    7),
                          ),
                        ),
                      ],
                    ),
                    // ButtonName
                    Text(
                      buttonText,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: (width * 0.02),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // have some space between the buttons
              margin: EdgeInsets.all(min(height, width) * 0.013),
              // have round edges with same degree as Alert dialog
              radius: const BorderRadius.all(Radius.circular(15)),
              // set height and width of buttons so the shirt and name are fitting inside
              height: width * 0.14,
              width: width * 0.14,
              color: buttonColor,
              onPressed: () {
                (substitute_menu == null)
                    ? handlePlayerSelection()
                    : substitutePlayer();
              });
        }
      });
}
