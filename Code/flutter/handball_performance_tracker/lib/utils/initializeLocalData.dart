import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/player.dart';
import '../data/team.dart';
import '../data/database_repository.dart';
import 'package:get/get.dart';
import '../controllers/persistentController.dart';
import '../controllers/tempController.dart';

Future<bool> initializeLocalData() async {
  PersistentController persistentController = Get.find<PersistentController>();
  DatabaseRepository repository = persistentController.repository;
  if (!persistentController.isInitialized) {
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
          String playerId = documentSnapshot.reference.id;
          // add references from playerList to onFieldList
          onFieldList
              .add(playerList.firstWhere((player) => player.id == playerId));
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
    persistentController.updateAvailableTeams(teamsList);
    persistentController.isInitialized = true;

    // initialize club
    persistentController.setLoggedInClub(await repository.getClub());

    // set the default selected team to be the first one available
    TempController tempController = Get.find<TempController>();
    tempController.setSelectedTeam(persistentController.getAvailableTeams()[0]);
    tempController.setPlayingTeam(persistentController.getAvailableTeams()[0]);

  }
  return true;
}
