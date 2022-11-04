import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handball_performance_tracker/data/models/models.dart';
import 'package:handball_performance_tracker/data/entities/entities.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Defines methods that need to be implemented by data providers. Could also be something other than Firebase
abstract class GameRepository {
  // reading the game
  Future<Game> fetchGame(String gameId);
  // reading all games
  Future<List<Game>> fetchGames();

  // if user wants to delete all game data
  Future<void> deleteGame(Game game);

  // if user wants to update game
  Future<void> updateGame(Game game);
}

/// Implementation of GameRepository that uses Firebase as the data provider
class GameFirebaseRepository extends GameRepository {
  final String currentUserUid = FirebaseAuth.instance.currentUser!.uid;

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
    List<Game> games = [];
    QuerySnapshot clubSnapshot = await FirebaseFirestore.instance
        .collection('clubs')
        .where("roles.${FirebaseAuth.instance.currentUser!.uid}", isEqualTo: "admin")
        .limit(1)
        .get();
    if (clubSnapshot.docs.length != 1) {
      throw Exception("No club found for user id. Cannot fetch games");
    }
    QuerySnapshot gamesSnapshot = await clubSnapshot.docs[0].reference.collection("games").get();
    gamesSnapshot.docs.forEach((DocumentSnapshot gameSnapshot) {
      games.add(Game.fromEntity(GameEntity.fromSnapshot(gameSnapshot)));
    });
    return games;
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
  }
}
