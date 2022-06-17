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
  }

  /// Storing game actions as GameAction objects inside this list
  RxList<GameAction> _actions = <GameAction>[].obs;

  /// remove last added entry from actions list
  void removeLastAction() {
    _actions.removeLast();
  }

  /// check whether there were game actions entered already
  bool actionsIsEmpty() {
    return _actions.isEmpty;
  }

  /// add action to actions list
  void addAction(GameAction action) {
    print("adding action");
    _actions.add(action);
    print("action added: ${_actions.last.toMap()}");
  }

  /// return last action that was added
  GameAction getLastAction() {
    return _actions.last;
  }

  /// update last added action in actions list
  void setLastAction(GameAction lastAction) {
    _actions.last = lastAction;
  }

  /// last game object written to db
  Rx<Game> _currentGame = Game(date: DateTime.now()).obs;

  Game getCurrentGame() {
    return _currentGame.value;
  }

  void setCurrentGame(Game game){
    _currentGame.value = game;
  }
}
