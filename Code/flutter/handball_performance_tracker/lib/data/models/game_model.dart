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
  List<String> onFieldPlayers = [];
  StopWatchTimer? stopWatchTimer;
  bool? attackIsLeft;
  List<GameAction> gameActions = [];
  bool? isTestGame;

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
      List<String> onFieldPlayers = const [],
      this.attackIsLeft = true,
      stopWatchTimer,
      List<GameAction> gameActions = const [],
      this.isTestGame = false}) {
    if (stopWatchTimer != null) {
      this.stopWatchTimer = stopWatchTimer;
    } else {
      this.stopWatchTimer = StopWatchTimer(mode: StopWatchMode.countUp);
    }
    if (!onFieldPlayers.isEmpty) {
      this.onFieldPlayers = onFieldPlayers;
    }
    if (!gameActions.isEmpty) {
      this.gameActions = gameActions;
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
      List<GameAction>? gameActions,
      bool? isTestGame}) {
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
      isTestGame: isTestGame ?? this.isTestGame,
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
      isTestGame.hashCode ^
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
    return 'Game { id: $id, +\n ' +
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
        'gameActions: $gameActions, +\n ' +
        'gameActionslength: ${gameActions.length}, +\n'
            'isTestGame: $isTestGame, +\n ' +
        '}';
  }

  GameEntity toEntity() {
    GameEntity gameEntity = GameEntity(
      date: this.date != null ? Timestamp.fromDate(this.date!) : Timestamp(0, 0),
      isAtHome: this.isAtHome != null ? this.isAtHome! : true,
      lastSync: this.lastSync != null ? this.lastSync! : "",
      location: this.location != null ? this.location! : "",
      onFieldPlayers: this.onFieldPlayers,
      opponent: this.opponent != null ? this.opponent! : "",
      scoreHome: this.scoreHome != null ? this.scoreHome! : 0,
      scoreOpponent: this.scoreOpponent != null ? this.scoreOpponent! : 0,
      season: this.season != null ? this.season! : "",
      startTime: this.startTime != null ? this.startTime! : 0,
      stopTime: this.stopTime != null ? this.stopTime! : 0,
      stopWatchTime: stopWatchTimer != null ? stopWatchTimer!.rawTime.value : 0,
      teamId: this.teamId != null ? this.teamId! : "",
      attackIsLeft: this.attackIsLeft != null ? this.attackIsLeft! : true,
      isTestGame: this.isTestGame != null ? this.isTestGame! : false,
    );
    return gameEntity;
  }

  static Game fromEntity(GameEntity entity) {
    DateTime date;
    if (entity.date != null) {
      date = DateTime.fromMillisecondsSinceEpoch(entity.date!.millisecondsSinceEpoch);
    } else {
      date = DateTime.now();
    }
    Game game = Game(
        id: entity.documentReference != null ? entity.documentReference!.id : null,
        path: entity.documentReference != null ? entity.documentReference!.path : "",
        teamId: entity.teamId != null ? entity.teamId! : "",
        date: date,
        startTime: entity.startTime != null ? entity.startTime! : 0,
        stopTime: entity.stopTime != null ? entity.stopTime! : 0,
        scoreHome: entity.scoreHome != null ? entity.scoreHome! : 0,
        scoreOpponent: entity.scoreOpponent != null ? entity.scoreOpponent! : 0,
        isAtHome: entity.isAtHome != null ? entity.isAtHome! : true,
        location: entity.location != null ? entity.location! : "",
        opponent: entity.opponent != null ? entity.opponent! : "",
        season: entity.season != null ? entity.season! : "",
        lastSync: entity.lastSync != null ? entity.lastSync! : "",
        onFieldPlayers: entity.onFieldPlayers != null ? entity.onFieldPlayers! : [],
        attackIsLeft: entity.attackIsLeft != null ? entity.attackIsLeft! : true,
        gameActions: entity.gameActions != null ? entity.gameActions! : [],
        isTestGame: entity.isTestGame != null ? entity.isTestGame! : false);
    game.stopWatchTimer!.onExecute.add(StopWatchExecute.reset);
    game.stopWatchTimer!.setPresetTime(mSec: entity.stopWatchTime!);
    return game;
  }
}
