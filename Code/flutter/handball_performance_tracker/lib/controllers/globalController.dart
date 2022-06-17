import 'package:get/get.dart';
import 'package:handball_performance_tracker/data/club.dart';
import 'package:handball_performance_tracker/data/database_repository.dart';
import 'package:handball_performance_tracker/utils/player_helper.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import '../data/game_action.dart';
import '../data/team.dart';
import '../data/game.dart';
import '../data/player.dart';
import 'dart:async';
import '../utils/feed_logic.dart';
import '../constants/settings_config.dart';

/// Class for managing global state of the app.
/// Refer to https://github.com/jonataslaw/getx/wiki/State-Management
class GlobalController extends GetxController {
  /// initialization handling
  var isInitialized = false;

  ///
  // database handling
  ///
  var repository = DatabaseRepository();

  ///
  // currently signed in club
  /// @return Rx<Club>
  Rx<Club> currentClub = Club().obs;

  ////////
  /// Team Selection Screen
  ////////

  /// Temporary variable for storing the currently selected Team
  Rx<Team> selectedTeam = Team(id: "-1", name: "Default team").obs;

  /// list of all teams of the club that are cached in the local game state. Changes made in the settings to e.g. are stored in here as well
  RxList<Team> cachedTeamsList = <Team>[].obs;

  /// 0: male, 1: female, 2: youth
  RxInt selectedTeamType = 0.obs;

  /////////
  ///  Team Settings Screen
  /////////

  /// 0: playerSettings, 1: games, 2: teamDetails
  RxInt selectedTeamSetting = 0.obs;

  ////
  // settingsscreen
  ////

  // TODO check if these player variables are being needed now
  Rx<Player> selectedPlayer = Player().obs;
  RxList<Player> availablePlayers = <Player>[].obs;
  RxList<Player> chosenPlayers = <Player>[].obs;

  /// By default attack is at the left side of the screen
  /// during half time this can be switched
  RxBool attackIsLeft = true.obs;

  ////
  // Helper screen
  ////
  
  
  //////
  /// Main screen
  //////

  // TODO is something missing here?
  /// name of the player who made a goal, used to adapt the respective button color.
  
  Rx<StopWatchTimer> stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
  ).obs;
  
  Rx<StopWatchTimer> feedTimer = StopWatchTimer(
      mode: StopWatchMode.countDown,
      presetMillisecond: FEED_RESET_PERIOD*1000,
      onEnded: () {
        onFeedTimerEnded();
      }).obs;

  // Variable to control periodic timer resets for feed
  // makes sure that timer doesn't get reset twice
  RxBool periodicResetIsHappening = false.obs;
  RxBool addingFeedItem = false.obs;
  // List to store all the actions currently being displayed in the feed
  RxList<GameAction> feedActions = <GameAction>[].obs;

  /// text to be displayed in the player menu title on the right side, changes after a goal
  RxString playerMenuText = "Scorer".obs;

  /// corresponding player object for last clicked player name in the player menu
  Rx<Player> lastClickedPlayer = Player().obs;

  /// @return Rx<Player>
  /// corresponding player object for last clicked player name in the efscore player bar
  Rx<Player> playerToChange = Player().obs;

  // list of 7 or less Integer, give the indices of players on field in the order in which they appear on efscore player bar
  RxList<int> playerBarPlayers = <int>[0, 1, 2, 3, 4, 5, 6].obs;

  // set the order of players displayed in player bar:
  // The first player that was added to the game it the first in the player bar and so on.
  void setPlayerBarPlayers() {
    playerBarPlayers.clear();
    for (int i in getOnFieldIndex()) {
      playerBarPlayers.add(i);
    }
  }

  ////
  // game tracking
  ////

  /// True: home team is playing on the left; False: home team is defending
  RxBool fieldIsLeft = true.obs;

  /// Storing game actions as GameAction objects inside this list
  RxList<GameAction> actions = <GameAction>[].obs;

  /// True: game was started; False game did not start yet
  RxBool gameRunning = false.obs;

  /// last game object written to db
  Rx<Game> currentGame = Game(date: DateTime.now()).obs;

  /// how many goals the user's team scored
  RxInt homeTeamGoals = 0.obs;

  /// how many goals the guest's team scored
  RxInt opponentTeamGoals = 0.obs;

  /// @return rx list
  /// first element is the sector as a string, second element distinguishes the distance ("<6", "6to9", ">9")
  var lastLocation = [].obs;
}
