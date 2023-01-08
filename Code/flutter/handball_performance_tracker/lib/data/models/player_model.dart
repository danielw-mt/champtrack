import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handball_performance_tracker/data/entities/entities.dart';
import 'package:handball_performance_tracker/data/models/models.dart';
import '../ef_score.dart';

class Player {
  String? id;
  String path;
  String firstName;
  String lastName;
  String nickName;
  int number;
  List<String> positions = [];
  List<String> teams = [];
  List<String> games = [];
  LiveEfScore efScore = LiveEfScore();

  Player({
    this.id = "",
    this.path = "",
    this.firstName = "",
    this.lastName = "",
    this.nickName = "",
    this.number = 0,
    positions = const [],
    teams = const [],
    this.games = const [],
  }) {
    if (!positions.isEmpty) {
      this.positions = positions;
    }
    if (!teams.isEmpty) {
      this.teams = teams;
    }
    if (!games.isEmpty) {
      this.games = games;
    }
    efScore = LiveEfScore();
  }

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
    return PlayerEntity(
      documentReference: path == "" ? null : FirebaseFirestore.instance.doc(path),
      firstName: firstName,
      lastName: lastName,
      nickName: nickName,
      number: number,
      positions: positions,
      teams: teams,
    );
  }

  static Player fromEntity(PlayerEntity entity) {
    return Player(
      id: entity.documentReference == null ? null : entity.documentReference!.id,
      path: entity.documentReference == null ? "" : entity.documentReference!.path,
      firstName: entity.firstName,
      lastName: entity.lastName,
      nickName: entity.nickName,
      number: entity.number,
      positions: entity.positions,
      teams: entity.teams,
    );
  }

  void addAction(GameAction action) => efScore.addAction(action, positions);

  void removeAction(GameAction action) => efScore.removeAction(action, positions);

  // clear all performed actions e.g. after a game ended
  void resetActions() => efScore = LiveEfScore();
}
