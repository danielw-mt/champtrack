import 'package:cloud_firestore/cloud_firestore.dart';

class Club {
  final String? id;
  final String name;

  Club({
    this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }

  Club.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        name = doc.data()!["name"];
}
