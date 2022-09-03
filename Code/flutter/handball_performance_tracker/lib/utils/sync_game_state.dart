import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handball_performance_tracker/data/game_action.dart';
import '../data/player.dart';
import '../data/team.dart';
import '../data/game.dart';
import '../data/database_repository.dart';
import 'package:get/get.dart';
import '../controllers/persistentController.dart';
import '../controllers/tempController.dart';
import 'dart:async';

/// Syncs game state with firebase every x minutes via timer
/// changes between data in firebase and local game state are detected.
/// The 'games' collection is updated accordingly with new gameActions for example
runGameStateSync() {
  TempController tempController = Get.find<TempController>();
  PersistentController persistentController = Get.find<PersistentController>();
  DatabaseRepository repository = persistentController.repository;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Game currentGame = persistentController.getCurrentGame();
  Team currentTeam = tempController.getSelectedTeam();
  DocumentReference currentGameFirebaseReference =
      _db.collection("games").doc(currentGame.id);
  Timer.periodic(const Duration(seconds: 10), (timer) async {
    // update currentGame in case the score changed
    currentGame = persistentController.getCurrentGame();
    // get most recent gameData from Firebase as usable object in dart
    DocumentSnapshot gameDocument = await currentGameFirebaseReference.get();
    final gameData = gameDocument.data() as Map<String, dynamic>;
    print("syncing stopwatchtime: ${currentGame.stopWatchTimer.rawTime.value}");
    // sync selected team id, score, stopwatchtime,
    await currentGameFirebaseReference.update({
      "selectedTeam": currentTeam.id,
      "scoreHome": tempController.getOwnScore(),
      "scoreOpponent": tempController.getOpponentScore(),
      "stopWatchTime": currentGame.stopWatchTimer.rawTime.value
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
    List firebasePlayerIds = gameData["players"];
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
      await currentGameFirebaseReference.update({"players": newIDs});
    }

    /// end: sync players
    await currentGameFirebaseReference
        .update({"lastSync": DateTime.now().toIso8601String()});
  });
}

Future<void> recreateGameStateFromFirebase() async {
  TempController tempController = Get.find<TempController>();
  PersistentController persistentController = Get.find<PersistentController>();
  DatabaseRepository repository = persistentController.repository;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

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

  // players
  List<Player> onFieldPlayersFromLastGame = [];
  mostRecentGame.players.forEach((String playerId) async {
    DocumentSnapshot playerSnapshot = await repository.getPlayer(playerId);
    if (playerSnapshot.exists) {
      onFieldPlayersFromLastGame
          .add(Player.fromDocumentSnapshot(playerSnapshot));
    }
  });
  // team
  Team selectedTeam = persistentController
      .getAvailableTeams()
      .where((Team team) => team.id == mostRecentGame.teamId)
      .first;
  selectedTeam.onFieldPlayers = onFieldPlayersFromLastGame;
  tempController.setSelectedTeam(selectedTeam);
  tempController.setPlayingTeam(selectedTeam);
  // tempController
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
