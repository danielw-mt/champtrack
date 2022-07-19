import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/constants/team_constants.dart';
import '../controllers/persistentController.dart';
import '../controllers/tempController.dart';
import '../data/player.dart';
import '../data/game.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../constants/stringsGameSettings.dart';

void startGame(BuildContext context, {bool preconfigured: false}) async {
  TempController tempController = Get.find<TempController>();
  PersistentController persistentController = Get.find<PersistentController>();
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

  if (preconfigured) {
    // game has already been saved to firebase, only update relevant information
    Game preconfiguredGame = persistentController.getCurrentGame();
    preconfiguredGame.startTime = DateTime.now().toUtc().millisecondsSinceEpoch;
    preconfiguredGame.players = tempController.getOnFieldPlayersById();
    persistentController.setCurrentGame(preconfiguredGame);
    // add game to selected players
    _addGameToPlayers(preconfiguredGame);
  } else {
    tempController.setPlayerBarPlayers();
    // Don't start time running directly. Set game paused so "back to game" button appears in side menu.
    tempController.setGameIsPaused(true);
    // start a new game in firebase
    print("starting new game");
    DateTime dateTime = DateTime.now();
    int unixTimeStamp = dateTime.toUtc().millisecondsSinceEpoch;
    Game newGame = Game(
        clubId: tempController.getSelectedTeam().id!,
        date: dateTime,
        startTime: unixTimeStamp,
        players: tempController.getOnFieldPlayersById());
    await persistentController.setCurrentGame(newGame, isNewGame: true);
    print("start game, id: ${persistentController.getCurrentGame().id}");

    // add game to selected players
    _addGameToPlayers(newGame);
    tempController.setOpponentScore(0);
    tempController.setOwnScore(0);
  }
  
  print("start game, id: ${persistentController.getCurrentGame().id}");
}

void unpauseGame() {
  TempController tempController = Get.find<TempController>();
  PersistentController persistentController = Get.find<PersistentController>();
  tempController.setGameIsRunning(true);
  tempController.setGameIsPaused(false);
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
  tempController.setGameIsPaused(true);
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
  currentGame.stopTime = dateTime.toUtc().millisecondsSinceEpoch;
  currentGame.scoreHome = tempController.getOwnScore();
  currentGame.scoreOpponent = tempController.getOpponentScore();

  persistentController.setCurrentGame(currentGame);

  // stop the game timer
  persistentController
      .getCurrentGame()
      .stopWatch
      .onExecute
      .add(StopWatchExecute.stop);

  tempController.setGameIsRunning(false);
  tempController.setGameIsPaused(false);
}

void _addGameToPlayers(Game game) {
  TempController tempController = Get.find<TempController>();
  for (Player player in tempController.getOnFieldPlayers()) {
    tempController.addGameToPlayer(player, game);
  }
}
