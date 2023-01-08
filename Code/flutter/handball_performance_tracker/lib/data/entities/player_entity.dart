import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'dart:developer' as developer;

/// Representation of a club entry in firebase
class PlayerEntity extends Equatable {
  final DocumentReference? documentReference;
  final String firstName;
  final String lastName;
  final String nickName;
  final int number;
  List<String> positions = [];
  // TODO change this to document reference
  List<String> teams = [];

  PlayerEntity(
      {this.documentReference,
      this.firstName = "",
      this.lastName = "",
      this.nickName = "",
      this.number = -1,
      List<String> positions = const [],
      List<String> teams = const []}) {
    if (!positions.isEmpty) {
      this.positions = positions;
    }
    if (!teams.isEmpty) {
      this.teams = teams;
    }
  }

  Map<String, Object> toJson() {
    return {
      "documentReference": documentReference ?? Null,
      'firstName': firstName,
      'lastName': lastName,
      'nickName': nickName,
      'number': number,
      'positions': positions,
      'teams': teams,
    };
  }

  @override
  String toString() {
    return 'PlayerEntity { firstName: $firstName, lastName: $lastName, nickName: $nickName, number: $number, positions: ${positions.toString()}, teams: ${teams.toString()}}';
  }

  static PlayerEntity fromJson(Map<String, Object> json) {
    return PlayerEntity(
      documentReference: json['documentReference'] as DocumentReference,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      nickName: json['nickName'] as String,
      number: json['number'] as int,
      positions: json['positions'] as List<String>,
      teams: json['teams'] as List<String>,
    );
  }

  static PlayerEntity fromSnapshot(DocumentSnapshot snap) {
    if (snap.exists) {
      // developer.log('fromSnapshot ${snap.id}', name: 'PlayerEntity');
      Map<String, dynamic> data = snap.data() as Map<String, dynamic>;
      // convert linkedmap to string string map
      List<String> positions = [];
      if (data['positions'] != null) {
        data['positions'].forEach((position) {
          positions.add(position);
        });
      }
      List<String> teams = [];
      if (data['teams'] != null) {
        data['teams'].forEach((team) {
          teams.add(team);
        });
      }
      return PlayerEntity(
        documentReference: snap.reference,
        firstName: data['firstName'] ?? null,
        lastName: data['lastName'] ?? null,
        nickName: data['nickName'] ?? null,
        number: data['number'] ?? null,
        positions: positions,
        teams: teams,
      );
    }
    // if the player snapshot does not exist it most likely means that the player is invalid or was deleted
    // return PlayerEntity(snap.reference, "invalid / deleted", "invalid / deleted", "invalid / deleted", -1, [], []);
    return PlayerEntity(
        documentReference: snap.reference,
        firstName: "invalid / deleted",
        lastName: "invalid / deleted",
        nickName: "invalid / deleted",
        number: -1,
        positions: [],
        teams: []);
  }

  Map<String, Object?> toDocument() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'nickName': nickName,
      'number': number,
      'positions': positions,
      'teams': teams,
    };
  }

  @override
  List<Object?> get props => [documentReference, firstName, lastName, nickName, number, positions, teams];
}
