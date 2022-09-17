import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class Game {
  String? id;
  String teamId;
  DateTime date;
  int? startTime;
  int? stopTime;
  int? scoreHome;
  int? scoreOpponent;
  bool? isAtHome;
  String? location;
  String? opponent;
  String? season;
  String? lastSync;
  List<String> onFieldPlayers;
  StopWatchTimer stopWatchTimer;

  Game(
      {this.id,
      this.teamId = "",
      required this.date,
      this.startTime,
      this.stopTime,
      this.scoreHome = 0,
      this.scoreOpponent = 0,
      this.isAtHome = true,
      this.location = "",
      this.opponent = "",
      this.season = "",
      this.lastSync = "",
      this.onFieldPlayers = const []})
      : stopWatchTimer = StopWatchTimer(mode: StopWatchMode.countUp);

  // @return Map<String,dynamic> as representation of Game object that can be saved to firestore
  Map<String, dynamic> toMap() {
    return {
      'teamId': teamId,
      'date': date,
      'startTime': startTime,
      'stopTime': stopTime,
      'scoreHome': scoreHome,
      'scoreOpponent': scoreOpponent,
      'isAtHome': isAtHome,
      'location': location,
      'opponent': opponent,
      'season': season,
      'onFieldPlayers': onFieldPlayers,
      'lastSync': lastSync,
      'stopWatchTime': stopWatchTimer.rawTime.value
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
    int lastStopWatchTime = map['stopWatchTime'];
    StopWatchTimer stopWatchTimer = StopWatchTimer(mode: StopWatchMode.countUp);
    stopWatchTimer.onExecute.add(StopWatchExecute.reset);
    stopWatchTimer.setPresetTime(mSec: lastStopWatchTime);
    // convert date
    Timestamp dateTimestamp = map["date"];
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
        dateTimestamp.millisecondsSinceEpoch);
    Game game = Game(
        teamId: map["teamId"],
        date: dateTime,
        startTime: map["startTime"],
        stopTime: map["stopTime"],
        scoreHome: map["scoreHome"],
        scoreOpponent: map["scoreOpponent"],
        isAtHome: map["isAtHome"],
        location: map["location"],
        opponent: map["opponent"],
        season: map["season"],
        lastSync: map["lastSync"],
        onFieldPlayers: map["onFieldPlayers"].cast<String>());
    game.stopWatchTimer = stopWatchTimer;
    return game;
  }
}
