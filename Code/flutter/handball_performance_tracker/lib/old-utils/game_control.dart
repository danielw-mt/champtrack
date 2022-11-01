import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/old-constants/stringsGameScreen.dart';
import 'package:handball_performance_tracker/old-constants/team_constants.dart';
import 'package:handball_performance_tracker/old-widgets/helper_screen/alert_message_widget.dart';
import 'package:handball_performance_tracker/old-widgets/main_screen/ef_score_bar.dart';
import '../controllers/persistent_controller.dart';
import '../controllers/temp_controller.dart';
import '../data/models/player_model.dart';
import '../data/models/game_model.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'sync_game_state.dart';
import '../old-constants/stringsGameSettings.dart';

void startGame(BuildContext context, {bool preconfigured: false}) async {
  TempController tempController = Get.find<TempController>();
  PersistentController persistentController = Get.find<PersistentController>();
  // check if enough players have been selected
  var numPlayersOnField = tempController.getOnFieldPlayers().length;
  if (numPlayersOnField != PLAYER_NUM) {
    // create alert if someone tries to start the game without enough players
    showDialog(
        context: context,
        builder: (BuildContext bcontext) {
          return AlertDialog(
              scrollable: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(menuRadius),
              ),
              content: CustomAlertMessageWidget(
                  StringsGameSettings.lStartGameAlertHeader +
                      "!\n" +
                      StringsGameSettings.lStartGameAlert));
        });
    return;
  }

  if (preconfigured) {
    // game has already been saved to firebase, only update relevant information
    Game preconfiguredGame = persistentController.getCurrentGame();
    preconfiguredGame.startTime = DateTime.now().toUtc().millisecondsSinceEpoch;
    preconfiguredGame.onFieldPlayers = tempController.getOnFieldPlayersById();
    persistentController.setCurrentGame(preconfiguredGame);
    // add game to selected players
    _addGameToPlayers(preconfiguredGame);
  } else {
    // Don't start time running directly. Set game paused so "back to game" button appears in side menu.
    tempController.setGameIsPaused(true);
    // start a new game in firebase
    print("starting new game");
    DateTime dateTime = DateTime.now();
    int unixTimeStamp = dateTime.toUtc().millisecondsSinceEpoch;
    Game newGame = Game(
        date: dateTime,
        startTime: unixTimeStamp,
        onFieldPlayers: tempController.getOnFieldPlayersById());
    await persistentController.setCurrentGame(newGame, isNewGame: true);
    print("start game, id: ${persistentController.getCurrentGame().id}");

    // add game to selected players
    _addGameToPlayers(newGame);
    tempController.setOpponentScore(0);
    tempController.setOwnScore(0);
  }
  runGameStateSync();
  print("start game, id: ${persistentController.getCurrentGame().id}");
}

void unpauseGame() {
  TempController tempController = Get.find<TempController>();
  PersistentController persistentController = Get.find<PersistentController>();
  tempController.setActionMenutText("");
  tempController.setGameIsRunning(true);
  tempController.setGameIsPaused(false);
  persistentController
      .getCurrentGame()
      .stopWatchTimer
      .onExecute
      .add(StopWatchExecute.start);
  runGameStateSync();
}

void pauseGame() {
  TempController tempController = Get.find<TempController>();
  PersistentController persistentController = Get.find<PersistentController>();
  tempController.setActionMenutText(StringsGameScreen.lAttentionTimeIsPaused);
  tempController.setGameIsRunning(false);
  tempController.setGameIsPaused(true);
  persistentController
      .getCurrentGame()
      .stopWatchTimer
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
      .stopWatchTimer
      .onExecute
      .add(StopWatchExecute.stop);

  tempController.setGameIsRunning(false);
  tempController.setGameIsPaused(false);

  //reset all data
  tempController.resetGameData(persistentController.getCurrentGame());
  persistentController.resetCurrentGame();
  persistentController.addGame(currentGame);
  persistentController.generateStatistics();
}

void _addGameToPlayers(Game game) {
  TempController tempController = Get.find<TempController>();
  for (Player player in tempController.getOnFieldPlayers()) {
    tempController.addGameToPlayer(player, game);
  }
}
