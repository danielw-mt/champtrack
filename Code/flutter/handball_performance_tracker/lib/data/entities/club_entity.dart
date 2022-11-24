import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// Representation of a club entry in firebase
class ClubEntity extends Equatable {
  final String id;
  final String name;
  final Map<String, String>?roles;

  ClubEntity(this.id, this.name, this.roles);

  Map<String, Object> toJson() {
    // TODO roles
    return {
      'name': name,
      //'roles': ,
      'id': id,
    };
  }

  @override
  String toString() {
    return 'ClubEntity { name: $name, roles: ${roles.toString()}, id: $id }';
  }

  static ClubEntity fromJson(Map<String, Object> json) {
    // TODO serialize roles
    return ClubEntity(
      json['id'] as String,
      json['name'] as String,
      json['roles'] as Map<String, String>?,
    );
  }

  static ClubEntity fromSnapshot(DocumentSnapshot snap) {
    Map<String, dynamic> data = snap.data() as Map<String, dynamic>;
    // convert linkedmap to string string map
    Map<String, String> roles = {};
    data['roles'].forEach((key, value) {
      roles[key] = value;
    });
    return ClubEntity(
      snap.reference.id,
      data['name'] ?? null,
      roles,
    );
  }

  Map<String, Object?> toDocument() {
    return {
      'name': name,
      'roles': roles,
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
