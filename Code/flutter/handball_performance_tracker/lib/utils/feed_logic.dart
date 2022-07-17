import 'package:get/get.dart';
import 'package:handball_performance_tracker/constants/game_actions.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import '../controllers/tempController.dart';
import '../data/game_action.dart';
import '../constants/settings_config.dart';

// when the periodic reset happens remove the first (oldest) item from the feedActions list
void periodicFeedTimerReset() async {
  TempController gameController = Get.find<TempController>();
  gameController.setPeriodicResetIsHappening(true);
  gameController.getFeedTimer().onExecute.add(StopWatchExecute.reset);
  await Future.delayed(Duration(milliseconds: 500));
  gameController.getFeedTimer().onExecute.add(StopWatchExecute.start);
  if (gameController.getFeedActions().length > 0) {
    gameController.removeFirstFeedAction();
  }
  gameController.setPeriodicResetIsHappening(false);
}

/// adds item to the feedActions list
void addFeedItem(GameAction feedAction) async {
  TempController gameController = Get.find<TempController>();
  // this is needed so that when the timer is reset here it does not remove an item
  // every time the timer is reset it triggers onFeedTimerEnded() which would remove the item again
  gameController.setAddingFeedItem(true);
  StopWatchTimer feedTimer = gameController.getFeedTimer();
  if (feedTimer.isRunning == false) {
    feedTimer.onExecute.add(StopWatchExecute.start);
    await Future.delayed(Duration(milliseconds: 500));
  } else {
    feedTimer.onExecute.add(StopWatchExecute.reset);
    await Future.delayed(Duration(milliseconds: 500));
    feedTimer.onExecute.add(StopWatchExecute.start);
  }
  // when there are too many items in this feed remove the oldest item
  if (gameController.getFeedActions().length == MAX_FEED_ITEMS) {
    gameController.removeFirstFeedAction();
  }
  gameController.addFeedAction(feedAction);
  gameController.setAddingFeedItem(false);
}

/// gets triggered every time the period of the timer runs out or when the timer is reset
void onFeedTimerEnded() {
  TempController gameController = Get.find<TempController>();
  if (!gameController.getPeriodicResetIsHappening() &&
      !gameController.getAddingFeedItem()) {
    periodicFeedTimerReset();
  }
}

/// Gets triggered when user clicks on a feed item
void removeFeedItem(GameAction action, TempController tempController) {
  // delete action from game state and database
  tempController.removeFeedAction(action);
  // decrease own score by one if a goal action was deleted
  if (action.actionType == goal) {
    tempController.decOwnScore();
  }
  else if (action.actionType == goalOthers) {
    tempController.decOpponentScore();
  }
  // update player's ef.score
  tempController.updatePlayerEfScore(action.playerId, action,
      removeAction: true);
}
