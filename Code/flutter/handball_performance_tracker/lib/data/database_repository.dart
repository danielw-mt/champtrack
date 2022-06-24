import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:handball_performance_tracker/data/game.dart';
import 'package:handball_performance_tracker/data/game_action.dart';
import 'package:handball_performance_tracker/data/player.dart';
import 'package:logger/logger.dart';

var logger = Logger(
  printer: PrettyPrinter(
      methodCount: 2, // number of method calls to be displayed
      errorMethodCount: 8, // number of method calls if stacktrace is provided
      lineLength: 120, // width of the output
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
      printTime: false // Should each log print contain a timestamp
      ),
);

class DatabaseRepository {
  //FirebaseApp devApp = await Firebase.initializeApp(name: "dev", options: DevFirebaseOptions.currentPlatform);
  //final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instanceFor(app: Firebase.app('dev'));

  /// @return asynchronous reference to Player object that was saved to firebase

  // @return asynchronous reference to Player object that was saved to firebase
  Future<DocumentReference> addPlayer(Player player) {
    return _db.collection("players").add(player.toMap());
  }

  /// update a Player's firestore record according to @param player properties
  void updatePlayer(Player player) async {
    await _db.collection("players").doc(player.id).update(player.toMap());
  }

  /// @return asynchronous reference to Game object that was saved to firebase
  Future<DocumentReference> addGame(Game game) async {
    return _db.collection("games").add(game.toMap());
  }

  /// update a Game's firestore record according to @param game properties
  void updateGame(Game game) async {
    await _db.collection("games").doc(game.id).update(game.toMap());
  }

  // query all teams in db
  Stream<QuerySnapshot> getAllTeamsStream() {
    return _db.collection("teams").snapshots();
  }

  Future<QuerySnapshot> getAllTeams() async {
    return await _db.collection("teams").get();
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
