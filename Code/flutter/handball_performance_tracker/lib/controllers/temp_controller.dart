import 'package:get/get.dart';
import 'package:handball_performance_tracker/data/database_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/game.dart';
import 'persistent_controller.dart';
import '../data/game_action.dart';
import '../data/player.dart';
import '../data/team.dart';
import '../utils/player_helper.dart';
import 'dart:async';

/// Contains variables that are changed often throughout the app.
/// Stores mostly ephemeral state
/// Usually variables just contain single objects that
/// for example change on the switch of a button
class TempController extends GetxController {
  /// Database instance for automatically updating instances in firestore
  DatabaseRepository repository = Get.find<PersistentController>().repository;

  void updateItem(String itemName) {
    update([itemName]);
  }

  /// Temporary variable for storing the currently selected Team
  Rx<Team> _selectedTeam = Team(players: [], onFieldPlayers: []).obs;

  /// getter for selectedTeam
  Team getSelectedTeam() => _selectedTeam.value;

  /// setter for selectedTeam
  void setSelectedTeam(Team team) {
    PersistentController persistentController = Get.find<PersistentController>();
    persistentController.updateTeam(team);
    repository.updateTeam(team);
    _selectedTeam.value = team;
    update([
      "team-type-selection-bar",
      // "players-list",
      "team-details-form-state",
      "team-dropdown",
      "team-list"
    ]);
  }

  /// remove selected team from list of teams in persistent controller
  /// and set selected team to one that is available
  void deleteSelectedTeam() async {
    PersistentController persistentController = Get.find<PersistentController>();
    await persistentController.deleteTeam(_selectedTeam.value);
    // set selected team to default team if no teams are available
    if (persistentController.getAvailableTeams().length > 0) {
      _selectedTeam.value = persistentController.getAvailableTeams()[0];
    } else {
      _selectedTeam.value = Team(players: [], onFieldPlayers: []);
    }
    update(["team-type-selection-bar", "players-list", "team-details-form-state", "team-dropdown"]);
  }

  /// Temporary variable for storing the currently playing Team
  /// TODO why is this needed? can't we just use selectedTeam?
  Rx<Team> _playingTeam = Team(players: [], onFieldPlayers: []).obs;

  /// getter for playingTeam
  Team getPlayingTeam() => _playingTeam.value;

  /// setter for playingTeam
  void setPlayingTeam(Team team) {
    _playingTeam.value = team;
    //update();
  }

  /// return the first player in selectedTeam with the given playerId
  Player getPlayerFromSelectedTeam(String playerId) {
    return _selectedTeam.value.players.where((Player player) => player.id == playerId).first;
  }

  void updatePlayerEfScore(String playerId, GameAction action, {removeAction = false}) {
    if (_selectedTeam.value.players.where((Player player) => player.id == playerId).isEmpty) {
      return;
    }
    if (removeAction) {
      _selectedTeam.value.players.where((Player player) => player.id == playerId).first.removeAction(action);
    } else {
      _selectedTeam.value.players.where((Player player) => player.id == playerId).first.addAction(action);
    }
    update(["ef-score-bar"]);
  }

  /// return all players in selectedTeam
  List<Player> getPlayersFromSelectedTeam() {
    return _selectedTeam.value.players;
  }

  /// update/edit player with provided @param player
  void setPlayer(Player player) {
    // update player in selected team
    _selectedTeam.value.players.where((Player playerElement) => playerElement.id == player.id).toList().first = player;
    repository.updatePlayer(player);

    // TODO remove circular persistentController dependency if possible. Not critical for now
    PersistentController persistentController = Get.find<PersistentController>();
    List<Team> allTeams = persistentController.getAvailableTeams();
    // try to add the player to all the teams that are assigned in the player.teams property
    addPlayer(player);
    // get all the teams the player should be in
    List<Team> teamsWithPlayer = allTeams.where((Team team) => player.teams.contains('teams/' + team.id!)).toList();
    // update the player in all the teams where the should be in
    teamsWithPlayer.forEach((Team team) {
      if (team.players.contains(player)){
        // use this trick here to first remove the player with for example the old name and the re-add the player with the new name
        team.players.remove(player);
        team.players.add(player);
      }
    });
    // also update player in selected team if they should be within the selected team
    if (teamsWithPlayer.contains(_selectedTeam)) {
      // same trick for selected team
      _selectedTeam.value.players.remove(player);
      _selectedTeam.value.players.add(player);
    }


    // get all the teams the player should not be in
    List<Team> teamsWithoutPlayer = allTeams.where((Team team) => !player.teams.contains('teams/' + team.id!)).toList();
    teamsWithoutPlayer.forEach((element) {
      logger.d(element.name);
    });
    // try to remove the player from all these teams they shouldn't be in
    teamsWithoutPlayer.forEach((Team team) {
      team.players.forEach((Player teamPlayer) {
        logger.d(teamPlayer.lastName);
      });
      if (team.players.contains(player)) {
        logger.d("removing player from team " + team.name);
        team.players.remove(player);
        repository.updateTeam(team);
        persistentController.updateTeam(team);
      }
    });
    // also remove player from selected team if they shouldn't be in the selected team
    if (teamsWithoutPlayer.contains(_selectedTeam.value)) {
      _selectedTeam.value.players.remove(player);
    }
    update(["players-list"]);
  }

