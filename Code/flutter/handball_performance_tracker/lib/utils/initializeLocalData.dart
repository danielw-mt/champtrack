import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/player.dart';
import '../data/team.dart';
import '../data/database_repository.dart';
import 'package:get/get.dart';
import '../controllers/persistentController.dart';

Future<bool> initializeLocalData() async {
  persistentController appController = Get.find<persistentController>();
  DatabaseRepository repository = appController.repository;
  if (!appController.isInitialized) {
    print("initializing local data");
    List<Team> teamsList = [];
    // initialize all teams with corresponding player objects first and wait
    //for them to be built
    QuerySnapshot snapshot = await repository.getAllTeams();
    // go through every team document
    for (var element in snapshot.docs) {
      Map<String, dynamic> docData = element.data() as Map<String, dynamic>;
      List<Player> playerList = [];
      List<Player> onFieldList = [];
      // add all players in each team to the players list
      List<DocumentReference> players =
          docData["players"].cast<DocumentReference>();
      for (var documentReference in players) {
        DocumentSnapshot documentSnapshot = await documentReference.get();
        if (documentSnapshot.exists) {
          playerList.add(Player.fromDocumentSnapshot(documentSnapshot));
        }
      }
      // add each onFieldPlayer to the onFieldPlayers list
      List<DocumentReference> onFieldPlayers =
          docData["onFieldPlayers"].cast<DocumentReference>();
      for (var documentReference in onFieldPlayers) {
        DocumentSnapshot documentSnapshot = await documentReference.get();
        if (documentSnapshot.exists) {
          onFieldList.add(Player.fromDocumentSnapshot(documentSnapshot));
        }
      }
      print("adding team" + docData["name"]);
      teamsList.add(Team(
          id: element.reference.id,
          type: docData["type"],
          name: docData["name"],
          clubId: docData["clubId"],
          players: playerList,
          onFieldPlayers: onFieldList));
    }
    appController.updateAvailableTeams(teamsList);
    appController.isInitialized = true;
  }
  return true;
}
