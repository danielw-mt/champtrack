import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:handball_performance_tracker/data/entities/entities.dart';
import 'package:handball_performance_tracker/data/models/models.dart';

class Game {
  String? id;
  String path;
  String? teamId;
  DateTime? date;
  int? startTime;
  int? stopTime;
  int? scoreHome;
  int? scoreOpponent;
  bool? isAtHome;
  String? location;
  String? opponent;
  String? season;
  String? lastSync;
  // TODO change this to document reference or actual players
  List<String>? onFieldPlayers;
  StopWatchTimer? stopWatchTimer;
  bool? attackIsLeft;
  List<GameAction> gameActions = [];

  Game(
      {this.id,
      this.path = "",
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
      this.onFieldPlayers = const [],
      this.attackIsLeft = true,
      stopWatchTimer,
      gameActions = const []}) {
    if (stopWatchTimer != null) {
      this.stopWatchTimer = stopWatchTimer;
    } else {
      this.stopWatchTimer = StopWatchTimer(mode: StopWatchMode.countUp);
    }
    if (gameActions.isEmpty) {
      this.gameActions = [];
    }
  }

  Game copyWith(
      {String? id,
      String? path,
      String? teamId,
      DateTime? date,
      int? startTime,
      int? stopTime,
      int? scoreHome,
      int? scoreOpponent,
      bool? isAtHome,
      String? location,
      String? opponent,
      String? season,
      String? lastSync,
      List<String>? onFieldPlayers,
      StopWatchTimer? stopWatchTimer,
      bool? attackIsLeft,
      List<GameAction>? gameActions}) {
    Game game = Game(
      id: id ?? this.id,
      path: path ?? this.path,
      teamId: teamId ?? this.teamId,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      stopTime: stopTime ?? this.stopTime,
      scoreHome: scoreHome ?? this.scoreHome,
      scoreOpponent: scoreOpponent ?? this.scoreOpponent,
      isAtHome: isAtHome ?? this.isAtHome,
      location: location ?? this.location,
      opponent: opponent ?? this.opponent,
      season: season ?? this.season,
      lastSync: lastSync ?? this.lastSync,
      onFieldPlayers: onFieldPlayers ?? this.onFieldPlayers,
      attackIsLeft: attackIsLeft ?? this.attackIsLeft,
      gameActions: gameActions ?? this.gameActions,
    );
    game.stopWatchTimer = stopWatchTimer ?? this.stopWatchTimer;
    return game;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      path.hashCode ^
      teamId.hashCode ^
      date.hashCode ^
      startTime.hashCode ^
      stopTime.hashCode ^
      scoreHome.hashCode ^
      scoreOpponent.hashCode ^
      isAtHome.hashCode ^
      location.hashCode ^
      opponent.hashCode ^
      season.hashCode ^
      lastSync.hashCode ^
      onFieldPlayers.hashCode ^
      stopWatchTimer.hashCode ^
      attackIsLeft.hashCode ^
      gameActions.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Game && id == other.id;
  @override
  String toString() {
    return 'Club { id: $id, +\n ' +
        'path: $path, +\n ' +
        'teamId: $teamId, +\n ' +
        'date: $date, +\n ' +
        'startTime: $startTime, +\n ' +
        'stopTime: $stopTime, +\n ' +
        'scoreHome: $scoreHome, +\n ' +
        'scoreOpponent: $scoreOpponent, +\n ' +
        'isAtHome: $isAtHome, +\n ' +
        'location: $location, +\n ' +
        'opponent: $opponent, +\n ' +
        'season: $season, +\n ' +
        'lastSync: $lastSync, +\n ' +
        'onFieldPlayers: $onFieldPlayers, +\n ' +
        'stopWatchTimer: $stopWatchTimer, +\n ' +
        'attackIsLeft: $attackIsLeft, +\n ' +
        '}';
  }

  GameEntity toEntity() {
    GameEntity gameEntity = GameEntity(
      date: this.date != null ? Timestamp.fromDate(this.date!) : Timestamp(0, 0),
      isAtHome: this.isAtHome != null ? this.isAtHome! : true,
      lastSync: this.lastSync != null ? this.lastSync! : "",
      location: this.location != null ? this.location! : "",
      onFieldPlayers: this.onFieldPlayers != null ? this.onFieldPlayers! : [],
      opponent: this.opponent != null ? this.opponent! : "",
      scoreHome: this.scoreHome != null ? this.scoreHome! : 0,
      scoreOpponent: this.scoreOpponent != null ? this.scoreOpponent! : 0,
      season: this.season != null ? this.season! : "",
      startTime: this.startTime != null ? this.startTime! : 0,
      stopTime: this.stopTime != null ? this.stopTime! : 0,
      stopWatchTime: stopWatchTimer != null ? stopWatchTimer!.rawTime.value : 0,
      teamId: this.teamId != null ? this.teamId! : "",
      attackIsLeft: this.attackIsLeft != null ? this.attackIsLeft! : true,
    );
    return gameEntity;
  }

  static Game fromEntity(GameEntity entity) {
    Game game = Game(
        id: entity.documentReference != null ? entity.documentReference!.id : null,
        path: entity.documentReference != null ? entity.documentReference!.path : "",
        teamId: entity.teamId,
        date: DateTime.fromMillisecondsSinceEpoch(entity.date!.millisecondsSinceEpoch),
        startTime: entity.startTime,
        stopTime: entity.stopTime,
        scoreHome: entity.scoreHome,
        scoreOpponent: entity.scoreOpponent,
        isAtHome: entity.isAtHome,
        location: entity.location,
        opponent: entity.opponent,
        season: entity.season,
        lastSync: entity.lastSync,
        onFieldPlayers: entity.onFieldPlayers,
        attackIsLeft: entity.attackIsLeft,
        gameActions: entity.gameActions);
    game.stopWatchTimer!.onExecute.add(StopWatchExecute.reset);
    game.stopWatchTimer!.setPresetTime(mSec: entity.stopWatchTime!);
    return game;
  }

  // @return Map<String,dynamic> as representation of Game object that can be saved to firestore
  // Map<String, dynamic> toMap() {
  //   return {
  //     'teamId': teamId,
  //     'date': date,
  //     'startTime': startTime,
  //     'stopTime': stopTime,
  //     'scoreHome': scoreHome,
  //     'scoreOpponent': scoreOpponent,
  //     'isAtHome': isAtHome,
  //     'location': location,
  //     'opponent': opponent,
  //     'season': season,
  //     'onFieldPlayers': onFieldPlayers,
  //     'lastSync': lastSync,
  //     'stopWatchTime': stopWatchTimer.rawTime.value
  //   };
  // }

  // @return Game object according to Game data fetched from firestore
  // factory Game.fromDocumentSnapshot(DocumentSnapshot doc) {
  //   final newGame = Game.fromMap(doc.data() as Map<String, dynamic>);
  //   newGame.id = doc.reference.id;
  //   return newGame;
  // }

  // @return Game object created from map representation of Game
  // factory Game.fromMap(Map<String, dynamic> map) {
  //   int lastStopWatchTime = map['stopWatchTime'];
  //   StopWatchTimer stopWatchTimer = StopWatchTimer(mode: StopWatchMode.countUp);
  //   stopWatchTimer.onExecute.add(StopWatchExecute.reset);
  //   stopWatchTimer.setPresetTime(mSec: lastStopWatchTime);
  //   // convert date
  //   Timestamp dateTimestamp = map["date"];
  //   DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
  //       dateTimestamp.millisecondsSinceEpoch);
  //   Game game = Game(
  //       teamId: map["teamId"],
  //       date: dateTime,
  //       startTime: map["startTime"],
  //       stopTime: map["stopTime"],
  //       scoreHome: map["scoreHome"],
  //       scoreOpponent: map["scoreOpponent"],
  //       isAtHome: map["isAtHome"],
  //       location: map["location"],
  //       opponent: map["opponent"],
  //       season: map["season"],
  //       lastSync: map["lastSync"],
  //       onFieldPlayers: map["onFieldPlayers"].cast<String>());
  //   game.stopWatchTimer = stopWatchTimer;

  //   return game;
  // }
}
