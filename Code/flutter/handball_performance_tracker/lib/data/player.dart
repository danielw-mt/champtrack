import 'package:cloud_firestore/cloud_firestore.dart';
import 'club.dart';
import 'ef_score.dart';

class Player {
  final String? id;
  final String name;
  List<String> position;
  final Club club;
  LiveEfScore efScore; 

  Player({
    this.id,
    required this.name,
    required this.position,
    required this.club,
  }) : efScore = LiveEfScore();

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'position': position,
      'club': club.toMap(),
    };
  }

  Player.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        name = doc.data()!["name"],
        position = doc.data()!["position"],
        club = doc.data()!["club"],
        efScore = LiveEfScore();
}
