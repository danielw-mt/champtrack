import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handball_performance_tracker/data/models/models.dart';
import 'package:handball_performance_tracker/data/entities/entities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:handball_performance_tracker/core/core.dart';
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
  List<Team> _teams = [];

  /// Add team to the teams collection of the logged in club and return the team with the updated id
  Future<Team> createTeam(Team team) async {
    DocumentReference clubRef = await getClubReference();
    DocumentReference teamRef =
        await clubRef.collection("teams").add(team.toEntity().toDocument());
    _teams.add(team.copyWith(id: teamRef.id, path: teamRef.path));
    return _teams.last;
  }

  /// Fetch the specified team from the teams collection corresponding to the logged in Club
  Future<Team> fetchTeam(String teamId) async {
    Team? team = null;
    DocumentSnapshot teamSnapshot;
    if (!teamId.contains("club") && !teamId.contains("teams")) {
      DocumentReference clubRef = await getClubReference();
      teamSnapshot = await clubRef.collection("teams").doc(teamId).get();
      // case we passed an entire path
    } else if (teamId.contains("club") && teamId.contains("teams")) {
      print("we received an entire path");
      teamSnapshot = await FirebaseFirestore.instance.doc(teamId).get();
    } else {
      throw Exception("Invalid team id");
    }
    if (teamSnapshot.exists) {
      team = await Team.fromEntity(await TeamEntity.fromSnapshot(teamSnapshot));
    }
    return team!;
  }

  /// Fetch all teams from the team collection of the logged in club
  /// @param allPlayers: optional list of previously built players used for populating the teams list
  Future<List<Team>> fetchTeams({List<Player>? allPlayers}) async {
    developer.log("fetching teams", name: "TeamFirebaseRepository");
    //List<Team> teams = [];
    DocumentReference clubRef = await getClubReference();
    QuerySnapshot teamsSnapshot = await clubRef.collection("teams").get();
    await Future.forEach(teamsSnapshot.docs,
        (DocumentSnapshot teamSnapshot) async {
      Team team = await Team.fromEntity(
          await TeamEntity.fromSnapshot(teamSnapshot),
          allPlayers: allPlayers ?? []);
      _teams.add(team);
      print("added team: " + team.name);
    });
    return _teams;
  }

  /// Delete the specified team
  @override
  Future<void> deleteTeam(Team team) async {
    DocumentReference clubRef = await getClubReference();
    await clubRef.collection("teams").doc(team.id).delete();
    // delete team from _teams
    _teams.removeWhere((element) =>
        element.id ==
        team.id); // TODO games are not deleted in local variable yet
    // TODO instead of deletion we should mark the team as deleted and show it in the UI that they were deleted
    // delete all games that correspond to a team
    clubRef
        .collection("games")
        .where("teamId", isEqualTo: team.id)
        .get()
        .then((QuerySnapshot gamesSnapshot) {
      gamesSnapshot.docs.forEach((DocumentSnapshot gameSnapshot) {
        gameSnapshot.reference.delete();
      });
    });
    // remove team from the list of teams the player corresponds to inside the player collection
    clubRef
        .collection("players")
        .where("teams", arrayContains: "teams/" + team.id.toString())
        .get()
        .then((QuerySnapshot playersSnapshot) {
      playersSnapshot.docs.forEach((DocumentSnapshot playerSnapshot) {
        Player player =
            Player.fromEntity(PlayerEntity.fromSnapshot(playerSnapshot));
        player.teams.remove("teams/" + team.id.toString());
        playerSnapshot.reference.update(player.toEntity().toDocument());
      });
    });
  }

  /// Update the specified team
  @override
  Future<void> updateTeam(Team team) async {
    DocumentReference clubRef = await getClubReference();
    // print event team
    print("event team: " + team.toString());
    await clubRef
        .collection("teams")
        .doc(team.id)
        .update(team.toEntity().toDocument());
    // update team in _teams
    List<Team> updatedTeams =
        _teams.map((e) => e.id == team.id ? team : e).toList();
    _teams = updatedTeams;
  }

  List<Team> get teams => _teams;

  set teams(List<Team> teams) {
    _teams = teams;
  }
}
