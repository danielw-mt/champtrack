import 'package:cloud_firestore/cloud_firestore.dart';
import 'player.dart';
import 'dart:convert';
import 'database_repository.dart';

class Team {
  String? id;
  String clubId;
  String name;
  List<Player> players;
  List<Player> onFieldPlayers;
  String type;

  Team({
    this.id,
    this.clubId = "",
    this.name = "Default Team",
    this.players = const [],
    this.onFieldPlayers = const [],
    this.type = "",
  });

  // @return Map<String,dynamic> as representation of Club object that can be saved to firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'clubId': clubId,
      'players': players,
      'onFieldPlayers': onFieldPlayers
    };
  }

  // @return Team object according to Team data fetched from firestore
  factory Team.fromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    final newTeam = Team.fromMap(data);

    newTeam.id = doc.reference.id;

    return newTeam;
  }

  // @return Team object created from map representation of Team
  factory Team.fromMap(Map<String, dynamic> map) {
    List<Player> playerList = [];
    List<Player> onFieldList = [];
    List<DocumentReference> players = map["players"].cast<DocumentReference>();
    players.forEach((dynamic documentReference) {
      documentReference.get().then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          playerList.add(Player.fromDocumentSnapshot(documentSnapshot));
        }
      });
    });
    return Team(
        name: map["name"],
        clubId: map["clubId"],
        players: playerList,
        onFieldPlayers: onFieldList);
  }
}
