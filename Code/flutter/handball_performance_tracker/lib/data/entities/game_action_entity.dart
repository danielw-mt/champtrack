import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:handball_performance_tracker/data/models/game_action_model.dart';

class GameActionEntity extends Equatable {
  final DocumentReference? documentReference;
  final String context;
  // TODO change to documentreference
  final String playerId;
  final String tag;
  List<String> throwLocation;
  final int timestamp;

  GameActionEntity({
    this.documentReference,
    this.context = "",
    this.playerId = "",
    this.tag = "",
    this.throwLocation = const [],
    this.timestamp = 0,
  }) {
    if (this.throwLocation.isEmpty) {
      this.throwLocation = [];
    }
  }

  Map<String, Object> toJson() {
    return {
      'documentReference': documentReference ?? "",
      'context': context,
      'playerId': playerId,
      'tag': tag,
      'throwLocation': throwLocation,
      'timestamp': timestamp,
    };
  }

  @override
  String toString() {
    return 'GameActionEntity { documentReference: $documentReference,  +\n ' +
        'context: $context,  +\n ' +
        'playerId: $playerId,  +\n ' +
        'tag: $tag,  +\n ' +
        'throwLocation: ${throwLocation.toString()},  +\n ' +
        'timestamp: $timestamp }';
  }

  static GameActionEntity fromJson(Map<String, Object> json) {
    return GameActionEntity(
      documentReference: json['documentReference'] as DocumentReference,
      context: json['context'] as String,
      playerId: json['playerId'] as String,
      tag: json['tag'] as String,
      throwLocation: json['throwLocation'] as List<String>,
      timestamp: json['timestamp'] as int,
    );
  }

  static GameActionEntity fromSnapshot(DocumentSnapshot snap) {
    if (snap.exists) {
      Map<String, dynamic> data = snap.data() as Map<String, dynamic>;

      List<String> throwLocation = [];
      if (data['throwLocation'] != null) {
        data['throwLocation'].forEach((player) {
          throwLocation.add(player);
        });
      }
      return GameActionEntity(
        documentReference: snap.reference,
        context: data['context'] as String,
        playerId: data['playerId'] as String,
        tag: data['tag'] as String,
        throwLocation: throwLocation,
        timestamp: data['timestamp'] as int,
      );
    }
    // this is in case that we are trying to access a game that does not exist anymore in the DB or could not be found
    return GameActionEntity();
  }

  Map<String, Object?> toDocument() {
    Map<String, Object?> document = {
      'context': context != "" ? context : "",
      'playerId': playerId != "" ? playerId : "",
      'tag': tag != "" ? tag : "",
      'throwLocation': throwLocation != [] ? throwLocation : [],
      'timestamp': timestamp != 0 ? timestamp : 0,
    };
    return document;
  }

  @override
  List<Object?> get props => [documentReference, context, playerId, tag, throwLocation, timestamp];
}
