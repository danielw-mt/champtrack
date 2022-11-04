import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// Representation of a club entry in firebase
class PlayerEntity extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String nickName;
  final int number;
  final List<String> positions;
  // TODO change this to document reference
  final List<String> teams;

  PlayerEntity(this.id, this.firstName, this.lastName, this.nickName, this.number, this.positions, this.teams);

  Map<String, Object> toJson() {
    return {
      'id': id,
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
    return 'ClubEntity { firstName: $firstName, lastName: $lastName, nickName: $nickName, number: $number, positions: ${positions.toString()}, teams: ${teams.toString()}, id: $id }';
  }

  static PlayerEntity fromJson(Map<String, Object> json) {
    return PlayerEntity(
      json['id'] as String,
      json['firstName'] as String,
      json['lastName'] as String,
      json['nickName'] as String,
      json['number'] as int,
      json['positions'] as List<String>,
      json['teams'] as List<String>,
    );
  }

  static PlayerEntity fromSnapshot(DocumentSnapshot snap) {
    Map<String, dynamic> data = snap.data() as Map<String, dynamic>;
    // convert linkedmap to string string map
    List<String> positions = [];
    data['positions'].forEach((positionString) {
      positions.add(positionString);
    });
    List<String> teams = [];
    data['teams'].forEach((teamString) {
      teams.add(teamString);
    });
    return PlayerEntity(
      snap.reference.id,
      data['firstName'],
      data['lastName'],
      data['nickName'],
      data['number'],
      positions,
      teams,
    );
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
