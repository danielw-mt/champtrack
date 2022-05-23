import 'package:cloud_firestore/cloud_firestore.dart';
import 'player.dart';

class Game {
  String? id;
  final String clubId;
  DateTime date;
  int? startTime;
  int? stopTime;
  int? score;
  int? scoreOpponent;
  List<Player> players;

  Game(
      {this.id,
      this.clubId = "",
      required this.date,
      this.startTime,
      this.stopTime,
      this.score = 0,
      this.scoreOpponent = 0,
      this.players = const []});

  Map<String, dynamic> toMap() {
    return {
      'clubId': clubId,
      'date': date,
      'startTime': startTime,
      'stopTime': stopTime,
      'score': score,
      'scoreOpponent': scoreOpponent,
      'players': players.map((player) => player.id).toList()
    };
  }

  factory Game.fromDocumentSnapshot(DocumentSnapshot doc) {
    final newGame = Game.fromMap(doc.data() as Map<String, dynamic>);
    newGame.id = doc.reference.id;
    return newGame;
  }

  factory Game.fromMap(Map<String, dynamic> map) {
    return Game(
        clubId: map["clubId"],
        date: map["date"],
        startTime: map["startTime"],
        stopTime: map["stopTime"],
        score: map["score"],
        scoreOpponent: map["scoreOpponent"],
        players: map["players"].cast<String>());
  }
}
