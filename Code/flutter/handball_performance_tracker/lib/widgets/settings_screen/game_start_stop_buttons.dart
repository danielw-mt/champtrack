import 'package:flutter/material.dart';
import '../../constants/team_constants.dart';
import '../../data/game.dart';
import '../../controllers/persistentController.dart';
import '../../controllers/tempController.dart';
import './../../data/game.dart';
import './../../data/player.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class GameStartStopButtons extends StatelessWidget {
  // TODO implement db write of newly selected players

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TempController>(
        builder: (gameController) => Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextButton(
                    onPressed: () {
                      if (!gameController.getGameIsRunning())
                        startGame(context);
                    },
                    child: const Text("Start Game"),
                    // start button is grey when the game is started and blue when not
                    style: ButtonStyle(
                        backgroundColor: gameController.getGameIsRunning()
                            ? MaterialStateProperty.all<Color>(Colors.grey)
                            : MaterialStateProperty.all<Color>(Colors.red)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextButton(
                      onPressed: () {
                        if (gameController.getGameIsRunning()) stopGame();
                      },
                      child: const Text("Stop Game")),
                )
              ],
            ));
  }

  void startGame(BuildContext context) async {
    final TempController gameController = Get.find<TempController>();
    final persistentController appController = Get.find<persistentController>();
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
    DateTime dateTime = DateTime.now();
    int unixTimeStamp = dateTime.toUtc().millisecondsSinceEpoch;
    Game newGame = Game(
        clubId: gameController.getSelectedTeam().id!,
        date: dateTime,
        startTime: unixTimeStamp,
        players: gameController.chosenPlayers.cast<Player>());

    appController.setCurrentGame(newGame, isNewGame: true);
    newGame = appController.getCurrentGame(); // id was updated during set
    print("start game, id: ${appController.getCurrentGame().id}");

    // add game to selected players
    _addGameToPlayers(newGame, gameController);

    // activate the game timer
    appController
        .getCurrentGame()
        .stopWatch
        .onExecute
        .add(StopWatchExecute.start);

    gameController.setGameIsRunning(true);
    gameController.setPlayerBarPlayers();
    gameController.refresh();
  }

  void stopGame() async {
    final TempController gameController = Get.find<TempController>();
    final persistentController appController = Get.find<persistentController>();
    // update game document in firebase
    Game currentGame = appController.getCurrentGame();
    print("stop game, id: ${appController.getCurrentGame().id}");

    DateTime dateTime = DateTime.now();
    currentGame.date = dateTime;
    currentGame.stopTime = dateTime.toUtc().millisecondsSinceEpoch;
    currentGame.players = gameController.chosenPlayers.cast<Player>();

    appController.setCurrentGame(currentGame);

    // stop the game timer
    appController
        .getCurrentGame()
        .stopWatch
        .onExecute
        .add(StopWatchExecute.stop);

    gameController.setGameIsRunning(false);
    gameController.refresh();
  }

  void _addGameToPlayers(Game game, TempController gc) {
    for (Player player in gc.chosenPlayers) {
      if (!player.games.contains(game.id)) {
        player.games.add(game.id!);
        // TODO implement this
        //repository.updatePlayer(player); //TODO maybe only update on stop?
      }
    }
  }
}
