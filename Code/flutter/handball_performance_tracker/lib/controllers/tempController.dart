import 'package:get/get.dart';
import 'package:handball_performance_tracker/data/database_repository.dart';
import 'package:handball_performance_tracker/data/game.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/settings_config.dart';
import 'persistentController.dart';
import '../data/game_action.dart';
import '../data/player.dart';
import '../data/team.dart';
import '../utils/feed_logic.dart';
import '../utils/player_helper.dart';

/// Contains variables that are changed often throughout the app.
/// Stores mostly ephemeral state
/// Usually variables just contain single objects that
/// for example change on the switch of a button
class TempController extends GetxController {
  /// Database instance for automatically updating instances in firestore
  DatabaseRepository repository = Get.find<PersistentController>().repository;

  /// Temporary variable for storing the currently selected Team
  Rx<Team> _selectedTeam = Team(id: "-1", name: "Default team").obs;

  /// getter for selectedTeam
  Team getSelectedTeam() => _selectedTeam.value;

  /// setter for selectedTeam
  void setSelectedTeam(Team team) {
    _selectedTeam.value = team;
    update([
      "team-type-selection-bar",
      "players-list",
      "team-details-form-state",
      "team-dropdown"
    ]);
  }

  /// Temporary variable for storing the currently playing Team
  Rx<Team> _playingTeam = Team(id: "-1", name: "Default team").obs;

  /// getter for playingTeam
  Team getPlayingTeam() => _playingTeam.value;

  /// setter for playingTeam
  void setPlayingTeam(Team team) {
    _playingTeam.value = team;
    //update();
  }

  /// return the first player in selectedTeam with the given playerId
  Player getPlayerFromSelectedTeam(String playerId) {
    return _selectedTeam.value.players
        .where((Player player) => player.id == playerId)
        .first;
  }

  void updatePlayerEfScore(String playerId, GameAction action,
      {removeAction = false}) {
    if (removeAction) {
      _selectedTeam.value.players
          .where((Player player) => player.id == playerId)
          .first
          .removeAction(action);
    } else {
      _selectedTeam.value.players
          .where((Player player) => player.id == playerId)
          .first
          .addAction(action);
    }
    update(["ef-score-bar"]);
  }

  /// return all players in selectedTeam
  List<Player> getPlayersFromSelectedTeam() {
    return _selectedTeam.value.players;
  }

  void setPlayer(Player player) {
    _selectedTeam.value.players
        .where((Player playerElement) => playerElement.id == player.id)
        .toList()
        .first = player;
    repository.updatePlayer(player);
    update(["players-list"]);
  }

  /// deleting player from game state and firebase
  void deletePlayer(Player player) async {
    _selectedTeam.value.players.remove(player);
    if (_selectedTeam.value.onFieldPlayers.contains(player)) {
      _selectedTeam.value.onFieldPlayers.remove(player);
    }
    repository.deletePlayer(player);
    update(["players-list"]);
  }

  /// adds player to the players collection and the selected teams in the teams
  /// collection.
  void addPlayer(Player player) async {
    PersistentController persistentController =
        Get.find<PersistentController>();
    DocumentReference docRef = await repository.addPlayer(player);
    player.id = docRef.id;
    // add player to each team inside references
    player.teams.forEach((String teamReference) {
      Team relevantTeam = persistentController.getSpecificTeam(teamReference);
      repository.addPlayerToTeam(player, relevantTeam);
    });
    update(["players-list"]);
  }

  /// get the players from selectedTeam that are currently marked as onFieldPlayers
  List<Player> getOnFieldPlayers() => _selectedTeam.value.onFieldPlayers;

  List<String> getOnFieldPlayersById() =>
      _selectedTeam.value.onFieldPlayers.map((player) => player.id!).toList();

  /// set the onFieldPlayer from selectedTeam stored at the given index
  void setOnFieldPlayer(int index, Player player, Game game) {
    _selectedTeam.value.onFieldPlayers[index] = player;
    addGameToPlayer(player, game); // if a player is substituted during a game
    update(
        ["action-feed", "on-field-checkbox", "ef-score-bar", "players-list"]);
  }

  /// add additional onFieldPlayer to selectedTeam
  void addOnFieldPlayer(Player player) {
    // TODO implement check if there are not already 7 onFieldPlayers
    _selectedTeam.value.onFieldPlayers.add(player);
    update(
        ["action-feed", "on-field-checkbox", "ef-score-bar", "players-list"]);
  }

  void updateOnFieldPlayers() {
    repository.updateOnFieldPlayers(
        _selectedTeam.value.onFieldPlayers, _selectedTeam.value);
  }

  /// remove the given Player from onFieldPlayers of selectedTeam
  void removeOnFieldPlayer(Player player) {
    _selectedTeam.value.onFieldPlayers.remove(player);
    update(
        ["action-feed", "on-field-checkbox", "ef-score-bar", "players-list"]);
  }

