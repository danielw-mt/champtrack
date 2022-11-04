import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// Representation of a club entry in firebase
class TeamEntity extends Equatable {
  final String id;
  final String name;
  final List<DocumentReference> onFieldPlayers;
  final List<DocumentReference> players;
  final String type;

  TeamEntity(this.id, this.name, this.onFieldPlayers, this.players, this.type);

  Map<String, Object> toJson() {
    return {
      'id': id,
      'name': name,
      'onFieldPlayers': onFieldPlayers,
      'players': players,
      'type': type,
    };
  }

  @override
  String toString() {
    return 'ClubEntity { name: $name, onFieldPlayers: ${onFieldPlayers.toString()}, players: ${players.toString()}, type: $type, id: $id }';
  }

  static TeamEntity fromJson(Map<String, Object> json) {
    return TeamEntity(
      json['id'] as String,
      json['name'] as String,
      json['onFieldPlayers'] as List<DocumentReference>,
      json['players'] as List<DocumentReference>,
      json['type'] as String,
    );
  }

  static TeamEntity fromSnapshot(DocumentSnapshot snap) {
    Map<String, dynamic> data = snap.data() as Map<String, dynamic>;
    // convert linkedmap to string string map
    List<DocumentReference> onFieldPlayers = [];
    data['onFieldPlayers'].forEach((onFieldPlayerReference) {
      onFieldPlayers.add(onFieldPlayerReference);
    });
    List<DocumentReference> players = [];
    data['players'].forEach((playerReference) {
      players.add(playerReference);
    });
    return TeamEntity(
      snap.reference.id,
      data['name'],
      onFieldPlayers,
      players,
      data['type'],
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
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
