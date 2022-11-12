import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handball_performance_tracker/data/models/models.dart';
import 'package:handball_performance_tracker/data/entities/entities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as developer;

/// Defines methods that need to be implemented by data providers. Could also be something other than Firebase
abstract class TeamRepository {
  // add team to storage and get back team with update id
  Future<Team> createTeam(Team team);

  // reading single team from storage
  Future<Team> fetchTeam(String teamId);
  // read all teams from storage
  Future<List<Team>> fetchTeams();

  // delete team in storage
  Future<void> deleteTeam(Team team);

  // update team in storage
  Future<void> updateTeam(Team team);
}

/// Implementation of TeamRepository that uses Firebase as the data provider
class TeamFirebaseRepository extends TeamRepository {
  final String currentUserUid = FirebaseAuth.instance.currentUser!.uid;

  /// Add team to the teams collection of the logged in club and return the team with the updated id
  Future<Team> createTeam(Team team) async {
    QuerySnapshot clubSnapshot = await FirebaseFirestore.instance
        .collection('clubs')
        .where("roles.${FirebaseAuth.instance.currentUser!.uid}", isEqualTo: "admin")
        .limit(1)
        .get();
    if (clubSnapshot.docs.length != 1) {
      throw Exception("No club found for user id. Cannot fetch team");
    }
    DocumentReference teamRef = await clubSnapshot.docs[0].reference.collection("teams").add(team.toEntity().toDocument());
    return team.copyWith(id: teamRef.id);
  }

  /// Fetch the specified team from the teams collection corresponding to the logged in Club
  Future<Team> fetchTeam(String teamId) async {
    Team? team = null;
    QuerySnapshot clubSnapshot = await FirebaseFirestore.instance
        .collection('clubs')
        .where("roles.${FirebaseAuth.instance.currentUser!.uid}", isEqualTo: "admin")
        .limit(1)
        .get();
    if (clubSnapshot.docs.length != 1) {
      throw Exception("No club found for user id. Cannot fetch team");
    }
    DocumentSnapshot teamSnapshot = await clubSnapshot.docs[0].reference.collection("teams").doc(teamId).get();
    if (teamSnapshot.exists) {
      team = await Team.fromEntity(TeamEntity.fromSnapshot(teamSnapshot));
    }
    return team!;
  }

  /// Fetch all teams from the team collection of the logged in club
  /// @param allPlayers: optional list of previously built players used for populating the teams list
  Future<List<Team>> fetchTeams({List<Player>? allPlayers}) async {
    developer.log("fetching teams", name: "TeamFirebaseRepository");
    List<Team> teams = [];
    QuerySnapshot clubSnapshot = await FirebaseFirestore.instance
        .collection('clubs')
        .where("roles.${FirebaseAuth.instance.currentUser!.uid}", isEqualTo: "admin")
        .limit(1)
        .get();

    if (clubSnapshot.docs.length != 1) {
      throw Exception("No club found for user id. Cannot fetch players");
    }
    QuerySnapshot teamsSnapshot = await clubSnapshot.docs[0].reference.collection("teams").get();
    await Future.forEach(teamsSnapshot.docs, (DocumentSnapshot teamSnapshot) async {
      Team team = await Team.fromEntity(TeamEntity.fromSnapshot(teamSnapshot), allPlayers: allPlayers ?? []);
      teams.add(team);
      print("added team: " + team.name);
    });
    return teams;
  }

  /// Delete the specified team
  @override
  Future<void> deleteTeam(Team team) async {
    QuerySnapshot clubSnapshot = await FirebaseFirestore.instance
        .collection('clubs')
        .where("roles.${FirebaseAuth.instance.currentUser!.uid}", isEqualTo: "admin")
        .limit(1)
        .get();
    if (clubSnapshot.docs.length != 1) {
      throw Exception("No club found for user id. Cannot delete team");
    }
    await clubSnapshot.docs[0].reference.collection("teams").doc(team.id).delete();
    // TODO instead of deletion we should mark the team as deleted and show it in the UI that they were deleted
    // delete all games that correspond to a team
    clubSnapshot.docs[0].reference.collection("games").where("teamId", isEqualTo: team.id).get().then((QuerySnapshot gamesSnapshot) {
      gamesSnapshot.docs.forEach((DocumentSnapshot gameSnapshot) {
        gameSnapshot.reference.delete();
      });
    });
    // remove team from the list of teams the player corresponds to inside the player collection
    clubSnapshot.docs[0].reference
        .collection("players")
        .where("teams", arrayContains: "teams/" + team.id.toString())
        .get()
        .then((QuerySnapshot playersSnapshot) {
      playersSnapshot.docs.forEach((DocumentSnapshot playerSnapshot) {
        Player player = Player.fromEntity(PlayerEntity.fromSnapshot(playerSnapshot));
        player.teams.remove("teams/" + team.id.toString());
        playerSnapshot.reference.update(player.toEntity().toDocument());
      });
    });
  }

  /// Update the specified team
  @override
  Future<void> updateTeam(Team team) async {
    QuerySnapshot clubSnapshot = await FirebaseFirestore.instance
        .collection('clubs')
        .where("roles.${FirebaseAuth.instance.currentUser!.uid}", isEqualTo: "admin")
        .limit(1)
        .get();
    if (clubSnapshot.docs.length == 1) {
      await clubSnapshot.docs[0].reference.collection("teams").doc(team.id).update(team.toEntity().toDocument());
    } else {
      throw Exception("No club found for user id. Cannot update team");
    }
  }
}