  /// if player gets active in a game, add the game's id to its games list as well as the player's id to the games players list
  void addGameToPlayer(Player player, Game game) {
    if (!player.games.contains(game.id)) {
      player.games.add(game.id!);
      repository.updatePlayer(player);
    }
    if (!game.players.contains(player.id)) {
      game.players.add(player.id!);
      repository.updateGame(game);
    }
  }

  /// 0: male, 1: female, 2: youth
  RxInt _selectedTeamType = 0.obs;

  /// getter for selectedTeamType
  int getSelectedTeamType() => _selectedTeamType.value;

  /// setter for selectedTeamType
  void setSelectedTeamType(int tabNumber) {
    _selectedTeamType.value = tabNumber;
    update(["team-dropdown", "team-type-selection-bar"]);
  }

  /////////
  ///  Team Settings Screen
  /////////

  /// 0: playerSettings, 1: games, 2: teamDetails
  RxInt _selectedTeamSetting = 0.obs;

  /// getter for selectedTeamSetting
  int getSelectedTeamSetting() => _selectedTeamSetting.value;

  /// setter for selectedTeamSetting
  void setSelectedTeamSetting(int tabNumber) {
    _selectedTeamSetting.value = tabNumber;
    update(
        ["team-selection-screen", "team-setting-screen", "team-settings-bar"]);
  }

  ////
  // settingsscreen
  ////
  /// By default attack is at the left side of the screen
  /// during half time this can be switched
  RxBool _attackIsLeft = true.obs;

  /// getter for attackIsLeft
  getAttackIsLeft() => _attackIsLeft.value;

  /// setter for attackIsLeft
  setAttackIsLeft(bool attackIsLeft) {
    _attackIsLeft.value = attackIsLeft;
      update(["side-switch", "custom-field", "start-game-form"]);
    }

  //////
  /// Main screen
  //////
  Rx<StopWatchTimer> _feedTimer = StopWatchTimer(
      mode: StopWatchMode.countDown,
      presetMillisecond: FEED_RESET_PERIOD * 1000,
      onEnded: () {
        onFeedTimerEnded();
      }).obs;

  /// getter for feedTimer
  getFeedTimer() => _feedTimer.value;

  // Variable to control periodic timer resets for feed
  // makes sure that timer doesn't get reset twice
  RxBool _periodicResetIsHappening = false.obs;

  /// getter for periodicResetIsHappening
  getPeriodicResetIsHappening() => _periodicResetIsHappening.value;

  /// setter for periodicResetIsHappening
  setPeriodicResetIsHappening(bool periodicResetIsHappening) {
    _periodicResetIsHappening.value = periodicResetIsHappening;
    //update();
  }

  RxBool _addingFeedItem = false.obs;

  /// getter for addingFeedItem
  getAddingFeedItem() => _addingFeedItem.value;

  /// setter for addingFeedItem
  setAddingFeedItem(bool addingFeedItem) {
    _addingFeedItem.value = addingFeedItem;
    //update();
  }

  // List to store all the actions currently being displayed in the feed
  RxList<GameAction> _feedActions = <GameAction>[].obs;

  /// getter for feedActions
  getFeedActions() => _feedActions;

  /// remove first feedAction
  removeFirstFeedAction() {
    _feedActions.removeAt(0);
    update(["action-feed"]);
  }

  /// remove given feedAction
  void removeFeedAction(GameAction action) {
    _feedActions.remove(action);
    // delete feed item from database
    repository.deleteAction(action);
    update(["action-feed"]);
  }

  /// add feedAction to end of list
  void addFeedAction(GameAction action) {
    _feedActions.add(action);
    // update feed item to database (playerid was added)
    repository.updateAction(action);
    update(["action-feed"]);
  }

  /// text to be displayed in the player menu title on the right side, changes after a goal
  RxString _playerMenuText = "".obs;

  /// getter for playerMenuText
  String getPlayerMenuText() => _playerMenuText.value;

  void setPlayerMenutText(String text) {
    _playerMenuText.value = text;
    update(["player-menu-text"]);
  }

  /// corresponding player object for last clicked player name in the player menu
  Rx<Player> _lastClickedPlayer = Player().obs;

  /// getter for lastClickedPlayer
  getLastClickedPlayer() => _lastClickedPlayer.value;

  /// setter for lastClickedPlayer
  setLastClickedPlayer(Player lastClickedPlayer) {
    _lastClickedPlayer.value = lastClickedPlayer;
    update(["player-menu-button"]);
  }

  /// corresponding player object for last clicked player name in the efscore player bar
  Rx<Player> _playerToChange = Player().obs;

  /// getter for playerToChange
  getPlayerToChange() => _playerToChange.value;

