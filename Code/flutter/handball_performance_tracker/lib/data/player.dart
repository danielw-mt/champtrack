import 'package:cloud_firestore/cloud_firestore.dart';
import 'ef_score.dart';

class Player {
  String? id;
  String name;
  int number;
  List<String> position;
  List<String> games;
  final String clubId;
  LiveEfScore efScore;

  Player(
      {this.id,
      this.name = "",
      this.number = 0,
      this.position = const [],
      this.clubId = "",
      this.games = const []})
      : efScore = LiveEfScore();

  // @return Map<String,dynamic> as representation of Player object that can be saved to firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'number': number,
      'position': position,
      'clubId': clubId,
      'games': games
    };
  }

  // @return Player object according to Player data fetched from firestore
  factory Player.fromDocumentSnapshot(DocumentSnapshot doc) {
    final newPlayer = Player.fromMap(doc.data() as Map<String, dynamic>);
    newPlayer.id = doc.reference.id;
    return newPlayer;
  }

  // @return Player object created from map representation of Player
  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
        name: map["name"],
        number : map["number"],
        position: map["position"].cast<String>(),
        clubId: map["clubId"],
        games: map["games"].cast<String>());
  }

  // Players are considered as identical if they have the same id
  bool operator ==(dynamic other) =>
      other != null && other is Player && id == other.id;
}
