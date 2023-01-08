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
    return 'Club { name: $name, +\n id: $id, +\n roles: $roles }';
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
}
