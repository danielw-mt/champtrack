import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handball_performance_tracker/data/entities/entities.dart';
import 'player_model.dart';

class Team {
  String? id;
  String name;
  List<Player> players = [];
  List<Player> onFieldPlayers = [];
  String type;

  Team({this.id, this.name = "", this.type = "", required this.players, required onFieldPlayers});

  Team copyWith({String? id, String? name, List<Player>? players, List<Player>? onFieldPlayers, String? type}) {
    return Team(
      id: id ?? this.id,
      name: name ?? this.name,
      players: players ?? this.players,
      onFieldPlayers: onFieldPlayers ?? this.onFieldPlayers,
      type: type ?? this.type,
    );
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
    // TODO how can we generate the document reference for a player. Maybe the usual club via auth and then player collection and ref
    // return TeamEntity(
    //   id, name,onFieldPlayers.map((player) => Firebase.instance.get).toList(),
    //   type: type,
    // );
    throw UnimplementedError();
  }

  static Team fromEntity(TeamEntity entity) {
    List<Player> players = [];
    entity.players.forEach((DocumentReference player) async {
      DocumentSnapshot playerSnapshot = await player.get();
      players.add(Player.fromEntity(PlayerEntity.fromSnapshot(playerSnapshot)));
    });
    List<Player> onFieldPlayers = [];
    entity.onFieldPlayers.forEach((DocumentReference player) async {
      DocumentSnapshot playerSnapshot = await player.get();
      onFieldPlayers.add(Player.fromEntity(PlayerEntity.fromSnapshot(playerSnapshot)));
    });
    return Team(
      id: entity.id,
      name: entity.name,
      players: players,
      onFieldPlayers: onFieldPlayers,
      type: entity.type,
    );
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
