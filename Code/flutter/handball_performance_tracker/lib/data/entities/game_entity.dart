import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:handball_performance_tracker/data/models/game_action_model.dart';

/// Representation of a club entry in firebase
class GameEntity extends Equatable {
  final DocumentReference documentReference;
  final List actions;
  final Timestamp date;
  final bool isAtHome;
  final String lastSync;
  final String location;
  final List<String> onFieldPlayers;
  final String opponent;
  final int scoreHome;
  final int scoreOpponent;
  final String season;
  final int startTime;
  final int stopTime;
  final int stopWatchTime;
  final String teamId;

  GameEntity(this.documentReference, this.actions, this.date, this.isAtHome, this.lastSync, this.location, this.onFieldPlayers, this.opponent, this.scoreHome,
      this.scoreOpponent, this.season, this.startTime, this.stopTime, this.stopWatchTime, this.teamId);

  Map<String, Object> toJson() {
    return {
      'documentReference': documentReference,
      'actions': actions,
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
    };
  }

  @override
  String toString() {
    return 'ClubEntity { actions: ${actions.toString()}, date: $date, isAtHome: $isAtHome, lastSync: $lastSync, location: $location, onFieldPlayers: ${onFieldPlayers.toString()}, opponent: $opponent, scoreHome: $scoreHome, scoreOpponent: $scoreOpponent, season: $season, startTime: $startTime, stopTime: $stopTime, stopWatchTime: $stopWatchTime, teamId: $teamId }';
  }

  static GameEntity fromJson(Map<String, Object> json) {
    // TODO probably parse actions
    return GameEntity(
      json['documentReference'] as DocumentReference,
      json['actions'] as List<DocumentSnapshot>,
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
    );
  }

  static GameEntity fromSnapshot(DocumentSnapshot snap) {
    Map<String, dynamic> data = snap.data() as Map<String, dynamic>;
    List<DocumentSnapshot> actions = [];
    data['actions'].forEach((action) {
      // TODO implement this. Might be complicated
    });
    List<String> onFieldPlayers = [];
    data['onFieldPlayers'].forEach((onFieldPlayerString) {
      onFieldPlayers.add(onFieldPlayerString);
    });
    return GameEntity(
      snap.reference,
      actions,
      data['date'],
      data['isAtHome'],
      data['lastSync'],
      data['location'],
      onFieldPlayers,
      data['opponent'],
      data['scoreHome'],
      data['scoreOpponent'],
      data['season'],
      data['startTime'],
      data['stopTime'],
      data['stopWatchTime'],
      data['teamId'],
    );
  }

  Map<String, Object?> toDocument() {
    return {
      'actions': actions,
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
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
