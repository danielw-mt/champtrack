import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/data/player.dart';

import '../controllers/globalController.dart';

// TODO rename collection "player" to "players" and fix in firestore before merging to master
class DatabaseRepository {
  GlobalController globalController = Get.find<GlobalController>();
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
    return _db.collection("player").where("clubId", isEqualTo: globalController.currentClubId.value).snapshots();
  }
}