  /// setter for playerToChange
  setPlayerToChange(Player playerToChange) {
    _playerToChange.value = playerToChange;
    //update();
  }

  // list of 7 or less Integer, give the indices of players on field in the order in which they appear on efscore player bar
  RxList<int> _playerBarPlayers = <int>[0, 1, 2, 3, 4, 5, 6].obs;

  /// getter for playerBarPlayers
  List<int> getPlayerBarPlayers() => _playerBarPlayers;

  // set the order of players displayed in player bar:
  // The first player that was added to the game it the first in the player bar and so on.
  void setPlayerBarPlayers() {
    _playerBarPlayers.clear();
    for (int i in getOnFieldIndex()) {
      _playerBarPlayers.add(i);
    }
    update(["efscorebar-players"]);
  }

  void changePlayerBarPlayers(int indexToChange, int i) {
    _playerBarPlayers[indexToChange] = i;
    update(["efscorebar-players"]);
  }

  /// Score of own team
  RxInt _ownScore = 0.obs;

  /// getter for _ownScore
  getOwnScore() => _ownScore.value;

  /// increaser for _ownScore
  incOwnScore() {
    _ownScore++;
    update(["score-keeping", "score-keeping-own"]);
  }

  /// decreaser for _ownScore
  decOwnScore() {
    if (_ownScore > 0) {
      _ownScore--;
    }
    update(["score-keeping", "score-keeping-own"]);
  }

  /// setter for _ownScore
  setOwnScore(int score) {
    if (score >= 0) {
      _ownScore.value = score;
    }
    update(["score-keeping", "score-keeping-own"]);
  }

  /// Score of opponent team
  RxInt _opponentScore = 0.obs;

  /// getter for _opponentScore
  getOpponentScore() => _opponentScore.value;

  /// increaser for _opponentScore
  incOpponentScore() {
    _opponentScore++;
    update(["score-keeping", "score-keeping-opponent"]);
  }

  /// decreaser for _opponentScore
  decOpponentScore() {
    if (_opponentScore > 0) {
      _opponentScore--;
    }
    update(["score-keeping", "score-keeping-opponent"]);
  }

  /// setter for _opponentScore
  setOpponentScore(int score) {
    if (score >= 0) {
      _opponentScore.value = score;
    }

    update(["score-keeping", "score-keeping-opponent"]);
  }

  ////
  // game tracking
  ////

  /// True: home team is playing on the left; False: home team is defending
  RxBool _fieldIsLeft = true.obs;

  /// getter for fieldIsLeft
  getFieldIsLeft() => _fieldIsLeft.value;

  /// setter for fieldIsLeft
  setFieldIsLeft(bool fieldIsLeft) {
    _fieldIsLeft.value = fieldIsLeft;
  }

  /// True: game was started; False game did not start yet
  RxBool _gameRunning = false.obs;

  /// getter for gameRunning
  getGameIsRunning() => _gameRunning.value;

  /// setter for gameRunning
  setGameIsRunning(bool gameIsRunning) {
    _gameRunning.value = gameIsRunning;
    update(["start-stop-icon", "start-button", "game-is-running-button"]);
  }

  /// True: game was paused; False game did not start yet or is running
  RxBool _gameIsPaused = false.obs;

  /// getter for _gameIsPaused
  getGameIsPaused() => _gameIsPaused.value;

  /// setter for _gameIsPaused
  setGameIsPaused(bool gameIsPaused) {
    _gameIsPaused.value = gameIsPaused;
    update(["game-is-running-button"]);
  }

  /// @return rx list
  /// after click on goal there is only one element "goal", otherwise
  /// first element is the sector as a string, second element distinguishes the distance ("<6", "6to9", ">9")
  var _lastLocation = [].obs;

  /// getter for lastLocation
  getLastLocation() => _lastLocation;

  /// setter for lastLocation
  setLastLocation(List<String> lastLocation) {
    _lastLocation.value = lastLocation;
    //update();
  }

  //////
  /// Nav Drawer
  //////
  // true if a ListTile in drawer is ellapsed, false otherwise.
  RxBool _menuIsEllapsed = false.obs;

  /// getter for _menuIsEllapsed
  getMenuIsEllapsed() => _menuIsEllapsed.value;

  /// setter for _menuIsEllapsed
  setMenuIsEllapsed(bool isEllapsed) {
    _menuIsEllapsed.value = isEllapsed;
    update(["game-is-running-button"]);
  }

  /// Season that is currently selected for games
  /// TODO: still hardcoded, add to firestore
  RxString _selectedSeason = "Saison 2021/22".obs;

  String getSelectedSeason() => _selectedSeason.value;

  void setSelectedSeason(String season) {
    _selectedSeason.value = season;
    update(["season-dropdown"]);
  }
}
