import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/data/game.dart';
import '../../strings.dart';
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
        id: "start-button",
        builder: (tempController) => Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextButton(
                    onPressed: () {
                      if (!tempController.getGameIsRunning())
                        startGame(context);
                    },
                    child: const Text(Strings.lStartGameButton),
                    // start button is grey when the game is started and blue when not
                    style: ButtonStyle(
                        backgroundColor: tempController.getGameIsRunning()
                            ? MaterialStateProperty.all<Color>(Colors.grey)
                            : MaterialStateProperty.all<Color>(Colors.red)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextButton(
                      onPressed: () {
                        if (tempController.getGameIsRunning()) stopGame();
                      },
                      child: const Text(Strings.lStopGameButton)),
                )
              ],
            ));
  }

  void startGame(BuildContext context) async {
    final TempController tempController = Get.find<TempController>();
    final PersistentController persistentController = Get.find<PersistentController>();
    print("in start game");
    // check if enough players have been selected
    var numPlayersOnField = tempController.getOnFieldPlayers().length;
    if (numPlayersOnField != PLAYER_NUM) {
      // create alert if someone tries to start the game without enough players
      Alert(
              context: context,
              title: Strings.lWarningPlayerNumberErrorMessage,
              type: AlertType.error,
              desc: Strings.lPlayerNumberErrorMessage)
          .show();
      return;
    }

    // start a new game in firebase
    DateTime dateTime = DateTime.now();
    int unixTimeStamp = dateTime.toUtc().millisecondsSinceEpoch;
    Game newGame = Game(
        clubId: tempController.getSelectedTeam().id!,
        date: dateTime,
        startTime: unixTimeStamp,
        players: tempController.chosenPlayers.cast<Player>());

    await persistentController.setCurrentGame(newGame, isNewGame: true);
    newGame = persistentController.getCurrentGame(); // id was updated during set
    print("start game, id: ${persistentController.getCurrentGame().id}");

    // add game to selected players
    _addGameToPlayers(newGame, tempController);

    // activate the game timer
    persistentController
        .getCurrentGame()
        .stopWatch
        .onExecute
        .add(StopWatchExecute.start);

    tempController.setGameIsRunning(true);
    tempController.setPlayerBarPlayers();
  }

  void stopGame() async {
    final TempController tempController = Get.find<TempController>();
    final PersistentController persistentController = Get.find<PersistentController>();
    // update game document in firebase
    Game currentGame = persistentController.getCurrentGame();
    print("stop game, id: ${persistentController.getCurrentGame().id}");

    DateTime dateTime = DateTime.now();
    currentGame.date = dateTime;
    currentGame.stopTime = dateTime.toUtc().millisecondsSinceEpoch;
    currentGame.players = tempController.chosenPlayers.cast<Player>();

    persistentController.setCurrentGame(currentGame);

    // stop the game timer
    persistentController
        .getCurrentGame()
        .stopWatch
        .onExecute
        .add(StopWatchExecute.stop);

    tempController.setGameIsRunning(false);
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
