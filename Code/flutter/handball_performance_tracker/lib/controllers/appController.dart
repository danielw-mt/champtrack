import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../data/database_repository.dart';
import '../data/game.dart';
import '../data/game_action.dart';
import '../data/team.dart';

class AppController extends GetxController {
  /// handles teams initialization when building MainScreen
  var isInitialized = false;

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
    repository
        .addActionToGame(action)
        .then((DocumentReference doc) => action.id = doc.id);
  }

  /// return last action that was added
  GameAction getLastAction() {
    return _actions.last;
  }

  /// update last added action in actions list and firestore
  void setLastAction(GameAction lastAction) {
    _actions.last = lastAction;
    repository.updateAction(lastAction);
  }

  /// last game object written to firestore
  Rx<Game> _currentGame = Game(date: DateTime.now()).obs;

  /// get current game object
  Game getCurrentGame() {
    return _currentGame.value;
  }

  /// set game object and either add is to firestore with new id or update the existing one
  void setCurrentGame(Game game, {isNewGame: false}) {
    if (isNewGame) {
      repository
          .addGame(game)
          .then((DocumentReference ref) => game.id = ref.id);
    } else {
      repository.updateGame(game);
    }
    _currentGame.value = game;
  }
}
