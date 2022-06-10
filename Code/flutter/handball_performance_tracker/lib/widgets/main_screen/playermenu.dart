import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/utils/icons.dart';
import 'package:handball_performance_tracker/data/database_repository.dart';
import 'package:handball_performance_tracker/data/game.dart';
import 'package:handball_performance_tracker/utils/player_helper.dart';
import '../../controllers/globalController.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:math';
import '../../utils/feed_logic.dart';
import '../../data/game_action.dart';
import '../../data/player.dart';

void callPlayerMenu(context) {
  final GlobalController globalController = Get.find<GlobalController>();
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
                "Spieler",
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
                  globalController.playerMenuText.value,
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
        // TODO: implement safety check if less than 7 players are somehow selected
        Row(children: [
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
        ]),
      ],
    ),
  ).show();
}

/// builds a list of Dialog buttons
List<Obx> buildDialogButtonList(BuildContext context) {
  final GlobalController globalController = Get.find<GlobalController>();
  List<Obx> dialogButtons = [];
  for (Player player in globalController.selectedTeam.value.onFieldPlayers) {
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
  final GlobalController globalController = Get.find<GlobalController>();
  DatabaseRepository repository = globalController.repository;

  // Get width and height, so the sizes can be calculated relative to those. So it should look the same on different screen sizes.
  final double width = MediaQuery.of(context).size.width;
  final double height = MediaQuery.of(context).size.height;

  /// @return "" if action wasn't a goal, "solo" when player scored without
  /// assist and "assist" when player click was assist
  bool _wasAssist() {
    // check if action was a goal
    // if it was a goal allow the player to be pressed twice or select and assist player
    // if the player is clicked again it is a solo action
    if (globalController.lastClickedPlayer.value.id == associatedPlayer.id) {
      return false;
    }
    if (globalController.lastClickedPlayer.value.id != associatedPlayer.id) {
      return true;
    }
    return false;
  }

  // Player? _getPlayerFromName(String name) {
  //   for (Player player in globalController.chosenPlayers) {
  //     if (player.lastName == name) {
  //       return player;
  //     }
  //   }
  // }

  void logPlayerSelection() async {
    GameAction lastAction = globalController.actions.last;
    String? lastClickedPlayerId = globalController.lastClickedPlayer.value.id;
    lastAction.playerId = lastClickedPlayerId.toString();
    // if goal was pressed but no player was selected yet
    //(lastClickedPlayer is default Player Object) do nothing
    if (lastAction.actionType == "goal" && lastClickedPlayerId == "") {
      print("goal player clicked once");
      globalController.updatePlayerMenuText();
      // update last Clicked player value with the Player from selected team
      // who was clicked
      globalController.lastClickedPlayer.value = globalController
          .selectedTeam.value.players
          .where((Player playerItem) => (playerItem.id == associatedPlayer.id))
          .first;
      globalController.refresh();
      return;
    }
    // if goal was pressed and a player was already clicked once
    if (lastAction.actionType == "goal") {
      // if it was a solo goal the action type has to be updated to "Tor Solo"
      if (!_wasAssist()) {
        print("solo goal");
        // update data for person that shot the goal
        lastAction.playerId = lastClickedPlayerId!;
        repository.updateAction(lastAction);
        globalController.actions.last = lastAction;
        // update player's ef-score
        // TODO implement this
        //activePlayer.addAction(lastAction);

        globalController.lastClickedPlayer.value = Player();
        addFeedItem(lastAction);
        globalController.refresh();
      } else {
        // if it was an assist update data for both players
        // person that scored goal
        lastAction.playerId = lastClickedPlayerId!;
        repository.updateAction(lastAction);
        globalController.actions.last = lastAction;
        // person that scored assist
        // deep clone a new action from the most recent action

        print("assist action: ${GameAction.clone(lastAction)}");
        GameAction assistAction = GameAction.clone(lastAction);
        print("assist action: $assistAction");
        Player assistPlayer = associatedPlayer;
        assistAction.playerId = assistPlayer.id!;
        assistAction.actionType = "assist";
        repository.addActionToGame(assistAction);
        globalController.actions.add(assistAction);

        // add assist first to the feed and then the goal
        addFeedItem(assistAction);
        addFeedItem(lastAction);
        // update player's ef-score
        // TODO implement this
        //assistPlayer.addAction(lastAction);

        globalController.lastClickedPlayer.value = Player();
      }
    } else {
      // if the action was not a goal just update the player id in firebase and gamestate
      lastAction.playerId = lastClickedPlayerId!;
      globalController.actions.last = lastAction;
      repository.updateAction(lastAction);
      addFeedItem(lastAction);
      // update player's ef-scorer
      // TODO implement this
      // activePlayer.addAction(lastAction);

      globalController.lastClickedPlayer.value = Player();
    }
    // addFeedItem(lastAction);
    print("last action saved in database: ");
    print(globalController.actions.last.toMap());
    globalController.refresh();
    Navigator.pop(context);
  }

  // Button with shirt with buttonNumber inside and buttonText below.
  // Obx so the color changes if player == goalscorer,
  return Obx(() {
    // Dialog button that shows "No Assist" instead of the player name and shirt
    // at the place where the first player was clicked
    if (globalController.lastClickedPlayer.value.lastName == buttonText) {
      return DialogButton(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "No Assist",
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
          color: globalController.lastClickedPlayer.value == associatedPlayer
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
        color: globalController.lastClickedPlayer.value == associatedPlayer
            ? Colors.purple
            : Color.fromARGB(255, 180, 211, 236),
        onPressed: () {
          logPlayerSelection();
        });
  });
}
