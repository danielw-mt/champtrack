import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handball_performance_tracker/data/models/models.dart';
import 'package:handball_performance_tracker/data/entities/entities.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Defines methods that need to be implemented by data providers. Could also be something other than Firebase
abstract class GameRepository {
  // add game to storage
  Future<Game> createGame(Game game);

  // reading single game from storage
  Future<Game> fetchGame(String gameId);
  // read all games from storage
  Future<List<Game>> fetchGames();

  // update game in storage
  Future<void> updateGame(Game game);

  // delete game in storage
  Future<void> deleteGame(Game game);
}

/// Implementation of GameRepository that uses Firebase as the data provider
class GameFirebaseRepository extends GameRepository {
  final String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  List<Game> _games = [];

  /// Add game to the games collection of the logged in club and return the game with the updated id
  Future<Game> createGame(Game game) async {
    QuerySnapshot clubSnapshot = await FirebaseFirestore.instance
        .collection('clubs')
        .where("roles.${FirebaseAuth.instance.currentUser!.uid}", isEqualTo: "admin")
        .limit(1)
        .get();
    if (clubSnapshot.docs.length != 1) {
      throw Exception("No club found for user id. Cannot fetch game");
    }
    DocumentReference gameRef = await clubSnapshot.docs[0].reference.collection("games").add(game.toEntity().toDocument());
    // create new game in _games
    _games.add(game.copyWith(id: gameRef.id));

    return game.copyWith(id: gameRef.id);
  }

  /// Fetch the specified game from the games collection corresponding to the logged in Club
  Future<Game> fetchGame(String gameId) async {
    Game? game = null;
    QuerySnapshot clubSnapshot = await FirebaseFirestore.instance
        .collection('clubs')
        .where("roles.${FirebaseAuth.instance.currentUser!.uid}", isEqualTo: "admin")
        .limit(1)
        .get();
    if (clubSnapshot.docs.length != 1) {
      throw Exception("No club found for user id. Cannot fetch game");
    }
    DocumentSnapshot gameSnapshot = await clubSnapshot.docs[0].reference.collection("games").doc(gameId).get();
    if (gameSnapshot.exists) {
      game = Game.fromEntity(GameEntity.fromSnapshot(gameSnapshot));
    }
    return game!;
  }

  /// Fetch all games from the games collection of the logged in club
  Future<List<Game>> fetchGames() async {
    // List<Game> games = [];
    QuerySnapshot clubSnapshot = await FirebaseFirestore.instance
        .collection('clubs')
        .where("roles.${FirebaseAuth.instance.currentUser!.uid}", isEqualTo: "admin")
        .limit(1)
        .get();
    if (clubSnapshot.docs.length != 1) {
      throw Exception("No club found for user id. Cannot fetch games");
    }
    QuerySnapshot gamesSnapshot = await clubSnapshot.docs[0].reference.collection("games").get();
    await Future.forEach(gamesSnapshot.docs, (DocumentSnapshot gameSnapshot) {
      _games.add(Game.fromEntity(GameEntity.fromSnapshot(gameSnapshot)));
    });
    return _games;
  }

  /// Delete the specified game
  @override
  Future<void> deleteGame(Game game) async {
    QuerySnapshot clubSnapshot = await FirebaseFirestore.instance
        .collection('clubs')
        .where("roles.${FirebaseAuth.instance.currentUser!.uid}", isEqualTo: "admin")
        .limit(1)
        .get();
    if (clubSnapshot.docs.length != 1) {
      throw Exception("No club found for user id. Cannot delete game");
    }
    await clubSnapshot.docs[0].reference.collection("games").doc(game.id).delete();
    // remove game from _games
    _games.removeWhere((element) => element.id == game.id);
  }

  /// Update the specified game
  @override
  Future<void> updateGame(Game game) async {
    QuerySnapshot clubSnapshot = await FirebaseFirestore.instance
        .collection('clubs')
        .where("roles.${FirebaseAuth.instance.currentUser!.uid}", isEqualTo: "admin")
        .limit(1)
        .get();
    if (clubSnapshot.docs.length != 1) {
      throw Exception("No club found for user id. Cannot update game");
    }
    await clubSnapshot.docs[0].reference.collection("games").doc(game.id).update(game.toEntity().toDocument());
    // update game in _games
    _games[_games.indexWhere((element) => element.id == game.id)] = game;
  }

  List<Game> get games => _games;
  
  set games(List<Game> games) => _games = games;
}
