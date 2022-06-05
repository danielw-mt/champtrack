import 'package:cloud_firestore/cloud_firestore.dart';
import 'ef_score.dart';

class Player {
  String? id;
  String firstName;
  String lastName;
  int number;
  List<String> positions;
  List<String> games;
  final String clubId;
  LiveEfScore efScore;

  Player(
      {this.id,
      this.firstName = "",
      this.lastName = "",
      this.number = 0,
      this.positions = const [],
      this.clubId = "",
      this.games = const []})
      : efScore = LiveEfScore();

  // @return Map<String,dynamic> as representation of Player object that can be saved to firestore
  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'number': number,
      'position': positions,
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
    String firstName = map["firstName"];
    String lastName = map["lastName"];
    int number = map["number"];
    // TODO give out a list here
    // List<String> positions = map["positions"];
    String clubId = map["clubId"];
    // String games = map["games"].cast<String>();
    return Player(
        firstName: firstName,
        lastName: lastName,
        number: number,
        clubId: clubId);
  }

  // Players are considered as identical if they have the same id
  @override
  bool operator ==(dynamic other) =>
      other != null && other is Player && id == other.id;
}