  /// deleting player from game state and firebase
  void deletePlayer(Player player) async {
    if (_selectedTeam.value.players.contains(player)) {
      _selectedTeam.value.players.remove(player);
    }
    if (_selectedTeam.value.onFieldPlayers.contains(player)) {
      _selectedTeam.value.onFieldPlayers.remove(player);
    }
    PersistentController persistentController = Get.find<PersistentController>();
    persistentController.removePlayerFromTeams(player);
    repository.deletePlayer(player);
    // TODO remove player from teams in teams collection

    update(["players-list"]);
  }

  /// Adds player to the teams that they are assigned to (player.teams property)
  /// Also adds player to players collection
  /// TODO do not addPlayer to a team if they are already part of that team
  void addPlayer(Player player) async {
    // TODO not critical but try to avoid circular dependency
    PersistentController persistentController = Get.find<PersistentController>();
    // if the player is not already in the selected team add the selected team

    // TODO not sure if we need this part
    // if (!player.teams.contains('teams/' + _selectedTeam.value.id.toString())) {
    //   print("player not already in selected team");
    //   player.teams.add(_selectedTeam.value.id.toString());
    // }
    // add player to players if they haven't been added before. Basically player has an id when they were previously added to firebase collection
    if (player.id == "") {
      DocumentReference docRef = await repository.addPlayer(player);
      player.id = docRef.id;
    }
    // add player to each team inside references
    player.teams.forEach((String teamReference) async {
      logger.d("adding player $teamReference team in firebase");
      Team relevantTeam = persistentController.getSpecificTeam(teamReference);
      // only add player to team if they are not already part of that team
      if (!relevantTeam.players.contains(player)) {
        relevantTeam.players.add(player);
        await repository.addPlayerToTeam(player, relevantTeam);
      }
    });
    // if player should be added to selected team, add them
    if (player.teams.contains(_selectedTeam)) {
      logger.d("add player to selected team");
      _selectedTeam.value.players.add(player);
    }
    update(["players-list"]);
  }

  /// get the players from selectedTeam that are currently marked as onFieldPlayers
  List<Player> getOnFieldPlayers() => _selectedTeam.value.onFieldPlayers;

  void setOnFieldPlayers(List<Player> players) {
    _selectedTeam.value.onFieldPlayers = players;
    update(["players-list"]);
  }

  List<String> getOnFieldPlayersById() => _selectedTeam.value.onFieldPlayers.map((player) => player.id!).toList();

  /// set the onFieldPlayer from selectedTeam stored at the given index
  void setOnFieldPlayer(int index, Player player, Game game) {
    _selectedTeam.value.onFieldPlayers[index] = player;
    addGameToPlayer(player, game); // if a player is substituted during a game
    update(["action-feed", "on-field-checkbox", "ef-score-bar", "players-list"]);
  }

  /// add additional onFieldPlayer to selectedTeam
  void addOnFieldPlayer(Player player) {
    // TODO implement check if there are not already 7 onFieldPlayers
    _selectedTeam.value.onFieldPlayers.add(player);
    update(["action-feed", "on-field-checkbox", "ef-score-bar", "players-list"]);
  }

  void updateOnFieldPlayers() {
    repository.updateOnFieldPlayers(_selectedTeam.value.onFieldPlayers, _selectedTeam.value);
  }

  /// remove the given Player from onFieldPlayers of selectedTeam
  void removeOnFieldPlayer(Player player) {
    _selectedTeam.value.onFieldPlayers.remove(player);
    update(["action-feed", "on-field-checkbox", "ef-score-bar", "players-list"]);
  }

  /// if player gets active in a game, add the game's id to its games list
  ///  as well as the player's id to the games players list
  void addGameToPlayer(Player player, Game game) {
    if (!player.games.contains(game.id)) {
      player.games.add(game.id!);
      repository.updatePlayer(player);
    }
    if (!game.onFieldPlayers.contains(player.id)) {
      game.onFieldPlayers.add(player.id!);
      repository.updateGame(game);
    }
  }

  /// after a game is ended, reset the LiveEfScores of all participating players and the feed
  void resetGameData(Game game) {
    for (String playerId in game.onFieldPlayers) {
      Player player = getPlayerFromSelectedTeam(playerId);
      player.resetActions();
    }
    setOwnScore(0);
    setOpponentScore(0);
    _feedActions.value = [];
    update(["action-feed", "ef-score-bar"]);
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
    update(["team-selection-screen", "team-setting-screen", "team-settings-bar"]);
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
    //repository.updateAction(action);
    update(["action-feed"]);
  }

