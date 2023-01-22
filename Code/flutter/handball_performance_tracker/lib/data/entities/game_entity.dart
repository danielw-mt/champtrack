import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:handball_performance_tracker/data/models/models.dart';
import 'package:handball_performance_tracker/data/entities/entities.dart';
import 'package:handball_performance_tracker/data/repositories/repositories.dart';
import 'package:handball_performance_tracker/core/core.dart';

/// Representation of a club entry in firebase
class GameEntity extends Equatable {
  final DocumentReference? documentReference;
  final Timestamp? date;
  final bool? isAtHome;
  final String? lastSync;
  final String? location;
  final List<String>? onFieldPlayers;
  final String? opponent;
  final int? scoreHome;
  final int? scoreOpponent;
  final String? season;
  final int? startTime;
  final int?
      stopTime; // a game could be saved without a stop time (e.g. if the game is still in progress)
  final int? stopWatchTime;
  final String? teamId;
  final bool? attackIsLeft;
  final List<GameAction>? gameActions;
  final bool? isTestGame;

  GameEntity({
    this.documentReference,
    this.date,
    this.isAtHome,
    this.lastSync,
    this.location,
    this.onFieldPlayers,
    this.opponent,
    this.scoreHome,
    this.scoreOpponent,
    this.season,
    this.startTime,
    this.stopTime,
    this.stopWatchTime,
    this.teamId,
    this.attackIsLeft,
    this.gameActions,
    this.isTestGame,
  });

  Map<String, Object> toJson() {
    return {
      'documentReference': documentReference ?? Null,
      'date': date ?? Null,
      'isAtHome': isAtHome ?? Null,
      'lastSync': lastSync ?? Null,
      'location': location ?? Null,
      'onFieldPlayers': onFieldPlayers ?? Null,
      'opponent': opponent ?? Null,
      'scoreHome': scoreHome ?? Null,
      'scoreOpponent': scoreOpponent ?? Null,
      'season': season ?? Null,
      'startTime': startTime ?? Null,
      'stopTime': stopTime ?? Null,
      'stopWatchTime': stopWatchTime ?? Null,
      'teamId': teamId ?? Null,
      'attackIsLeft': attackIsLeft ?? Null,
      'gameActions': gameActions ?? Null,
      'isTestGame': isTestGame ?? Null,
    };
  }

  @override
  String toString() {
    return 'GameEntity { date: $date, isAtHome: $isAtHome, lastSync: $lastSync, location: $location, onFieldPlayers: ${onFieldPlayers.toString()}, opponent: $opponent, scoreHome: $scoreHome, scoreOpponent: $scoreOpponent, season: $season, startTime: $startTime, stopTime: $stopTime, stopWatchTime: $stopWatchTime, teamId: $teamId, attackIsLeft: $attackIsLeft, gameActions: ${gameActions.toString()}, isTestGame: $isTestGame }';
  }

  static Future<GameEntity> fromJson(Map<String, Object> json) async {
    DocumentReference clubReference = await getClubReference();
    DocumentReference gameReference =
        await clubReference.collection('games').doc(json['id'] as String);
    // build game action from game action in the json
    List<GameAction> gameActions = [];
    if (json['gameActions'] != null) {
      Map<String, dynamic> gameActionsJson =
          json['gameActions'] as Map<String, dynamic>;
      for (var entry in gameActionsJson.entries) {
        gameActions.add(GameAction.fromEntity(
            await GameActionEntity.fromJson(entry.value)));
      }
    }
    return GameEntity(
      documentReference: gameReference,
      date: json['date'] as Timestamp?,
      isAtHome: json['isAtHome'] as bool?,
      lastSync: json['lastSync'] as String?,
      location: json['location'] as String?,
      onFieldPlayers: json['onFieldPlayers'] as List<String>?,
      opponent: json['opponent'] as String?,
      scoreHome: json['scoreHome'] as int?,
      scoreOpponent: json['scoreOpponent'] as int?,
      season: json['season'] as String?,
      startTime: json['startTime'] as int?,
      stopTime: json['stopTime'] as int?,
      stopWatchTime: json['stopWatchTime'] as int?,
      teamId: json['teamId'] as String?,
      attackIsLeft: json['attackIsLeft'] as bool?,
      gameActions: gameActions,
      isTestGame: json['isTestGame'] as bool?,
    );
  }

  static Future<GameEntity> fromSnapshot(DocumentSnapshot snap) async {
    if (snap.exists) {
      Map<String, dynamic> data = snap.data() as Map<String, dynamic>;
      List<String> onFieldPlayers = [];
      if (data['onFieldPlayers'] != null) {
        data['onFieldPlayers'].forEach((player) {
          onFieldPlayers.add(player);
        });
      }
      // build all the game actions
      List<GameAction> gameActions =
          await GameFirebaseRepository().fetchActions(snap.reference.id);
      return GameEntity(
        documentReference: snap.reference,
        date: data['date'] != null ? data['date'] : Timestamp.now(),
        isAtHome: data['isAtHome'] != null ? data['isAtHome'] : true,
        lastSync: data['lastSync'] != null ? data['lastSync'] : "",
        location: data['location'] != null ? data['location'] : "",
        onFieldPlayers: onFieldPlayers,
        opponent: data['opponent'] != null ? data['opponent'] : "",
        scoreHome: data['scoreHome'] != null ? data['scoreHome'] : 0,
        scoreOpponent:
            data['scoreOpponent'] != null ? data['scoreOpponent'] : 0,
        season: data['season'] != null ? data['season'] : "",
        startTime: data['startTime'] != null ? data['startTime'] : 0,
        stopTime: data['stopTime'] != null ? data['stopTime'] : 0,
        stopWatchTime:
            data['stopWatchTime'] != null ? data['stopWatchTime'] : 0,
        teamId: data['teamId'] != null ? data['teamId'] : "",
        attackIsLeft:
            data['attackIsLeft'] != null ? data['attackIsLeft'] : true,
        gameActions: gameActions,
        isTestGame: data['isTestGame'] != null ? data['isTestGame'] : false,
      );
    }
    // this is in case that we are trying to access a game that does not exist anymore in the DB or could not be found
    return GameEntity();
  }

  // document for game only in firebase (does not include game actions collection)
  Map<String, Object?> toDocument() {
    Map<String, Object?> document = {
      'date': date != null ? date : "",
      'isAtHome': isAtHome != null ? isAtHome : true,
      'lastSync': lastSync != null ? lastSync : "",
      'location': location != null ? location : "",
      'onFieldPlayers': onFieldPlayers != null ? onFieldPlayers : [],
      'opponent': opponent != null ? opponent : "",
      'scoreHome': scoreHome != null ? scoreHome : 0,
      'scoreOpponent': scoreOpponent != null ? scoreOpponent : 0,
      'season': season != null ? season : "",
      'startTime': startTime != null ? startTime : 0,
      'stopTime': stopTime != null ? stopTime : 0,
      'stopWatchTime': stopWatchTime != null ? stopWatchTime : 0,
      'teamId': teamId != null ? teamId : "",
      'attackIsLeft': attackIsLeft != null ? attackIsLeft : true,
      'isTestGame': isTestGame != null ? isTestGame : false,
    };
    return document;
  }

  @override
  List<Object?> get props => [
        documentReference,
        date,
        isAtHome,
        lastSync,
        location,
        onFieldPlayers,
        opponent,
        scoreHome,
        scoreOpponent,
        season,
        startTime,
        stopTime,
        stopWatchTime,
        teamId,
        attackIsLeft,
        gameActions,
        isTestGame,
      ];
}
