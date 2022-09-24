import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handball_performance_tracker/data/game_action.dart';
import '../data/player.dart';
import '../data/team.dart';
import '../data/game.dart';
import '../data/database_repository.dart';
import 'package:get/get.dart';
import '../controllers/persistent_controller.dart';
import '../controllers/temp_controller.dart';
import 'dart:async';

/// Syncs game state with firebase every x minutes via timer
/// changes between data in firebase and local game state are detected.
/// The 'games' collection is updated accordingly with new gameActions for example
runGameStateSync() {
  TempController tempController = Get.find<TempController>();
  // if the game sync was already triggered somewhere else don't start another game sync loop
  if (tempController.isGameSyncActivated()) {
    return;
  } else {
    tempController.activateGameSync();
  }
  PersistentController persistentController = Get.find<PersistentController>();
  DatabaseRepository databaseRepository = persistentController.repository;

  Game currentGame = persistentController.getCurrentGame();
  Team currentTeam = tempController.getSelectedTeam();

  Timer.periodic(const Duration(seconds: 10), (timer) async {
    // update currentGame in case the score changed
    currentGame = persistentController.getCurrentGame();
    // get most recent gameData from Firebase as usable object in dart
    Game gameDocument =
        await databaseRepository.getGame(currentGame.id.toString());
    Map<String, dynamic> gameData = gameDocument.toMap();
    // sync selected team id, score, stopwatchtime,
    databaseRepository.syncGameMetaData({
      "id": currentGame.id,
      "selectedTeam": currentTeam.id,
      "scoreHome": tempController.getOwnScore(),
      "scoreOpponent": tempController.getOpponentScore(),
      "stopWatchTime": currentGame.stopWatchTimer.rawTime.value,
      "lastSync": DateTime.now().toIso8601String()
    });

    // if there are any actions in the gameState without an ID
    //(not added to FB yet), add those actions and assign them the id (happens in repository)
    persistentController
        .getAllActions()
        .where((GameAction action) => action.id == null)
        .forEach((GameAction action_in_loop) {
      persistentController.addActionToFirebase(action_in_loop);
    });

    /// start: sync players (on field)
    // check if there is a difference between players set in firebase and in gameState
    List<Player> onFieldPlayers = tempController.getOnFieldPlayers();
    List firebasePlayerIds = gameData["onFieldPlayers"];
    bool changeInIDs = false;
    firebasePlayerIds.forEach((element) {
      if (!onFieldPlayers.any((player) => player.id == element)) {
        changeInIDs = true;
      }
    });
    // when there is a change in IDs sync all players
    if (changeInIDs) {
      List<String?> newIDs = [];
      onFieldPlayers.forEach((Player player) {
        newIDs.add(player.id);
      });
      // TODO implement this
      // await currentGameFirebaseReference.update({"players": newIDs});
    }

    /// end: sync players
  });
}

/// Loads data from most recent game in games collection and recreates the game state
/// in terms of score, stopwatchtime, players, ef-score and gameActions
Future<void> recreateGameStateFromFirebase() async {
  TempController tempController = Get.find<TempController>();
  PersistentController persistentController = Get.find<PersistentController>();
  DatabaseRepository repository = persistentController.repository;

  // get latest game data from firebase
  Game mostRecentGame = await repository.getMostRecentGame();
  // current game id
  // stopwatchtime
  // store stopwatchtime
  int stopwatchTime = mostRecentGame.stopWatchTimer.rawTime.value;
  persistentController.setCurrentGame(mostRecentGame);
  persistentController.setStopWatchTime(stopwatchTime);
  // season
  tempController.setSelectedSeason(mostRecentGame.season.toString());

  // build list of player to restore manually from firebase based on players list
  // stored in games collection
  List<Player> onFieldPlayersFromLastGame = [];
  mostRecentGame.onFieldPlayers.forEach((String playerId) async {
    DocumentSnapshot playerSnapshot = await repository.getPlayer(playerId);
    if (playerSnapshot.exists) {
      onFieldPlayersFromLastGame
          .add(Player.fromDocumentSnapshot(playerSnapshot));
    }
  });
  // recreate team from already stored teams in persistentController
  //(those teams were created in initialize local data)
  Team selectedTeam = persistentController
      .getAvailableTeams()
      .where((Team team) => team.id == mostRecentGame.teamId)
      .first;
  selectedTeam.onFieldPlayers = onFieldPlayersFromLastGame;
  tempController.setSelectedTeam(selectedTeam);
  tempController.setOnFieldPlayers(onFieldPlayersFromLastGame);
  // scores
  tempController.setOwnScore(mostRecentGame.scoreHome!.toInt());
  tempController.setOpponentScore(mostRecentGame.scoreOpponent!.toInt());

  // add all old actions, update feed, update ef-score
  List<GameAction> actionsFromLastGame =
      await repository.getGameActionsFromGame(mostRecentGame.id.toString());
  actionsFromLastGame.forEach((GameAction action) {
    persistentController.addAction(action);
    tempController.addFeedAction(action);
    tempController.updatePlayerEfScore(action.playerId, action);
  });
  return;
}
