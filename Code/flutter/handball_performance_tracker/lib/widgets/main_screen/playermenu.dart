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
  for (int i in getOnFieldIndex()) {
    Player player = globalController.chosenPlayers[i];
    Obx dialogButton = buildDialogButton(context, player);
    dialogButtons.add(dialogButton);
  }
  return dialogButtons;
}

/// builds a single dialog button that logs its text (=player name) to firestore
/// and updates the game state
Obx buildDialogButton(BuildContext context, Player player) {
  String buttonText = player.name;
  String buttonNumber = (player.number).toString();
  final GlobalController globalController = Get.find<GlobalController>();
  DatabaseRepository repository = DatabaseRepository();

  // Get width and height, so the sizes can be calculated relative to those. So it should look the same on different screen sizes.
  final double width = MediaQuery.of(context).size.width;
  final double height = MediaQuery.of(context).size.height;

  /// @return "" if action wasn't a goal, "solo" when player scored without
  /// assist and "assist" when player click was assist
  bool _wasAssist() {
    // check if action was a goal
    // if it was a goal allow the player to be pressed twice or select and assist player
    // if the player is clicked again it is a solo action
    if (globalController.lastClickedPlayer.value.name == buttonText) {
      return false;
    }
    if (globalController.lastClickedPlayer.value.name != buttonText) {
      return true;
    }
    return false;
  }

  Player? _getPlayerFromName(String name) {
    for (Player player in globalController.chosenPlayers) {
      if (player.name == name) {
        return player;
      }
    }
  }

  void logPlayerSelection() async {
    GameAction lastAction = globalController.actions.last;
    print("last action");
    String? activePlayerId = globalController.lastClickedPlayer.value.id;

    // if goal was pressed but no player was selected yet, do nothing
    if (lastAction.actionType == "goal" && activePlayerId == null) {
      globalController.updatePlayerMenuText();
      print("goal player clicked once");
      globalController.lastClickedPlayer.value =
          _getPlayerFromName(buttonText)!;
      globalController.refresh();
      return;
    }
    // if goal was pressed and a player was already clicked once
    if (lastAction.actionType == "goal") {
      print("goal player clicked twice");
      // if it was a solo goal the action type has to be updated to "Tor Solo"
      if (_wasAssist() == false) {
        print("solo goal");
        // update data for person that shot the goal
        lastAction.playerId = activePlayerId!;
        repository.updateAction(lastAction);
        globalController.actions.last = lastAction;
        globalController.lastClickedPlayer.value = Player();
        globalController.addFeedItem();
        globalController.refresh();
      } else {
        // if it was an assist update data for both
        // person that scored goal
        lastAction.playerId = activePlayerId!;
        repository.updateAction(lastAction);
        globalController.actions.last = lastAction;
        globalController.addFeedItem();
        // person that scored assist
        // deep clone a new action from the most recent action

        print("assist action: ${GameAction.clone(lastAction)}");
        GameAction assistAction = GameAction.clone(lastAction);
        print("assist action: $assistAction");
        assistAction.playerId = globalController.lastClickedPlayer.value.id!;
        assistAction.actionType = "assist";
        repository.addActionToGame(assistAction);
        globalController.actions.add(assistAction);
        globalController.lastClickedPlayer.value = Player();
        globalController.addFeedItem();
      }
    } else {
      // if the action was not a goal just update the player id in firebase and gamestate
      lastAction.playerId = _getPlayerFromName(buttonText)!.id!;
      globalController.actions.last = lastAction;
      repository.updateAction(lastAction);
      globalController.lastClickedPlayer.value = Player();
      globalController.addFeedItem();
    }
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
    if (globalController.lastClickedPlayer.value.name == buttonText) {
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
          color: globalController.lastClickedPlayer.value == player
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
        color: globalController.lastClickedPlayer.value == player
            ? Colors.purple
            : Color.fromARGB(255, 180, 211, 236),
        onPressed: () {
          logPlayerSelection();
        });
  });
}
