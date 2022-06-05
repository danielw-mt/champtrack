import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handball_performance_tracker/data/game.dart';
import 'package:handball_performance_tracker/data/game_action.dart';
import 'package:handball_performance_tracker/data/player.dart';

class DatabaseRepository {
  
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// @return asynchronous reference to Player object that was saved to firebase
  Future<DocumentReference> addPlayer(Player player) {
    return _db.collection("players").add(player.toMap());
  }

  /// update a Player's firestore record according to @param player properties
  void updatePlayer(Player player) async {
    await _db.collection("players").doc(player.id).update(player.toMap());
  }

  /// delete a Player's firestore record with a given @param documentId
  void deletePlayer(Player player) async {
    // TODO also delete all actions associated with player? delete player from all games?
    await _db.collection("players").doc(player.id).delete();
  }

  /// query all players of the current club
  Stream<QuerySnapshot> getPlayerStream(String currentClubId) {
    return _db
        .collection("players")
        .where("clubId", isEqualTo: currentClubId)
        .snapshots();
  }

  /// @return asynchronous reference to Game object that was saved to firebase
  Future<DocumentReference> addGame(Game game) async {
    return _db.collection("games").add(game.toMap());
  }

  /// update a Game's firestore record according to @param game properties
  void updateGame(Game game) async {
    await _db.collection("games").doc(game.id).update(game.toMap());
  }

  /// delete a Game's firestore record with a given @param documentId
  void deleteGame(String documentId) async {
    await _db.collection("games").doc(documentId).delete();
    // TODO: delete game from games list of all players
  }

  /// query all games of current club
  Stream<QuerySnapshot> getGameStream(String currentClubId) {
    // TODO: unused
    return _db
        .collection("games")
        .where("clubId", isEqualTo: currentClubId)
        .snapshots();
  }

  /// query the current game
  Stream<QuerySnapshot> getCurrentGameStream(
      String currentClubId, String currentGameId) {
    // TODO: unused
    return _db
        .collection("games")
        .where("clubId", isEqualTo: currentClubId)
        .where("gameId", isEqualTo: currentGameId)
        .snapshots();
  }

  /// @return asynchronous reference to GameAction object that was saved to firebase
  Future<DocumentReference> addActionToGame(GameAction action) async {
    return _db
        .collection("gameData")
        .doc(action.gameId)
        .collection("actions")
        .add(action.toMap());
  }

  /// update a GameAction's firestore record according to @param action properties
  void updateAction(GameAction action) async {
    await _db
        .collection("gameData")
        .doc(action.gameId)
        .collection("actions")
        .doc(action.id)
        .update(action.toMap());
  }

  /// delete a the firestore record of a given @param action
  void deleteAction(GameAction action) async {
    await _db
        .collection("gameData")
        .doc(action.gameId)
        .collection("actions")
        .doc(action.id)
        .delete();
  }

  void deleteLastAction() async {
    // get the latest game
    QuerySnapshot mostRecentGameQuery = await _db
        .collection("games")
        .orderBy("date", descending: true)
        .limit(1)
        .get();
    DocumentSnapshot mostRecentGame = mostRecentGameQuery.docs[0];
    // look inside gameActions for the lastest action for that game
    QuerySnapshot mostRecentActionQuery = await _db
        .collection("gameData")
        .doc(mostRecentGame.id)
        .collection("actions")
        .orderBy("timestamp", descending: true)
        .limit(1)
        .get();

    DocumentSnapshot mostRecentAction = mostRecentActionQuery.docs[0];
    // delete most recent doc
    _db
        .collection("gameData")
        .doc(mostRecentGame.id)
        .collection("actions")
        .doc(mostRecentAction.id)
        .delete();
  }
}
