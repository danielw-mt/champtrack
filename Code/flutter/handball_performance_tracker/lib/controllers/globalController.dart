import 'package:get/get.dart';
import 'package:handball_performance_tracker/data/database_repository.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../data/club.dart';
import '../data/game.dart';
import '../data/player.dart';
import 'dart:async';

class GlobalController extends GetxController {
  // Class for managing global state of the app
  // Refer to https://github.com/jonataslaw/getx/wiki/State-Management

  ///
  // database handling
  ///
  var repository = DatabaseRepository(); 

  ///
  // currently signed in club
  /// @return rxString
  var currentClub = Club(id: "-1").obs;

  ////
  // settingsscreen
  ////
  final selectedPlayer = Player().obs;
  var availablePlayers = [].obs;
  var chosenPlayers = [].obs;
  var playersNotOnField = [
    Player(id: "8", name: "aaaaaaaaaaaa", number: 20, position: ["HL"]),
    Player(id: "9", name: "bbbbbbbbbbbb", number: 22, position: ["HR"]),
    Player(id: "11", name: "ccccccccccc", number: 24, position: ["VL"]),
    Player(id: "12", name: "dddddddddd", number: 25, position: ["HR", "VR"]),
    Player(id: "14", name: "eeeeeeeeeeee", number: 22, position: ["HL", "VL"]),
    Player(id: "15", name: "ffffffffffff", number: 26, position: ["HL", "VL"]),
    Player(id: "17", name: "gggggggggggg", number: 27, position: ["Tor"]),
  ].obs;
  // boolean list of chosen players i.e. true, true, false would mean the first two players start
  RxList<dynamic> playersOnField = [].obs;

  bool getStartingPlayerValue(int index) {
    playersOnField.refresh();
    return playersOnField[index];
  }

  /// by default attack is at the left side of the screen
  /// during half time this can be switched
  /// @return rx boolean
  var attackIsLeft = true.obs;

  ////
  // Helper screen
  ////
  var stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
  ).obs;

  var feedTimer = StopWatchTimer(
      mode: StopWatchMode.countDown,
      presetMillisecond: 10000,
      onEnded: () {
        final GlobalController globalController = Get.find<GlobalController>();
        if (globalController.periodicResetIsHappening.value == false) {
          globalController.periodicFeedTimerReset();
        }
      }).obs;

  var periodicResetIsHappening = false.obs;

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

  var numCurrentFeedItems = 0.obs;
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

  var currentNumFeedItems = 0.obs;
  //////
  /// Main screen
  //////
  /// @return rxString
  /// name of the player who made a goal, used to adapt the respective button color.

  /// @return rxString
  /// text to be displayed in the player menu title on the right side, changes after a goal
  var playerMenuText = "".obs;

  void updatePlayerMenuText() {
    // changing from dep = input.obs
    playerMenuText.value = "Assist";
  }

  /// @return Rx<Player>
  /// corresponding player object for last clicked player name in the player menu
  var lastClickedPlayer = Player().obs;

  var playerToChange = Player().obs;
  ////
  // game tracking
  ////

  /// @return rxBool
  /// True: home team is playing on the left; False: home team is defending
  var fieldIsLeft = true.obs;

  /// @return rx list
  /// Storing game actions as GameAction objects inside this list
  var actions = [].obs;

  /// @return rxBool
  /// True: game was started; False game did not start yet
  var gameStarted = false.obs;

  /// @return rx<Game>
  /// last game object written to db
  final currentGame = Game(date: DateTime.now()).obs;

  /// @return rxInt
  /// how many goals the user's team scored
  var homeTeamGoals = 0.obs;

  /// @return rxInt
  /// how many goals the guest's team scored
  var opponentTeamGoals = 0.obs;

  /// @return rx list
  /// first element is the sector as a string, second element distinguishes the distance ("<6", "6to9", ">9")
  var lastLocation = [].obs;
}
