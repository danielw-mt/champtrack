import 'package:cloud_firestore/cloud_firestore.dart';

class Club {
  String? id;
  String name;

  Club({
    this.id,
    this.name = "default club",
  });

  // @return Map<String,dynamic> as representation of Club object that can be saved to firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }

  // @return Club object according to Club data fetched from firestore
  // @return Team object according to Team data fetched from firestore
  factory Club.fromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    final newClub = Club.fromMap(data);

    newClub.id = doc.reference.id;

    return newClub;
  }

  // @return Team object created from map representation of Team
  factory Club.fromMap(Map<String, dynamic> map) {
    return Club(
        name: map["name"],
    );
  }
}
