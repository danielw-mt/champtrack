import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'dart:developer' as developer;

/// Representation of a club entry in firebase
class TeamEntity extends Equatable {
  final DocumentReference? documentReference;
  final String name;
  final List<DocumentReference> onFieldPlayers;
  final List<DocumentReference>players;
  final String type;

  TeamEntity(this.documentReference, this.name, this.onFieldPlayers, this.players, this.type);

  Map<String, Object> toJson() {
    return {
      'documentReference': documentReference!,
      'name': name,
      'onFieldPlayers': onFieldPlayers,
      'players': players,
      'type': type,
    };
  }

  @override
  String toString() {
    return 'TeamEntity { name: $name, onFieldPlayers: ${onFieldPlayers.toString()}, players: ${players.toString()}, type: $type}';
  }

  static TeamEntity fromJson(Map<String, Object> json) {
    return TeamEntity(
      json['documentReference'] as DocumentReference,
      json['name'] as String,
      json['onFieldPlayers'] as List<DocumentReference>,
      json['players'] as List<DocumentReference>,
      json['type'] as String,
    );
  }

  static TeamEntity fromSnapshot(DocumentSnapshot snap) {
    Map<String, dynamic> data = snap.data() as Map<String, dynamic>;
    List<DocumentReference> onFieldPlayerReferences = [];
    data['onFieldPlayers'].forEach((onFieldPlayerReference) {
      onFieldPlayerReferences.add(onFieldPlayerReference);
    });
    List<DocumentReference> playerReferences = [];
    data['players'].forEach((playerReference) {
      playerReferences.add(playerReference);
    });
    developer.log("onFieldPlayers: ${onFieldPlayerReferences.toString()}", name: "TeamEntity");
    developer.log("players: "+playerReferences.toString(), name: "TeamEntity");
    return TeamEntity(
      snap.reference,
      data['name'] ?? null,
      onFieldPlayerReferences,
      playerReferences,
      data['type'] ?? null,
    );
  }

  Map<String, Object?> toDocument() {
    return {
      'name': name,
      'onFieldPlayers': onFieldPlayers,
      'players': players,
      'type': type,
    };
  }

  @override
  List<Object?> get props => [documentReference, name, onFieldPlayers, players, type];
}
