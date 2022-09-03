import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../data/database_repository.dart';
import '../data/game.dart';
import '../data/game_action.dart';
import '../data/player.dart';
import '../data/team.dart';
import '../data/club.dart';

/// stores more persistent state
/// generally more complex variables and data structure that are
/// cached from the database like all available teams
class PersistentController extends GetxController {
  /// handles teams initialization when building MainScreen
  var isInitialized = false;

  Rx<Club> _loggedInClub = Club().obs;

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

  /// get a team object from cachedTeamsList from reference string
  /// i.e teams/ypunI6UsJmTr2LxKh1aw
  Team getSpecificTeam(String teamReference) {
    return _cachedTeamsList
        .where((Team team) => teamReference.contains(team.id.toString()))
        .first;
  }

  /// Setter for cachedTeamsList
  void updateAvailableTeams(List<Team> teamsList) {
    _cachedTeamsList.value = teamsList;
    update(["team-dropdown", "team-type-selection-bar", "players-list"]);
  }

  /// Storing game actions as GameAction objects inside this list
  RxList<GameAction> _actions = <GameAction>[].obs;

  /// remove last added entry from actions list and firestore
  void removeLastAction() {
    _actions.removeLast();
    repository.deleteLastAction();
  }

  /// check whether there were game actions entered already
  bool actionsIsEmpty() {
    return _actions.isEmpty;
  }

  /// add action to actions list and firestore
  void addAction(GameAction action) {
    _actions.add(action);
  }

  /// return last action that was added
  GameAction getLastAction() {
    if (_actions.length > 0) {
      return _actions.last;
    }
    return GameAction();
  }

  List<GameAction> getAllActions() {
    return _actions;
  }

  /// updates playerid of the last action
  Future<void> setLastActionPlayer(Player player) async {
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

  /// reset the current Game object to a game without id and clean up the actions list
  void resetCurrentGame() {
    _currentGame.value = Game(date: DateTime.now());
    _actions.value = [];
  }
}
