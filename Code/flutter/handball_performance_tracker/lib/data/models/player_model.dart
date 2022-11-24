import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handball_performance_tracker/data/entities/entities.dart';
import '../ef_score.dart';

class Player {
  String? id;
  String path;
  String firstName;
  String lastName;
  String nickName;
  int number;
  List<String> positions;
  List<String> teams;
  LiveEfScore efScore;

  Player({
    this.id = "",
    this.path = "",
    this.firstName = "",
    this.lastName = "",
    this.nickName = "",
    this.number = 0,
    this.positions = const [],
    this.teams = const [],
  }) : efScore = LiveEfScore();

  Player copyWith(
      {String? id,
      String? firstName,
      String? lastName,
      String? nickName,
      int? number,
      List<String>? positions,
      List<String>? games,
      List<String>? teams,
      LiveEfScore? efScore}) {
    Player player = Player(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      nickName: nickName ?? this.nickName,
      number: number ?? this.number,
      positions: positions ?? this.positions,
      teams: teams ?? this.teams,
    );
    player.efScore = efScore ?? this.efScore;
    return player;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      nickName.hashCode ^
      number.hashCode ^
      positions.hashCode ^
      teams.hashCode ^
      efScore.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Player && id == other.id;

  @override
  String toString() {
    return 'Club { id: $id, +\n ' +
        'firstName: $firstName, +\n ' +
        'lastName: $lastName, +\n ' +
        'nickName: $nickName, +\n ' +
        'number: $number, +\n ' +
        'positions: $positions, +\n ' +
        'teams: $teams, +\n ' +
        'efScore: $efScore }';
  }

  PlayerEntity toEntity() {
    DocumentReference documentReference = FirebaseFirestore.instance.doc(path);
    return PlayerEntity(documentReference, firstName, lastName, nickName, number, positions, teams);
  }

  static Player fromEntity(PlayerEntity entity) {
    return Player(
      id: entity.documentReference.id,
      path: entity.documentReference.path,
      firstName: entity.firstName,
      lastName: entity.lastName,
      nickName: entity.nickName,
      number: entity.number,
      positions: entity.positions,
      teams: entity.teams,
    );
  }

  // @return Map<String,dynamic> as representation of Player object that can be saved to firestore
  // Map<String, dynamic> toMap() {
  //   return {
  //     'firstName': firstName,
  //     'lastName': lastName,
  //     'nickName': nickName,
  //     'number': number,
  //     'positions': positions,
  //     'teams': teams,
  //     'games': games
  //   };
  // }

  // @return Player object according to Player data fetched from firestore
  // factory Player.fromDocumentSnapshot(DocumentSnapshot doc) {
  //   logger.d("creating player from document snapshot");
  //   final newPlayer =
  //       Player.fromMap(Map.from(doc.data() as Map<String, dynamic>));
  //   newPlayer.id = doc.reference.id;
  //   return newPlayer;
  // }

  // @return Player object created from map representation of Player
  // factory Player.fromMap(Map<String, dynamic> map) {
  //   String firstName = map["firstName"];
  //   String lastName = map["lastName"];
  //   String nickName = map["nickName"];
  //   int number = map["number"];
  //   List<String> positions = map["positions"].cast<String>();
  //   List<String> teams = map["teams"].cast<String>();
  //   List<String> games = map["games"].cast<String>();
  //   return Player(
  //       firstName: firstName,
  //       lastName: lastName,
  //       nickName: nickName,
  //       number: number,
  //       positions: positions,
  //       teams: teams,
  //       games: games);
  // }

  // Players are considered as identical if they have the same id
  // @override
  // bool operator ==(dynamic other) =>
  //     other != null && other is Player && id == other.id;

  // void addAction(GameAction action) => efScore.addAction(action, positions);

  // void removeAction(GameAction action) =>
  //     efScore.removeAction(action, positions);

  // // clear all performed actions e.g. after a game ended
  // void resetActions() => efScore = LiveEfScore();

  // @override
  // String toString() {
  //   return "Player( +\n firstName: ${firstName}, +\n lastName: ${lastName}, +\n nickName: ${nickName} ";
  // }
}
