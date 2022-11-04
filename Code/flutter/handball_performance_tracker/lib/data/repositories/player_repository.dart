import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handball_performance_tracker/data/models/models.dart';
import 'package:handball_performance_tracker/data/entities/entities.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Defines methods that need to be implemented by data providers. Could also be something other than Firebase
abstract class PlayerRepository {
  // reading the game
  Future<Player> fetchPlayer(String playerId);
  // reading all games
  Future<List<Player>> fetchPlayers();

  // if user wants to delete all player data
  Future<void> deletePlayer(Player player);

  // if users wants to update player
  Future<void> updatePlayer(Player player);
}

/// Implementation of PlayerRepository that uses Firebase as the data provider
class PlayerFirebaseRepository extends PlayerRepository {
  final String currentUserUid = FirebaseAuth.instance.currentUser!.uid;

  /// Fetch the specified player from the players collection corresponding to the logged in Club
  Future<Player> fetchPlayer(String playerId) async {
    Player? player = null;
    QuerySnapshot clubSnapshot = await FirebaseFirestore.instance
        .collection('clubs')
        .where("roles.${FirebaseAuth.instance.currentUser!.uid}", isEqualTo: "admin")
        .limit(1)
        .get();
    if (clubSnapshot.docs.length != 1) {
      throw Exception("No club found for user id. Cannot fetch player");
    }
    DocumentSnapshot playerSnapshot = await clubSnapshot.docs[0].reference.collection("players").doc(playerId).get();
    if (playerSnapshot.exists) {
      player = Player.fromEntity(PlayerEntity.fromSnapshot(playerSnapshot));
    }
    return player!;
  }

  /// Fetch all players from the player collection of the logged in club
  Future<List<Player>> fetchPlayers() async {
    List<Player> players = [];
    QuerySnapshot clubSnapshot = await FirebaseFirestore.instance
        .collection('clubs')
        .where("roles.${FirebaseAuth.instance.currentUser!.uid}", isEqualTo: "admin")
        .limit(1)
        .get();
    if (clubSnapshot.docs.length != 1) {
      throw Exception("No club found for user id. Cannot fetch players");
    }
    QuerySnapshot playersSnapshot = await clubSnapshot.docs[0].reference.collection("players").get();
    playersSnapshot.docs.forEach((DocumentSnapshot playerSnapshot) {
      players.add(Player.fromEntity(PlayerEntity.fromSnapshot(playerSnapshot)));
    });
    return players;
  }

  /// Delete the specified player
  @override
  Future<void> deletePlayer(Player player) async {
    QuerySnapshot clubSnapshot = await FirebaseFirestore.instance
        .collection('clubs')
        .where("roles.${FirebaseAuth.instance.currentUser!.uid}", isEqualTo: "admin")
        .limit(1)
        .get();
    if (clubSnapshot.docs.length != 1) {
      throw Exception("No club found for user id. Cannot delete player");
    }
    await clubSnapshot.docs[0].reference.collection("players").doc(player.id).delete();
    // TODO implement proper deletion from games and teams
  }

  /// Update the specified player
  @override
  Future<void> updatePlayer(Player player) async {
    QuerySnapshot clubSnapshot = await FirebaseFirestore.instance
        .collection('clubs')
        .where("roles.${FirebaseAuth.instance.currentUser!.uid}", isEqualTo: "admin")
        .limit(1)
        .get();
    if (clubSnapshot.docs.length != 1) {
      throw Exception("No club found for user id. Cannot update player");
    }
    await clubSnapshot.docs[0].reference.collection("players").doc(player.id).update(player.toEntity().toDocument());
  }
}
