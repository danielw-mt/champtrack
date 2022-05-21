import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class GlobalController extends GetxController {
  // Class for managing global state of the app
  // Refer to https://github.com/jonataslaw/getx/wiki/State-Management

  ////
  // settingsscreen
  ////
  var selectedPlayer = "".obs;
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
  var attackIsLeft = true.obs;

  ////
  // Helper screen
  ////
  var stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
  ).obs;

  //////
  /// Main screen
  //////

  /// text to be displayed in the player menu title
  var playerMenuText = "Select a player".obs;

  /// last clicked player in the player menu
  var lastClickedPlayer = "".obs;

  ////
  // game tracking
  ////

  /// True: home team is playing on the left; False: home team is defending
  var fieldIsLeft = true.obs;

  /// Storing game actions as Map<String, dynamic>
  var actions = [].obs;

  /// True: game was started; False game did not start yet
  var gameStarted = false.obs;

  /// id of last action written to db
  var lastGameActionId = "".obs;

  /// id of last game object written to db
  var currentGameId = "".obs;
  var homeTeamGoals = 0.obs;
  var guestTeamGoals = 0.obs;

  var lastLocation = "".obs;
}
