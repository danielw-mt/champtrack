import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/data/game_action.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../data/club.dart';
import '../data/game.dart';
import '../data/player.dart';
import 'dart:async';

class GlobalController extends GetxController {
  // Class for managing global state of the app
  // Refer to https://github.com/jonataslaw/getx/wiki/State-Management

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
          print("Ended");
        }
      }).obs;

  var periodicResetIsHappening = false.obs;

  // while periodic reset is going on
  void periodicFeedTimerReset() async {
    periodicResetIsHappening.value = true;
    print("periodic timer reset");
    feedTimer.value.onExecute.add(StopWatchExecute.reset);
    await Future.delayed(Duration(milliseconds: 500));
    // feedTimer.value.clearPresetTime();
    // feedTimer.value.setPresetTime(mSec: 5000);
    feedTimer.value.onExecute.add(StopWatchExecute.start);
    if (numCurrentFeedItems.value > 0) {
      numCurrentFeedItems.value -= 1;
    }
    print("periodic reset: " + numCurrentFeedItems.value.toString());
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

    // feedTimer.value.clearPresetTime();
    // feedTimer.value.setPresetTime(mSec: 5000);

    numCurrentFeedItems.value += 1;
    print("numCurrentfeeditems: " + numCurrentFeedItems.value.toString());
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

  /// @return rxString
  /// location that was saved when clicking on a point in the field 'sector',
  /// 'in 6m', 'in 9m'
  var lastLocation = "".obs;
}
