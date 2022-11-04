import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/models/player_model.dart';
import '../data/models/team_model.dart';
import '../data/database_repository.dart';
import 'package:get/get.dart';
import '../oldcontrollers/persistent_controller.dart';
import '../oldcontrollers/temp_controller.dart';
import '../data/models/club_model.dart';
import '../data/models/game_model.dart';

Future<bool> initializeLocalData() async {
  PersistentController persistentController = Get.find<PersistentController>();
  DatabaseRepository repository = persistentController.repository;
  // if the isInitialized variable is false in persistentController the initializeLocalData method has not finished successfully before
  Club loggedInClub = await repository.getClub();
  if (!persistentController.isInitialized) {
    print(loggedInClub.name);
    persistentController.setLoggedInClub(loggedInClub);
    print("initializing local data");
    List<Team> teamsList = [];
    // initialize all teams with corresponding player objects first and wait
    //for them to be built
    QuerySnapshot teamsSnapshot = await repository.getTeams();
    // make sure initialization doesn't break if there are no teams
    if (teamsSnapshot.docs.isEmpty) {
      print("no teams found");
      return false;
    }
    QuerySnapshot playersSnapshot = await repository.getAllPlayers();
    // make sure initialization doesn't break if there are no players
    if (playersSnapshot.docs.isEmpty) {
      print("no players found");
    } else {
      List<Player> players = [];
      playersSnapshot.docs.forEach((QueryDocumentSnapshot playerSnapshot) {
        players.add(Player.fromDocumentSnapshot(playerSnapshot));
      });
      persistentController.setAllPlayers(players);
    }
    QuerySnapshot gamesSnapshot = await repository.getAllGames();
    // make sure initialization doesn't break if there are no games
    if (gamesSnapshot.docs.isEmpty) {
      print("no games found");
    } else {
      List<Game> gamesList = [];
      for (QueryDocumentSnapshot game in gamesSnapshot.docs) {
        gamesList.add(Game.fromDocumentSnapshot(game));
      }
      persistentController.setAllGames(gamesList);
    }
    // go through every team document
    for (DocumentSnapshot teamDocumentSnapshot in teamsSnapshot.docs) {
      Map<String, dynamic> docData = teamDocumentSnapshot.data() as Map<String, dynamic>;
      List<Player> playerList = [];
      List<Player> onFieldList = [];
      // add all players in each team to the players list
      List<DocumentReference> playerReferences = docData["players"].cast<DocumentReference>();
      for (DocumentReference playerReference in playerReferences) {
        playersSnapshot.docs.forEach((playerSnapshot) {
          if (playerSnapshot.id == playerReference.id.toString()) {
            playerList.add(Player.fromDocumentSnapshot(playerSnapshot));
          }
        });
      }
      // add each onFieldPlayer to the onFieldPlayers list
      List<DocumentReference> onFieldPlayers = docData["onFieldPlayers"].cast<DocumentReference>();
      for (DocumentReference playerReference in onFieldPlayers) {
        playersSnapshot.docs.forEach((playerSnapshot) {
          if (playerSnapshot.id == playerReference.id.toString()) {
            onFieldList.add(Player.fromDocumentSnapshot(playerSnapshot));
          }
        });
      }
      logger.d("adding team: " + docData["name"]);
      teamsList.add(Team(
          id: teamDocumentSnapshot.reference.id, type: docData["type"], name: docData["name"], players: playerList, onFieldPlayers: onFieldList));
    }
    persistentController.updateAvailableTeams(teamsList);
    persistentController.isInitialized = true;

    // set the default selected team to be the first one available
    TempController tempController = Get.find<TempController>();
    tempController.setSelectedTeam(persistentController.getAvailableTeams()[0]);
    // TODO whats the difference between the two?
    tempController.setPlayingTeam(persistentController.getAvailableTeams()[0]);

    // run a test whether a previous game exists already
    // TODO don't reload previous game for now 18.10.22
    // bool gameWithinLast20Mins = await repository.isThereAGameWithinLastMinutes(20);
    // if (gameWithinLast20Mins) {
    //   tempController.setOldGameStateExists(true);
    // }
    persistentController.generateStatistics();
  }
  return true;
}

void recreateLocalState() {}
