import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/player.dart';
import '../data/team.dart';
import '../data/database_repository.dart';
import 'package:get/get.dart';
import '../controllers/persistentController.dart';
import '../controllers/tempController.dart';
import '../data/club.dart';

Future<bool> initializeLocalData() async {
  PersistentController persistentController = Get.find<PersistentController>();
  DatabaseRepository repository = persistentController.repository;
  // if the isInitialized variable is false in persistentController the initializeLocalData method has not finished successfully before
  if (!persistentController.isInitialized) {
    Club loggedInClub = await repository.initializeLoggedInClub();
    print(loggedInClub.name);
    persistentController.setLoggedInClub(loggedInClub);
    print("initializing local data");
    List<Team> teamsList = [];
    // initialize all teams with corresponding player objects first and wait
    //for them to be built
    QuerySnapshot teamsSnapshot = await repository.getTeams();
    QuerySnapshot playersSnapshot = await repository.getAllPlayers();
    // go through every team document
    for (DocumentSnapshot teamDocumentSnapshot in teamsSnapshot.docs) {
      Map<String, dynamic> docData = teamDocumentSnapshot.data() as Map<String, dynamic>;
      List<Player> playerList = [];
      List<Player> onFieldList = [];
      // add all players in each team to the players list
      List<DocumentReference> playerReferences =
          docData["players"].cast<DocumentReference>();
      for (DocumentReference playerReference in playerReferences) {
        playersSnapshot.docs.forEach((playerSnapshot) {
          if (playerSnapshot.id == playerReference.id.toString()) {
            playerList.add(Player.fromDocumentSnapshot(playerSnapshot));
          }
        });
      }
      // add each onFieldPlayer to the onFieldPlayers list
      List<DocumentReference> onFieldPlayers =
          docData["onFieldPlayers"].cast<DocumentReference>();
      for (DocumentReference playerReference in onFieldPlayers) {
        playersSnapshot.docs.forEach((playerSnapshot) {
          if (playerSnapshot.id == playerReference.id.toString()) {
            onFieldList.add(Player.fromDocumentSnapshot(playerSnapshot));
          }
        });
      }
      logger.d("adding team: " + docData["name"]);
      teamsList.add(Team(
          id: teamDocumentSnapshot.reference.id,
          type: docData["type"],
          name: docData["name"],
          players: playerList,
          onFieldPlayers: onFieldList));
    }
    persistentController.updateAvailableTeams(teamsList);
    persistentController.isInitialized = true;

    // set the default selected team to be the first one available
    TempController tempController = Get.find<TempController>();
    tempController.setSelectedTeam(persistentController.getAvailableTeams()[0]);
    tempController.setPlayingTeam(persistentController.getAvailableTeams()[0]);

    // run a test whether a previous game exists already
    bool gameWithinLast20Mins =
        await repository.isThereAGameWithinLastMinutes(20);
    if (gameWithinLast20Mins) {
      tempController.setOldGameStateExists(true);
    }
  }
  return true;
}

void recreateLocalState() {}
