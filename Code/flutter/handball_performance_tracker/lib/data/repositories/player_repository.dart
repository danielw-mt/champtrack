import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handball_performance_tracker/data/models/models.dart';
import 'package:handball_performance_tracker/data/entities/entities.dart';
import 'package:handball_performance_tracker/data/repositories/repositories.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:handball_performance_tracker/core/core.dart';
import 'dart:developer' as developer;

/// Defines methods that need to be implemented by data providers. Could also be something other than Firebase
abstract class PlayerRepository {
  // Add a player and get back player with update id
  Future<Player> createPlayer(Player player);

  // reading the game
  Future<Player> fetchPlayer(String playerId);
  // reading all games
  Future<List<Player>> fetchPlayers();

  // if users wants to update player
  Future<void> updatePlayer(Player player);

  // if user wants to delete all player data
  Future<void> deletePlayer(Player player);
}

/// Implementation of PlayerRepository that uses Firebase as the data provider
class PlayerFirebaseRepository extends PlayerRepository {
  final String currentUserUid = FirebaseAuth.instance.currentUser!.uid;

  /// Add player to players collection @return player with updated id
  Future<Player> createPlayer(Player player) async {
    DocumentReference clubRef = await getClubReference();
    DocumentReference playerRef = await clubRef.collection("players").add(player.toEntity().toDocument());
    player.path = playerRef.path;
    player.id = playerRef.id;
    Future.forEach(player.teams, (String? teamReference) async {
      print("trying to add playerReference to team $teamReference");
      Team team = Team();
      if (teamReference!.contains("club")) {
        team = await TeamFirebaseRepository().fetchTeam(teamReference);
        print("fetched team ${team.path}");
      } else {
        // TODO add club reference for backwards compatibility
      }
      team.players.add(player);
      await TeamFirebaseRepository().updateTeam(team);
    });
    return player.copyWith(id: playerRef.id);
  }

  /// Fetch the specified player from the players collection corresponding to the logged in Club
  Future<Player> fetchPlayer(String playerId) async {
    Player? player = null;
    DocumentReference clubRef = await getClubReference();
    DocumentSnapshot playerSnapshot = await clubRef.collection("players").doc(playerId).get();
    if (playerSnapshot.exists) {
      player = Player.fromEntity(PlayerEntity.fromSnapshot(playerSnapshot));
    }
    return player!;
  }

  /// Fetch all players from the player collection of the logged in club
  Future<List<Player>> fetchPlayers() async {
    developer.log("fetchPlayers");
    List<Player> players = [];
    DocumentReference clubRef = await getClubReference();
    QuerySnapshot playersSnapshot = await clubRef.collection("players").get();
    await Future.forEach(playersSnapshot.docs, (DocumentSnapshot playerSnapshot) async {
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
