import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'player.dart';

class Game {
  String? id;
  final String clubId;
  DateTime date;
  int? startTime;
  int? stopTime;
  int? scoreHome;
  int? scoreOpponent;
  List<Player> players;
  StopWatchTimer stopWatch; 

  Game(
      {this.id,
      this.clubId = "",
      required this.date,
      this.startTime,
      this.stopTime,
      this.scoreHome = 0,
      this.scoreOpponent = 0,
      this.players = const []}):stopWatch = StopWatchTimer(mode: StopWatchMode.countUp);

  // @return Map<String,dynamic> as representation of Game object that can be saved to firestore
  Map<String, dynamic> toMap() {
    return {
      'clubId': clubId,
      'date': date,
      'startTime': startTime,
      'stopTime': stopTime,
      'scoreHome': scoreHome,
      'scoreOpponent': scoreOpponent,
      'players': players.map((player) => player.id).toList()
    };
  }

  // @return Game object according to Game data fetched from firestore
  factory Game.fromDocumentSnapshot(DocumentSnapshot doc) {
    final newGame = Game.fromMap(doc.data() as Map<String, dynamic>);
    newGame.id = doc.reference.id;
    return newGame;
  }

  // @return Game object created from map representation of Game
  factory Game.fromMap(Map<String, dynamic> map) {
    return Game(
        clubId: map["clubId"],
        date: map["date"],
        startTime: map["startTime"],
        stopTime: map["stopTime"],
        scoreHome: map["scoreHome"],
        scoreOpponent: map["scoreOpponent"],
        players: map["players"].cast<String>());
  }
}
