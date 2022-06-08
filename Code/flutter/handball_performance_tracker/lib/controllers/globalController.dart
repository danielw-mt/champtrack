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

/// Class for managing global state of the app.
/// Refer to https://github.com/jonataslaw/getx/wiki/State-Management
class GlobalController extends GetxController {
  // Class for managing global state of the app
  // Refer to https://github.com/jonataslaw/getx/wiki/State-Management

  ///
  // database handling
  ///
  var repository = DatabaseRepository();

  ///
  // currently signed in club
  /// @return Rx<Club>
  Rx<Club> currentClub = Club().obs;

  /// Temporary variable for storing the currently selected Team
  Rx<Team> selectedTeam = Team(id: "-1", name: "Default team").obs;

  /// list of all teams of the club that are cached in the local game state. Changes made in the settings to e.g. are stored in here as well
  RxList<Team> cachedTeamsList = <Team>[].obs;

  ////
  // settingsscreen
  ////
  Rx<Player> selectedPlayer = Player().obs;
  RxList<Player> availablePlayers = <Player>[].obs;
  RxList<Player> chosenPlayers = <Player>[].obs;

  /// By default attack is at the left side of the screen
  /// during half time this can be switched
  RxBool attackIsLeft = true.obs;

  ////
  // Helper screen
  ////

  var feedTimer = StopWatchTimer(
      mode: StopWatchMode.countDown,
      presetMillisecond: 10000,
      onEnded: () {
        final GlobalController globalController = Get.find<GlobalController>();
        if (globalController.periodicResetIsHappening.value == false) {
          globalController.periodicFeedTimerReset();
        }
      }).obs;

  // Variable to control periodic timer resets for feed
  // makes sure that timer doesn't get reset twice
  RxBool periodicResetIsHappening = false.obs;

  // while periodic reset is going on
  void periodicFeedTimerReset() async {
    periodicResetIsHappening.value = true;
    feedTimer.value.onExecute.add(StopWatchExecute.reset);
    await Future.delayed(Duration(milliseconds: 500));
    feedTimer.value.onExecute.add(StopWatchExecute.start);
    if (numCurrentFeedItems.value > 0) {
      numCurrentFeedItems.value -= 1;
    }
    periodicResetIsHappening.value = false;
    update();
  }

  RxInt numCurrentFeedItems = 0.obs;
  void addFeedItem() async {
    if (feedTimer.value.isRunning == false) {
      feedTimer.value.onExecute.add(StopWatchExecute.start);
      await Future.delayed(Duration(milliseconds: 500));
    } else {
      feedTimer.value.onExecute.add(StopWatchExecute.reset);
      numCurrentFeedItems.value += 1;
      await Future.delayed(Duration(milliseconds: 500));
      feedTimer.value.onExecute.add(StopWatchExecute.start);
    }
    numCurrentFeedItems.value += 1;
    update();
  }

  RxInt currentNumFeedItems = 0.obs;
  //////
  /// Main screen
  //////

  // TODO is something missing here?
  /// name of the player who made a goal, used to adapt the respective button color.

  /// text to be displayed in the player menu title on the right side, changes after a goal
  RxString playerMenuText = "".obs;

  void updatePlayerMenuText() {
    // changing from dep = input.obs
    playerMenuText.value = "Assist";
  }

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
