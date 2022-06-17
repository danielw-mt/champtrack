import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/constants/team_constants.dart';
import 'package:handball_performance_tracker/data/database_repository.dart';
import '../controllers/appController.dart';
import '../controllers/gameController.dart';
import '../data/player.dart';
import '../data/game.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

void startGame(BuildContext context) async {
  GameController gameController = Get.find<GameController>();
  AppController appController = Get.find<AppController>();
  DatabaseRepository repository = Get.find<AppController>().repository;
  print("in start game");
  // check if enough players have been selected
  var numPlayersOnField =
      gameController.getOnFieldPlayers().length;
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
      clubId: gameController.getSelectedTeam().id!,
      date: dateTime,
      startTime: unixTimeStamp,
      players: gameController.chosenPlayers.cast<Player>());

  final DocumentReference ref =
      await repository.addGame(newGame);
  newGame.id = ref.id;
  appController.setCurrentGame(newGame);
  print("start game, id: $appController.currentGame.value.id}");

  // add game to selected players
  _addGameToPlayers(newGame);

  // activate the game timer
  appController.getCurrentGame().stopWatch.onExecute.add(StopWatchExecute.start);

  gameController.setGameIsRunning(true);
  gameController.refresh();
}

void unpauseGame() {
  GameController gameController = Get.find<GameController>();
  AppController appController = Get.find<AppController>();
  gameController.setGameIsRunning(true);
  appController.getCurrentGame().stopWatch.onExecute.add(StopWatchExecute.start);
  gameController.refresh();
}

void pauseGame() {
  GameController gameController = Get.find<GameController>();
  AppController appController = Get.find<AppController>();
  gameController.setGameIsRunning(false);
  appController.getCurrentGame().stopWatch.onExecute.add(StopWatchExecute.stop);
  gameController.refresh();
}

void stopGame() async {
  GameController gameController = Get.find<GameController>();
  AppController appController = Get.find<AppController>();
  DatabaseRepository repository = Get.find<AppController>().repository;
  // update game document in firebase
  Game currentGame = appController.getCurrentGame();
  print("stop game, id: ${appController.getCurrentGame().id}");

  DateTime dateTime = DateTime.now();
  currentGame.date = dateTime;
  currentGame.stopTime = dateTime.toUtc().millisecondsSinceEpoch;
  currentGame.players = gameController.chosenPlayers().cast<Player>();

  repository.updateGame(currentGame);

  // stop the game timer
  appController.getCurrentGame().stopWatch.onExecute.add(StopWatchExecute.stop);

  gameController.setGameIsRunning(false);
  gameController.refresh();
}

void _addGameToPlayers(Game game) {
  GameController gameController = Get.find<GameController>();
  for (Player player in gameController.chosenPlayers) {
    if (!player.games.contains(game.id)) {
      player.games.add(game.id!);
      // TODO implement this
      //repository.updatePlayer(player); //TODO maybe only update on stop?
    }
  }
}
