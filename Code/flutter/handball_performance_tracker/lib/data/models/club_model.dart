import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handball_performance_tracker/data/entities/entities.dart';

class Club {
  final String id;
  final String name;
  final Map<String, String>? roles;

  const Club({this.id = "", this.name = "", this.roles = const {}});

  Club copyWith({String? id, String? name, Map<String, String>? roles}) {
    return Club(
      id: id ?? this.id,
      name: name ?? this.name,
      roles: roles ?? this.roles,
    );
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ roles.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Club && runtimeType == other.runtimeType && id == other.id && name == other.name && roles == other.roles;

  @override
  String toString() {
    return 'Club { name: $name, roles: ${roles.toString()}, id: $id }';
  }

  ClubEntity toEntity() {
    return ClubEntity(id, name, roles);
  }

  static Club fromEntity(ClubEntity entity) {
    return Club(
      id: entity.id,
      name: entity.name,
      roles: entity.roles,
    );
  }

  // // @return Map<String,dynamic> as representation of Club object that can be saved to firestore
  // Map<String, dynamic> toMap() {
  //   return {
  //     'name': name,
  //   };
  // }

  // // @return Club object according to Club data fetched from firestore
  // // @return Team object according to Team data fetched from firestore
  // factory Club.fromDocumentSnapshot(DocumentSnapshot doc) {
  //   Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
  //   final newClub = Club.fromMap(data);

  //   newClub.id = doc.reference.id;

  //   return newClub;
  // }

  // // @return Team object created from map representation of Team
  // factory Club.fromMap(Map<String, dynamic> map) {
  //   return Club(
  //     name: map["name"],
  //   );
  // }
}
