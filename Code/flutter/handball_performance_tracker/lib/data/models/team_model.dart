import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handball_performance_tracker/data/entities/entities.dart';
import 'player_model.dart';
import 'dart:developer' as developer;

class Team {
  String? id;
  String path;
  String name;
  List<Player> players = [];
  List<Player> onFieldPlayers = [];
  String type;

  Team({this.id, this.path = "", this.name = "", this.type = "", this.players = const [], this.onFieldPlayers = const []}) {
    // fix the mess that dart requires const optional parameters
    // https://stackoverflow.com/questions/69956033/flutter-how-to-handle-the-default-value-of-an-optional-parameter-must-be-const#comment129139196_69956165
    if (this.players.isEmpty) {
      this.players = [];
    }
    if (!this.players.isEmpty) {
      this.players = players;
    }
    if (this.onFieldPlayers.isEmpty) {
      this.onFieldPlayers = [];
    }
    if (!this.onFieldPlayers.isEmpty) {
      this.onFieldPlayers = onFieldPlayers;
    }
  }

  Team copyWith({String? id, String? name, List<Player>? players, List<Player>? onFieldPlayers, String? type}) {
    Team team = Team(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
    );
    team.players = players ?? this.players;
    team.onFieldPlayers = onFieldPlayers ?? this.onFieldPlayers;
    return team;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ players.hashCode ^ onFieldPlayers.hashCode ^ type.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Team &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          players == other.players &&
          onFieldPlayers == other.onFieldPlayers &&
          type == other.type;

  @override
  String toString() {
    return 'Team { id: $id, \n' + 'name: $name, \n' + 'players: $players, \n' + 'onFieldPlayers: $onFieldPlayers, \n' + 'type: $type, \n' + '}';
  }

  TeamEntity toEntity() {
    List<DocumentReference> playerRefs = [];
    players.forEach((Player player) {
      if (player.path != "") {
        DocumentReference playerRef = FirebaseFirestore.instance.doc(player.path);
        playerRefs.add(playerRef);
      }
    });
    List<DocumentReference> onFieldPlayerRefs = [];
    onFieldPlayers.forEach((Player player) {
      if (player.path != "") {
        DocumentReference playerRef = FirebaseFirestore.instance.doc(player.path);
        onFieldPlayerRefs.add(playerRef);
      }
    });
    DocumentReference? teamReference = null;
    if (path != "") {
      teamReference = FirebaseFirestore.instance.doc(path);
    }
    return TeamEntity(
      teamReference ?? null,
      name,
      playerRefs,
      onFieldPlayerRefs,
      type,
    );
  }

  static Future<Team> fromEntity(TeamEntity entity, {List<Player> allPlayers = const []}) async {
    List<Player> players = [];
    List<Player> onFieldPlayers = [];
    // the players list is used to populate the team's players list. If is however insufficient because
    bool allPlayersSufficient = true;
    if (!allPlayers.isEmpty) {
      entity.players.forEach((DocumentReference playerReference) {
        // if there is no player in the players that can be used to populate the team's players list set playerInsufficient to true
        List filteredPlayers = allPlayers.where((Player player) => player.path == playerReference.path).toList();
        if (filteredPlayers.length == 0) {
          allPlayersSufficient = true;
        }
      });
    }
    // if allPlayers cannot be used to populate players lists try to load each player individually
    if (allPlayersSufficient == false) {
      await Future.forEach(entity.players, (DocumentReference playerReference) async {
        DocumentSnapshot playerSnapshot = await playerReference.get();
        players.add(Player.fromEntity(PlayerEntity.fromSnapshot(playerSnapshot)));
      });
      await Future.forEach(entity.onFieldPlayers, (DocumentReference playerReference) async {
        DocumentSnapshot playerSnapshot = await playerReference.get();
        onFieldPlayers.add(Player.fromEntity(PlayerEntity.fromSnapshot(playerSnapshot)));
      });
    } else {
      print("populating using players");
      entity.players.forEach((DocumentReference playerReference) {
        players.add(allPlayers.firstWhere((Player player) => player.path == playerReference.path));
      });
      entity.onFieldPlayers.forEach((DocumentReference playerReference) {
        onFieldPlayers.add(allPlayers.firstWhere((Player player) => player.path == playerReference.path));
      });
    }

    print("Team, players: ${players.length}");
    Team team = Team(
      id: entity.documentReference!.id,
      path: entity.documentReference!.path,
      name: entity.name,
      players: players,
      onFieldPlayers: onFieldPlayers,
      type: entity.type,
    );
    return team;
  }

  // @return Map<String,dynamic> as representation of Club object that can be saved to firestore
  // Map<String, dynamic> toMap() {
  //   List<DocumentReference> playerRefs = [];
  //   players.forEach((Player player) {
  //     playerRefs.add(FirebaseFirestore.instance.collection("players").doc(player.id));
  //   });
  //   List<DocumentReference> onFieldPlayerRefs = [];
  //   onFieldPlayers.forEach((Player player) {
  //     onFieldPlayerRefs.add(FirebaseFirestore.instance.collection("players").doc(player.id));
  //   });

  //   return {
  //     'name': name,
  //     'players': playerRefs,
  //     'onFieldPlayers': onFieldPlayerRefs,
  //     'type': type,
  //   };
  // }

  // // @return Team object according to Team data fetched from firestore
  // factory Team.fromDocumentSnapshot(DocumentSnapshot doc) {
  //   print("team from document snapshot");
  //   Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
  //   final newTeam = Team.fromMap(data);

  //   newTeam.id = doc.reference.id;

  //   return newTeam;
  // }

  // @return Team object created from map representation of Team
  // factory Team.fromMap(Map<String, dynamic> map) {
  //   List<Player> playerList = [];
  //   List<Player> onFieldList = [];
  //   List<DocumentReference> players = map["players"].cast<DocumentReference>();
  //   players.forEach((dynamic documentReference) async {
  //     DocumentSnapshot playerSnapshot = await documentReference.get();
  //     if (playerSnapshot.exists) {
  //       playerList.add(Player.fromDocumentSnapshot(playerSnapshot));
  //     }
  //   });
  //   return Team(name: map["name"], players: playerList, onFieldPlayers: onFieldList);
  // }
}
