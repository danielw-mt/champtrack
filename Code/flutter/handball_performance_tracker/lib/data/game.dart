import 'package:cloud_firestore/cloud_firestore.dart';
import 'player.dart';

class Game {
  final String? id;
  final String club;
  DateTime date;
  int? startTime;
  int? stopTime;
  int? score;
  int? scoreOpponent;
  List<Player> players;

  Game(
      {this.id,
      required this.club,
      required this.date,
      this.startTime,
      this.stopTime,
      this.score,
      this.scoreOpponent,
      this.players = const []});

  Map<String, dynamic> toMap() {
    return {
      'club': club,
      'date': date,
      'startTime': startTime,
      'stopTime': stopTime,
      'score': score,
      'scoreOpponent': scoreOpponent,
      'players': players.map((player) => player.id).toList()
    };
  }

  Game.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        club = doc.data()!["club"],
        date = doc.data()!["date"],
        startTime = doc.data()!["startTime"],
        stopTime = doc.data()!["stopTime"],
        score = doc.data()!["score"],
        scoreOpponent = doc.data()!["scoreOpponent"],
        players = doc.data()!["players"];
}
