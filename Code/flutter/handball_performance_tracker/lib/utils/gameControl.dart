import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/constants/team_constants.dart';
import '../controllers/globalController.dart';
import '../data/player.dart';
import '../data/game.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

void startGame(BuildContext context) async {
  final GlobalController globalController = Get.find<GlobalController>();
  print("in start game");
  // check if enough players have been selected
  var numPlayersOnField =
      globalController.selectedTeam.value.onFieldPlayers.length;
  if (numPlayersOnField != PLAYER_NUM) {
    // create alert if someone tries to start the game without enough players
    Alert(
            context: context,
            title: "Warning",
            type: AlertType.error,
            desc: "You can only start the game with $PLAYER_NUM players on the field")
        .show();
    return;
  }

  // start a new game in firebase
  print("starting new game");
  DateTime dateTime = DateTime.now();
  int unixTimeStamp = dateTime.toUtc().millisecondsSinceEpoch;
  Game newGame = Game(
      clubId: globalController.selectedTeam.value.id!,
      date: dateTime,
      startTime: unixTimeStamp,
      players: globalController.chosenPlayers.cast<Player>());

  final DocumentReference ref =
      await globalController.repository.addGame(newGame);
  newGame.id = ref.id;
  globalController.currentGame.value = newGame;
  print("start game, id: ${globalController.currentGame.value.id}");

  // add game to selected players
  _addGameToPlayers(newGame);

  // activate the game timer
  globalController.currentGame.value.stopWatch.onExecute.add(StopWatchExecute.start);

  globalController.gameRunning.value = true;
  globalController.refresh();
}

void unpauseGame() {
  final GlobalController globalController = Get.find<GlobalController>();
  globalController.gameRunning.value = true;
  globalController.currentGame.value.stopWatch.onExecute.add(StopWatchExecute.start);
  globalController.refresh();
}

void pauseGame() {
  final GlobalController globalController = Get.find<GlobalController>();
  globalController.gameRunning.value = false;
  globalController.currentGame.value.stopWatch.onExecute.add(StopWatchExecute.stop);
  globalController.refresh();
}

void stopGame() async {
  final GlobalController globalController = Get.find<GlobalController>();
  // update game document in firebase
  Game currentGame = globalController.currentGame.value;
  print("stop game, id: ${globalController.currentGame.value.id}");

  DateTime dateTime = DateTime.now();
  currentGame.date = dateTime;
  currentGame.stopTime = dateTime.toUtc().millisecondsSinceEpoch;
  currentGame.players = globalController.chosenPlayers.cast<Player>();

  globalController.repository.updateGame(currentGame);

  // stop the game timer
  globalController.currentGame.value.stopWatch.onExecute.add(StopWatchExecute.stop);

  globalController.gameRunning.value = false;
  globalController.refresh();
}

// TODO wo können wir solche helper-functions hinpacken und trotzdem auf das repo/globalController Objekt zugreifen?
void _addGameToPlayers(Game game) {
  final GlobalController globalController = Get.find<GlobalController>();
  for (Player player in globalController.chosenPlayers) {
    if (!player.games.contains(game.id)) {
      player.games.add(game.id!);
      // TODO implement this
      //repository.updatePlayer(player); //TODO maybe only update on stop?
    }
  }
}
