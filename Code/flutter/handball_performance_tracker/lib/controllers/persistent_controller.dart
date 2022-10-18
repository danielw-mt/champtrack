import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../data/database_repository.dart';
import '../data/game.dart';
import '../data/game_action.dart';
import '../data/player.dart';
import '../data/team.dart';
import '../data/club.dart';
import 'temp_controller.dart';
import '../utils/statistics_engine.dart';

/// stores more persistent state
/// generally more complex variables and data structure that are
/// cached from the database like all available teams
class PersistentController extends GetxController {
  /// handles teams initialization when building MainScreen
  var isInitialized = false;
  Rx<StatisticsEngine> _statisticsEngine = StatisticsEngine().obs;
  RxList<Game> _allGames = <Game>[].obs;
  RxList<Player> _allPlayers = <Player>[].obs;
  Rx<Club> _loggedInClub = Club().obs;

  /// Storing game actions as GameAction objects inside this list
  RxList<GameAction> _actions = <GameAction>[].obs;

  void setLoggedInClub(Club club) {
    _loggedInClub.value = club;
    update(["menu-club-display"]);
  }

  Club getLoggedInClub() {
    return _loggedInClub.value;
  }

  ///
  // database handling
  ///
  var repository = DatabaseRepository();

  /// list of all teams of the club that are cached in the local game state
  /// Changes made in the settings to e.g. are stored in here as well
  RxList<Team> _cachedTeamsList = <Team>[].obs;

  /// Getter for cachedTeamsList
  List<Team> getAvailableTeams() {
    return _cachedTeamsList;
  }

  void addTeam(String name, String type) async {
    TempController tempController = Get.find<TempController>();
    Team newTeam = Team(name: name, type: type, players: [], onFieldPlayers: []);
    DocumentReference docRef = await repository.addTeam(newTeam);
    newTeam.id = docRef.id;
    _cachedTeamsList.add(newTeam);
    tempController.setSelectedTeam(newTeam);
    // update all ui elements referencing teams
    tempController.updateItem("team-list");
    tempController.updateItem("team-selection-screen");
    tempController.updateItem("team-dropdown");
    tempController.update(["players-list"]);
  }

  void deleteTeam(Team team) async {
    logger.d("deleting team: " + team.name);
    await repository.deleteTeam(team);
    _cachedTeamsList.remove(team);
    // update the teams list after update
    TempController tempController = Get.find<TempController>();
    tempController.updateItem("team-list");
    tempController.updateItem("team-selection-screen");
    tempController.updateItem("team-dropdown");
  }

  void updateTeam(Team team) async {
    await repository.updateTeam(team);
    _cachedTeamsList.forEach((Team cachedTeam) {
      if (cachedTeam.id == team.id) {
        cachedTeam = team;
      }
    });
  }

  void setAllPlayers(List<Player> players) {
    _allPlayers.value = players;
  }

  /// Get all players belonging to the logged in club. Optional: all players that belong to team with @param teamId
  List<Player> getAllPlayers({String? teamId}) {
    // if team id is provided filter all players for players that are part of the given team
    if (teamId != null){
      return _allPlayers.where((Player player) => player.teams.contains('teams/'+teamId)).toList();
    }
    return _allPlayers;
  }

  /// get a team object from cachedTeamsList from reference string
  /// i.e teams/ypunI6UsJmTr2LxKh1aw
  Team getSpecificTeam(String teamReference) {
    return _cachedTeamsList.where((Team team) => teamReference.contains(team.id.toString())).first;
  }

  /// Setter for cachedTeamsList
  void updateAvailableTeams(List<Team> teamsList) {
    logger.d("update available teams");
    _cachedTeamsList.value = teamsList;
    update(["team-dropdown", "team-type-selection-bar", "players-list"]);
  }

  /// remove last added entry from actions list and firestore
  void removeLastAction() {
    _actions.removeLast();
    repository.deleteLastAction();
  }

  /// check whether there were game actions entered already
  bool actionsIsEmpty() {
    return _actions.isEmpty;
  }

  generateStatistics() async {
    List<Map<String, dynamic>> gamesData = await repository.getGamesData();
    _statisticsEngine.value.generateStatistics(gamesData, getAllPlayers());
  }

  /// add action to persistent controller action list
  void addActionToCache(GameAction action) {
    _actions.add(action);
  }

  /// Return last action that was added to persistentcontroller actions list
  GameAction getLastAction() {
    if (_actions.length > 0) {
      return _actions.last;
    }
    throw Exception("No actions available in persistent controller");
  }

  List<GameAction> getAllActions() {
    return _actions;
  }

  /// updates playerid of the last action
  void setLastActionPlayer(Player player) {
    _actions.last.playerId = player.id!;
  }

  /// adds actions to the collection in firestore
  Future<void> addActionToFirebase(GameAction action) async {
    print("add action to firebase");
    DocumentReference ref = await repository.addActionToGame(action);
    _actions.forEach((element) {
      if (element.hashCode == action.hashCode) {
        print("adding action to db: " + element.toString());
        element.id = ref.id;
      }
    });
  }

  /// last game object written to firestore
  Rx<Game> _currentGame = Game(date: DateTime.now()).obs;

  /// get current game object
  Game getCurrentGame() {
    return _currentGame.value;
  }

  /// set game object and either add is to firestore with new id or update the existing one
  Future<void> setCurrentGame(Game game, {isNewGame: false}) async {
    _currentGame.value = game;
    if (isNewGame) {
      DocumentReference ref = await repository.addGame(game);
      _currentGame.value.id = ref.id;
    } else {
      repository.updateGame(game);
    }
  }

  void setStopWatchTime(int time) {
    _currentGame.value.stopWatchTimer.setPresetTime(mSec: time);
  }

  void setAllGames(List<Game> games) {
    _allGames.value = games;
  }

  List<Game> getAllGames({String? teamId}) {
    // if there is a teamId provided only get the games corresponding to that team
    if (teamId != null) {
      List<Game> correspondingGames = _allGames.where((Game game) => game.teamId == teamId).toList();
      return correspondingGames;
    }
    return _allGames;
  }

  /// reset the current Game object to a game without id and clean up the actions list
  void resetCurrentGame() {
    _currentGame.value = Game(date: DateTime.now());
    _actions.value = [];
  }

  /// if there are more than @param actionLimit actions that a player performed
  /// return true otherwise false
  bool playerEfScoreShouldDisplay(int actionLimit, Player player) {
    int actionsPlayerPerformed = 0;
    _actions.forEach((GameAction action) {
      if (action.playerId == player.id) {
        actionsPlayerPerformed++;
      }
    });
    if (actionsPlayerPerformed >= actionLimit) {
      return true;
    } else {
      return false;
    }
  }

  Map<String, dynamic> getStatistics() {
    return _statisticsEngine.value.getStatistics();
  }
}
