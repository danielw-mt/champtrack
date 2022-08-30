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

  // check if a game exists already
  bool currentGameExists = false;
  // filter for games with sync property that happened 20 minutes ago

  // was there a game started in the last 20 minutes

  // yes? => loadFBDataIntoGameState
  // TODO check if the current game id exists in the database
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

    // sync selected team id, score, stopwatchtime,
    await currentGameFirebaseReference.update({
      "selectedTeam": currentTeam.id,
      "scoreHome": currentGame.scoreHome,
      "scoreOpponent": currentGame.scoreOpponent,
      "stopWatchTime": currentGame.stopWatch.rawTime.value
    });

    // sync new gameActions
    // get the timestamp of the last action that is stored in FB
    QuerySnapshot lastActionSaved = await currentGameFirebaseReference
        .collection("actions")
        .orderBy("timestamp", descending: true)
        .limitToLast(1)
        .get();
    // get all actions in the action list that are newer than the timestamp
    List<GameAction> newActions = persistentController
        .getActionsNewerThan(lastActionSaved.docs.first["timestamp"]);
    // sync all newActions to FB
    newActions.forEach((GameAction action) {
      persistentController.addActionToFirebase(action);
    });

    /// end: sync new actions

    /// start: sync players (on field)
    // check if there is a difference between players set in firebase and in gameState
    List<Player> onFieldPlayers = tempController.getOnFieldPlayers();
    List<String> firebasePlayerIds = gameData["players"];
    bool changeInIDs = false;
    onFieldPlayers.forEach((Player player) {
      if (!firebasePlayerIds.contains(player.id)) {
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
  });
}

/// Recreates the gameState when for example a crash has occured. 
/// Checks if the gameState is empty but should be filled because there is a gameRunning
/// 
/// If applicable recreates 
/// onFieldPlayers, their ef-scores, stopwatch and gameActions from Firebase data
recreateGameStateFromFirebase() {}
