import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/data/game.dart';
import 'package:handball_performance_tracker/data/game_action.dart';
import 'package:handball_performance_tracker/data/player.dart';

import '../controllers/globalController.dart';

// TODO rename collection "player" to "players" and fix in firestore before merging to master
class DatabaseRepository {
  GlobalController globalController = Get.find<GlobalController>();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<DocumentReference> addPlayer(Player player) {
    return _db.collection("player").add(player.toMap());
  }

  void updatePlayer(Player player) async {
    await _db.collection("player").doc(player.id).update(player.toMap());
  }

  void deletePlayer(String documentId) async {
    await _db.collection("player").doc(documentId).delete();
  }

  Stream<QuerySnapshot> getPlayerStream() {
    return _db
        .collection("player")
        .where("clubId", isEqualTo: globalController.currentClubId.value)
        .snapshots();
  }

  Future<DocumentReference> addGame(Game game) async {
    return _db.collection("games").add(game.toMap());
  }

  void updateGame(Game game) async {
    await _db.collection("games").doc(game.id).update(game.toMap());
  }

  void deleteGame(String documentId) async {
    await _db.collection("games").doc(documentId).delete();
  }

  Stream<QuerySnapshot> getGameStream() {
    return _db
        .collection("games")
        .where("clubId", isEqualTo: globalController.currentClubId.value)
        .snapshots();
  }

  Stream<QuerySnapshot> getCurrentGameStream() {
    return _db
        .collection("games")
        .where("clubId", isEqualTo: globalController.currentClubId.value)
        .where("gameId", isEqualTo: globalController.currentGame.value.id)
        .snapshots();
  }

  Future<DocumentReference> addActionToGame(GameAction action) async {
    return _db
        .collection("gameData")
        .doc(action.gameId)
        .collection("actions")
        .add(action.toMap());
  }

  void updateAction(GameAction action) async {
    await _db
        .collection("gameData")
        .doc(action.gameId)
        .collection("actions")
        .doc(action.id)
        .update(action.toMap());
  }

  void deleteAction(GameAction action) async {
    await _db
        .collection("gameData")
        .doc(action.gameId)
        .collection("actions")
        .doc(action.id)
        .delete();
  }
}
