import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handball_performance_tracker/data/player.dart';

class DatabaseRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<DocumentReference> addPlayer(Player player){
    return _db.collection("player").add(player.toMap());
  }

  void updatePlayer(Player player) async {
    await _db.collection("player").doc(player.id).update(player.toMap());
  }

  void deletePlayer(String documentId) async {
    await _db.collection("player").doc(documentId).delete();
  }

  Stream<QuerySnapshot> getPlayerStream() {
    return _db.collection("player").snapshots();
  }
}
