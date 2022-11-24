import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'dart:developer' as developer;

/// Representation of a club entry in firebase
class PlayerEntity extends Equatable {
  final DocumentReference documentReference;
  final String firstName;
  final String lastName;
  final String nickName;
  final int number;
  final List<String> positions;
  // TODO change this to document reference
  final List<String> teams;

  PlayerEntity(this.documentReference, this.firstName, this.lastName, this.nickName, this.number, this.positions, this.teams);

  Map<String, Object> toJson() {
    return {
      "documentReference": documentReference,
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
      json['documentReference'] as DocumentReference,
      json['firstName'] as String,
      json['lastName'] as String,
      json['nickName'] as String,
      json['number'] as int,
      json['positions'] as List<String>,
      json['teams'] as List<String>,
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
        snap.reference,
        data['firstName'] ?? null,
        data['lastName'] ?? null,
        data['nickName'] ?? null,
        data['number'] ?? null,
        positions,
        teams,
      );
    }
    // if the player snapshot does not exist it most likely means that the player is invalid or was deleted
    return PlayerEntity(snap.reference, "invalid / deleted", "invalid / deleted", "invalid / deleted", -1, [], []);
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
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
