import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:handball_performance_tracker/data/models/game_action_model.dart';

/// Representation of a club entry in firebase
class GameEntity extends Equatable {
  final DocumentReference documentReference;
  // final List actions;
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
  final int? stopTime; // a game could be saved without a stop time (e.g. if the game is still in progress)
  final int? stopWatchTime;
  final String? teamId;
  final bool? attackIsLeft;

  GameEntity(this.documentReference, this.date, this.isAtHome, this.lastSync, this.location, this.onFieldPlayers, this.opponent, this.scoreHome,
      this.scoreOpponent, this.season, this.startTime, this.stopTime, this.stopWatchTime, this.teamId, this.attackIsLeft);

  Map<String, Object> toJson() {
    return {
      'documentReference': documentReference,
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
    };
  }

  @override
  String toString() {
    return 'GameEntity { date: $date, isAtHome: $isAtHome, lastSync: $lastSync, location: $location, onFieldPlayers: ${onFieldPlayers.toString()}, opponent: $opponent, scoreHome: $scoreHome, scoreOpponent: $scoreOpponent, season: $season, startTime: $startTime, stopTime: $stopTime, stopWatchTime: $stopWatchTime, teamId: $teamId, attackIsLeft: $attackIsLeft }';
  }

  static GameEntity fromJson(Map<String, Object> json) {
    // TODO probably parse actions
    return GameEntity(
      json['documentReference'] as DocumentReference,
      json['date'] as Timestamp,
      json['isAtHome'] as bool,
      json['lastSync'] as String,
      json['location'] as String,
      json['onFieldPlayers'] as List<String>,
      json['opponent'] as String,
      json['scoreHome'] as int,
      json['scoreOpponent'] as int,
      json['season'] as String,
      json['startTime'] as int,
      json['stopTime'] as int,
      json['stopWatchTime'] as int,
      json['teamId'] as String,
      json['attackIsLeft'] as bool,
    );
  }

  static GameEntity fromSnapshot(DocumentSnapshot snap) {
    if (snap.exists) {
      print("Game entity from snapshot " + snap.id);
      Map<String, dynamic> data = snap.data() as Map<String, dynamic>;
      // List<DocumentSnapshot> actions = [];
      // data['actions'].forEach((action) {
      //   // TODO implement this. Might be complicated
      // });
      List<String> onFieldPlayers = [];
      if (data['onFieldPlayers'] != null) {
        data['onFieldPlayers'].forEach((player) {
          onFieldPlayers.add(player);
        });
      }
      return GameEntity(
        snap.reference,
        data['date'] ?? null,
        data['isAtHome'] ?? null,
        data['lastSync'] ?? null,
        data['location'] ?? null,
        onFieldPlayers,
        data['opponent'] ?? null,
        data['scoreHome'] ?? null,
        data['scoreOpponent'] ?? null,
        data['season'] ?? null,
        data['startTime'] ?? null,
        data['stopTime'] ?? null,
        data['stopWatchTime'] ?? null,
        data['teamId'] ?? null,
        data['attackIsLeft'] ?? null,
      );
    }
    // this is in case that we are trying to access a game that does not exist anymore in the DB or could not be found
    return GameEntity(snap.reference, null, false, "", "", [], "Deleted / Invalid", -1, -1, "Deleted / Invalid", -1, -1, -1, "", false);
  }

  Map<String, Object?> toDocument() {
    return {
      'date': date,
      'isAtHome': isAtHome,
      'lastSync': lastSync,
      'location': location,
      'onFieldPlayers': onFieldPlayers,
      'opponent': opponent,
      'scoreHome': scoreHome,
      'scoreOpponent': scoreOpponent,
      'season': season,
      'startTime': startTime,
      'stopTime': stopTime,
      'stopWatchTime': stopWatchTime,
      'teamId': teamId,
      'attackIsLeft': attackIsLeft,
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
