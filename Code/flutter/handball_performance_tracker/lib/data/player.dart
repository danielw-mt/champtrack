import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'ef_score.dart';

class Player {
  String? id;
  String name;
  List<String> position;
  List<String> games;
  final String clubId;
  LiveEfScore efScore; 

  Player({
    this.id,
    this.name = "",
    this.position = const [],
    this.clubId = "",
    this.games = const []
  }) : efScore = LiveEfScore();

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'position': position,
      'clubId': clubId,
      'games': games
    };
  }

  factory Player.fromDocumentSnapshot(DocumentSnapshot doc) {
    final newPlayer = Player.fromMap(doc.data() as Map<String, dynamic>);
    newPlayer.id = doc.reference.id;
    return newPlayer;
  }

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      name: map["name"],
      position: map["position"].cast<String>(),
      clubId: map["clubId"],
      games: map["games"].cast<String>()
    );
  }
}
