import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/data/database_repository.dart';
import 'package:handball_performance_tracker/data/game.dart';
import '../../controllers/globalController.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../data/game_action.dart';
import '../../data/player.dart';

void callPlayerMenu(context) {
  final GlobalController globalController = Get.find<GlobalController>();
  Alert(
          context: context,
          title: "Choose Player",
          // alert contains a list of DialogButton objects
          desc: globalController.playerMenuText.value,
          buttons: buildDialogButtonList(context))
      .show();
}

/// builds a list of Dialog buttons
List<DialogButton> buildDialogButtonList(BuildContext context) {
  final GlobalController globalController = Get.find<GlobalController>();
  List<DialogButton> dialogButtons = [];
  for (var player in globalController.chosenPlayers) {
    DialogButton dialogButton = buildDialogButton(context, player.name);
    dialogButtons.add(dialogButton);
  }
  return dialogButtons;
}

/// builds a single dialog button that logs its text (=player name) to firestore
/// and updates the game state
DialogButton buildDialogButton(BuildContext context, String buttonText) {
  final GlobalController globalController = Get.find<GlobalController>();
  DatabaseRepository repository = DatabaseRepository();

  /// @return "" if action wasn't a goal, "solo" when player scored without
  /// assist and "assist" when player click was assist
  bool _wasAssist() {
    // check if action was a goal
    // if it was a goal allow the player to be pressed twice or select and assist player
    globalController.playerMenuText.value =
        "Press again for solo or other player for assist";
    globalController.refresh();
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
    print("log player");
    GameAction lastAction = globalController.actions.last;
    print("last action");
    String? activePlayerId = globalController.lastClickedPlayer.value.id;

    // if goal was pressed but no player was selected yet, do nothing
    if (lastAction.actionType == "goal" && activePlayerId == null) {
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
        globalController.refresh();
      } else {
        // if it was an assist update data for both
        // person that scored goal
        lastAction.playerId = activePlayerId!;
        repository.updateAction(lastAction);
        globalController.actions.last = lastAction;
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
      }
    } else {
      // if the action was not a goal just update the player id in firebase and gamestate
      lastAction.playerId = _getPlayerFromName(buttonText)!.id!;
      globalController.actions.last = lastAction;
      repository.updateAction(lastAction);
      globalController.lastClickedPlayer.value = Player();
    }
    print("last action saved in database: ");
    print(globalController.actions.last.toMap());
    globalController.refresh();
    Navigator.pop(context);
  }

  return DialogButton(
      child: Text(
        buttonText,
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      onPressed: () {
        logPlayerSelection();
      });
}
