import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/constants/team_constants.dart';
import '../controllers/persistentController.dart';
import '../controllers/tempController.dart';
import '../data/player.dart';
import '../data/game.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../constants/stringsGeneral.dart';
import '../constants/stringsGameSettings.dart';

void startGame(BuildContext context) async {
  TempController tempController = Get.find<TempController>();
  PersistentController persistentController = Get.find<PersistentController>();
  print("in start game");
  // check if enough players have been selected
  var numPlayersOnField = tempController.getOnFieldPlayers().length;
  if (numPlayersOnField != PLAYER_NUM) {
    // create alert if someone tries to start the game without enough players
    Alert(
            context: context,
            title: StringsGameSettings.lStartGameAlertHeader,
            type: AlertType.error,
            desc: StringsGameSettings.lStartGameAlert)
        .show();
    return;
  }

  // start a new game in firebase
  print("starting new game");
  DateTime dateTime = DateTime.now();
  int unixTimeStamp = dateTime.toUtc().millisecondsSinceEpoch;
  Game newGame = Game(
      clubId: tempController.getSelectedTeam().id!,
      date: dateTime,
      startTime: unixTimeStamp,
      players: tempController.chosenPlayers.cast<Player>());
  await persistentController.setCurrentGame(newGame, isNewGame: true);

  print("start game, id: ${persistentController.getCurrentGame().id}");

  // add game to selected players
  _addGameToPlayers(newGame);

  // activate the game timer
  persistentController
      .getCurrentGame()
      .stopWatch
      .onExecute
      .add(StopWatchExecute.start);

  print("start game, id: ${persistentController.getCurrentGame().id}");
  tempController.setGameIsRunning(true);
  tempController.setPlayerBarPlayers();
}

void unpauseGame() {
  TempController tempController = Get.find<TempController>();
  PersistentController persistentController = Get.find<PersistentController>();
  tempController.setGameIsRunning(true);
  persistentController
      .getCurrentGame()
      .stopWatch
      .onExecute
      .add(StopWatchExecute.start);
}

void pauseGame() {
  TempController tempController = Get.find<TempController>();
  PersistentController persistentController = Get.find<PersistentController>();
  tempController.setGameIsRunning(false);
  persistentController
      .getCurrentGame()
      .stopWatch
      .onExecute
      .add(StopWatchExecute.stop);
}

void stopGame() async {
  TempController tempController = Get.find<TempController>();
  PersistentController persistentController = Get.find<PersistentController>();
  // update game document in firebase
  Game currentGame = persistentController.getCurrentGame();
  print("stop game, id: ${persistentController.getCurrentGame().id}");

  DateTime dateTime = DateTime.now();
  currentGame.date = dateTime;
  currentGame.stopTime = dateTime.toUtc().millisecondsSinceEpoch;
  currentGame.players = tempController.chosenPlayers().cast<Player>();

  persistentController.setCurrentGame(currentGame);

  // stop the game timer
  persistentController.getCurrentGame().stopWatch.onExecute.add(StopWatchExecute.stop);

  tempController.setGameIsRunning(false);
}

void _addGameToPlayers(Game game) {
  TempController tempController = Get.find<TempController>();
  for (Player player in tempController.chosenPlayers) {
    if (!player.games.contains(game.id)) {
      player.games.add(game.id!);
      // TODO implement this
      //repository.updatePlayer(player); //TODO maybe only update on stop?
    }
  }
}
