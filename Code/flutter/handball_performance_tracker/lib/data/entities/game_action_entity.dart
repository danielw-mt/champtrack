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
  List<double> coordinates;

  GameActionEntity({
    this.documentReference,
    this.context = "",
    this.playerId = "",
    this.tag = "",
    this.throwLocation = const [],
    this.timestamp = 0,
    this.coordinates = const [],
  }) {
    if (this.throwLocation.isEmpty) {
      this.throwLocation = [];
    }
    if (this.coordinates.isEmpty) {
      this.coordinates = [0, 0];
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
        'coordinates: ${coordinates.toString()},  +\n ' +
        'timestamp: $timestamp }';
  }

  static GameActionEntity fromJson(Map<String, Object> json) {
    return GameActionEntity(
      documentReference: json['documentReference'] as DocumentReference,
      context: json['context'] as String,
      playerId: json['playerId'] as String,
      tag: json['tag'] as String,
      throwLocation: json['throwLocation'] as List<String>,
      coordinates: json['coordinates'] as List<double>,
      timestamp: json['timestamp'] as int,
    );
  }

  static GameActionEntity fromSnapshot(DocumentSnapshot snap) {
    if (snap.exists) {
      Map<String, dynamic> data = snap.data() as Map<String, dynamic>;

      List<String> throwLocation = [];
      if (data['throwLocation'] != null) {
        data['throwLocation'].forEach((String locationString) {
          throwLocation.add(locationString);
        });
      }
      List<double> coordinates = [data['coordinates'][0].toDouble(), data['coordinates'][1].toDouble()];
      return GameActionEntity(
        documentReference: snap.reference,
        context: data['context'] != null ? data['context'] as String : "",
        playerId: data['playerId'] != null ? data['playerId'] as String : "",
        tag: data['tag'] != null ? data['tag'] as String : "",
        throwLocation: throwLocation,
        coordinates: coordinates,
        timestamp: data['timestamp'] != null ? data['timestamp'] as int : -1,
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
      'coordinates': coordinates != [] ? coordinates : [],
      'timestamp': timestamp != 0 ? timestamp : 0,
    };
    return document;
  }

  @override
  List<Object?> get props => [documentReference, context, playerId, tag, throwLocation, coordinates, timestamp];
}
