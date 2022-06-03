import 'package:cloud_firestore/cloud_firestore.dart';

class Team {
  final String? id;
  final String name;

  Team({
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
  Team.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        name = doc.data()!["name"];
}
