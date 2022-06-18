import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/constants/team_constants.dart';
import '../controllers/persistentController.dart';
import '../controllers/tempController.dart';
import '../data/player.dart';
import '../data/game.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

void startGame(BuildContext context) async {
  TempController gameController = Get.find<TempController>();
  persistentController appController = Get.find<persistentController>();
  print("in start game");
  // check if enough players have been selected
  var numPlayersOnField = gameController.getOnFieldPlayers().length;
  if (numPlayersOnField != PLAYER_NUM) {
    // create alert if someone tries to start the game without enough players
    Alert(
            context: context,
            title: "Warning",
            type: AlertType.error,
            desc:
                "You can only start the game with $PLAYER_NUM players on the field")
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
  appController.setCurrentGame(newGame, isNewGame: true);
  print("start game, id: $appController.currentGame.value.id}");

  // add game to selected players
  _addGameToPlayers(newGame);

  // activate the game timer
  appController
      .getCurrentGame()
      .stopWatch
      .onExecute
      .add(StopWatchExecute.start);

  gameController.setGameIsRunning(true);
  gameController.refresh();
}

void unpauseGame() {
  TempController gameController = Get.find<TempController>();
  persistentController appController = Get.find<persistentController>();
  gameController.setGameIsRunning(true);
  appController
      .getCurrentGame()
      .stopWatch
      .onExecute
      .add(StopWatchExecute.start);
  gameController.refresh();
}

void pauseGame() {
  TempController gameController = Get.find<TempController>();
  persistentController appController = Get.find<persistentController>();
  gameController.setGameIsRunning(false);
  appController.getCurrentGame().stopWatch.onExecute.add(StopWatchExecute.stop);
  gameController.refresh();
}

void stopGame() async {
  TempController gameController = Get.find<TempController>();
  persistentController appController = Get.find<persistentController>();
  // update game document in firebase
  Game currentGame = appController.getCurrentGame();
  print("stop game, id: ${appController.getCurrentGame().id}");

  DateTime dateTime = DateTime.now();
  currentGame.date = dateTime;
  currentGame.stopTime = dateTime.toUtc().millisecondsSinceEpoch;
  currentGame.players = gameController.chosenPlayers().cast<Player>();

  appController.setCurrentGame(currentGame);

  // stop the game timer
  appController.getCurrentGame().stopWatch.onExecute.add(StopWatchExecute.stop);

  gameController.setGameIsRunning(false);
  gameController.refresh();
}

void _addGameToPlayers(Game game) {
  TempController gameController = Get.find<TempController>();
  for (Player player in gameController.chosenPlayers) {
    if (!player.games.contains(game.id)) {
      player.games.add(game.id!);
      // TODO implement this
      //repository.updatePlayer(player); //TODO maybe only update on stop?
    }
  }
}
