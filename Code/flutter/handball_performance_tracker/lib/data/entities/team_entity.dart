import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:equatable/equatable.dart';
import 'package:handball_performance_tracker/core/core.dart';
import 'dart:developer' as developer;

/// Representation of a club entry in firebase
class TeamEntity extends Equatable {
  final DocumentReference? documentReference;
  final String name;
  List<DocumentReference> onFieldPlayers = [];
  List<DocumentReference> players = [];
  final String type;

  TeamEntity(
      {this.documentReference,
      this.name = "",
      List<DocumentReference> onFieldPlayers = const [],
      List<DocumentReference> players = const [],
      this.type = ""}) {
    if (!onFieldPlayers.isEmpty) {
      this.onFieldPlayers = onFieldPlayers;
    }
    if (!players.isEmpty) {
      this.players = players;
    }
  }

  // Map<String, Object> toJson() {
  //   return {
  //     'documentReference': documentReference!,
  //     'name': name,
  //     'onFieldPlayers': onFieldPlayers,
  //     'players': players,
  //     'type': type,
  //   };
  // }

  @override
  String toString() {
    return 'TeamEntity { name: $name, onFieldPlayers: ${onFieldPlayers.toString()}, players: ${players.toString()}, type: $type}';
  }

  static TeamEntity fromJson(Map<String, Object> json) async {
    DocumentReference clubReference = await getClubReference();
    DocumentReference teamReference = clubReference.collection("teams").doc(json['id'].toString());
    return TeamEntity(
      documentReference: teamReference,
      name: json['name'] as String,
      onFieldPlayers: [],
      
      json['players'] as List<DocumentReference>,
      json['type'] as String,
    );
  }

  static Future<TeamEntity> fromSnapshot(DocumentSnapshot snap) async {
    Map<String, dynamic> data = snap.data() as Map<String, dynamic>;

    List<DocumentReference> onFieldPlayerReferences = [];
    if (data['onFieldPlayers'] != null) {
      List<DocumentReference> documentReferences = data['onFieldPlayers'].cast<DocumentReference>();
      await Future.forEach(documentReferences, (DocumentReference onFieldPlayerReference) async {
        if (!onFieldPlayerReference.path.contains("club")) {
          DocumentReference clubReference = await getClubReference();
          String newPlayerPath = onFieldPlayerReference.path.replaceFirst("players", "clubs/${clubReference.id}/players");
          onFieldPlayerReferences.add(FirebaseFirestore.instance.doc(newPlayerPath));
        } else {
          onFieldPlayerReferences.add(onFieldPlayerReference);
        }
      });
    }
    List<DocumentReference> playerReferences = [];
    if (data['players'] != null) {
      List<DocumentReference> documentReferences = data['players'].cast<DocumentReference>();
      await Future.forEach(documentReferences, (DocumentReference playerReference) async {
        if (!playerReference.path.contains("club")) {
          print("player reference not ok: ${playerReference.path}");
          DocumentReference clubReference = await getClubReference();
          String newPlayerPath = playerReference.path.replaceFirst("players", "clubs/${clubReference.id}/players");
          playerReferences.add(FirebaseFirestore.instance.doc(newPlayerPath));
        } else {
          playerReferences.add(playerReference);
        }
      });
    }
    developer.log("onFieldPlayers: ${onFieldPlayerReferences.toString()}", name: "TeamEntity");
    developer.log("players: " + playerReferences.toString(), name: "TeamEntity");
    return TeamEntity(
      documentReference: snap.reference,
      name: data['name'] ?? "",
      onFieldPlayers: onFieldPlayerReferences,
      players: playerReferences,
      type: data['type'] ?? "",
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