  /// text to be displayed in the player menu title on the right side, changes after a goal
  RxString _playerMenuText = "".obs;

  /// getter for playerMenuText
  String getPlayerMenuText() => _playerMenuText.value;

  void setPlayerMenuText(String text) {
    _playerMenuText.value = text;
    update(["player-menu-text"]);
  }

  /// text to be displayed in the action menu title on the right side, changes when time is paused
  RxString _actionMenuText = "".obs;

  /// getter for _actionMenuText
  String getActionMenuText() => _actionMenuText.value;

  void setActionMenutText(String text) {
    _actionMenuText.value = text;
    update(["action-menu-text"]);
  }

  /// corresponding player object for last clicked player name in the player menu
  Rx<Player> _lastClickedPlayer = Player().obs;

  /// getter for lastClickedPlayer
  Player getPreviousClickedPlayer() => _lastClickedPlayer.value;

  /// setter for lastClickedPlayer
  void setPreviousClickedPlayer(Player lastClickedPlayer) {
    _lastClickedPlayer.value = lastClickedPlayer;
    update(["player-menu-button"]);
  }

  /// corresponding player object for clicked player names in player menu which are not on field yet
  RxList<Player> _playersToChange = <Player>[].obs;

  /// getter for _playersToChange
  List<Player> getPlayersToChange() => _playersToChange;

  /// setter for _playersToChange
  void addPlayerToChange(Player playerToChange) {
    _playersToChange.add(playerToChange);
    //update();
  }

  void removePlayerToChange(Player playerToChange) {
    _playersToChange.remove(playerToChange);
    //update();
  }

  getLastPlayerToChange() {
    if (!_playersToChange.isEmpty) {
      Player playerToChange = getPlayersToChange()[0];
      removePlayerToChange(playerToChange);
      return playerToChange;
    } else
      return null;
    //update();
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
  RxList<int> _playerBarPlayersOrder = <int>[0, 1, 2, 3, 4, 5, 6].obs;

  /// getter for playerBarPlayers
  List<int> getPlayerBarPlayers() => _playerBarPlayersOrder;

  // set the order of players displayed in player bar:
  // The first player that was added to the game it the first in the player bar and so on.
  void setPlayerBarPlayersOrder() {
    _playerBarPlayersOrder.clear();
    for (int i in getOnFieldIndex()) {
      _playerBarPlayersOrder.add(i);
    }
    update(["ef-score-bar"]);
  }

  void changePlayerBarPlayers(int indexToChange, int i) {
    _playerBarPlayersOrder[indexToChange] = i;
    update(["ef-score-bar"]);
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
    update(["start-stop-icon", "game-is-running-button"]);
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

  /// Whether a game was synced in the last 20 minutes after opening the app
  RxBool oldGameStateExists = false.obs;

  void setOldGameStateExists(bool oldGameStateExists) {
    this.oldGameStateExists.value = oldGameStateExists;
  }

  bool getOldGameStateExists() => oldGameStateExists.value;

  RxBool gameSyncActivatedOnce = false.obs;
  bool isGameSyncActivated() => gameSyncActivatedOnce.value;
  void activateGameSync() {
    gameSyncActivatedOnce.value = true;
  }

  /// Penalty Functionality
  /// A map of players is stored that currently serve a penalty
  /// {"playerID":"timeOfPenalty"}
  RxMap penalizedPlayers = {}.obs;

  void addPenalizedPlayer(Player player) {
    // don't add a player to the map if they already have a penalty
    if (isPlayerPenalized(player)) {
      return;
    }
    PersistentController persistentController = Get.find<PersistentController>();
    penalizedPlayers[player.id] = persistentController.getCurrentGame().stopWatchTimer.rawTime.value;
    print(penalizedPlayers);
    update(["player-bar-button"]);
    // check whether the penalty for the player ran out every 5 seconds of the stopwatch
    Timer.periodic(Duration(seconds: 5), (Timer t) {
      if (!penalizedPlayers.containsKey(player.id)) {
        t.cancel();
        return;
      }
      int stopWatchTime = persistentController.getCurrentGame().stopWatchTimer.rawTime.value;
      int penaltyStartStopWatchTime = penalizedPlayers[player.id];
      if (stopWatchTime - penaltyStartStopWatchTime >= 120000) {
        removePenalizedPlayer(player);
        t.cancel();
      }
    });
  }

  void removePenalizedPlayer(Player player) {
    if (penalizedPlayers.containsKey(player.id)) {
      penalizedPlayers.remove(player.id);
      update(["player-bar-button"]);
    }
  }

  bool isPlayerPenalized(Player player) => penalizedPlayers.containsKey(player.id);
}
