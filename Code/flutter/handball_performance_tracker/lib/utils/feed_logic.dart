import 'package:get/get.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import '../controllers/gameController.dart';
import '../data/game_action.dart';
import '../constants/settings_config.dart';
import '../data/database_repository.dart';

// when the periodic reset happens remove the first (oldest) item from the feedActions list
void periodicFeedTimerReset() async {
  GameController gameController = Get.find<GameController>();
  gameController.setPeriodicResetIsHappening(true);
  gameController.getFeedTimer().onExecute.add(StopWatchExecute.reset);
  await Future.delayed(Duration(milliseconds: 500));
  gameController.getFeedTimer().onExecute.add(StopWatchExecute.start);
  if (gameController.getFeedActions().length > 0) {
    gameController.removeFirstFeedAction();
  }
  gameController.setPeriodicResetIsHappening(false);
  gameController.refresh();
}

/// adds item to the feedActions list
void addFeedItem(GameAction feedAction) async {
  GameController gameController = Get.find<GameController>();
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
  gameController.refresh();
}

/// gets triggered every time the period of the timer runs out or when the timer is reset
void onFeedTimerEnded() {
  GameController gameController = Get.find<GameController>();
  if (!gameController.getPeriodicResetIsHappening() && !gameController.getAddingFeedItem()) {
    periodicFeedTimerReset();
  }
}

/// Gets triggered when user clicks on a feed item
void removeFeedItem(GameAction action) {
  final GameController gameController = Get.find<GameController>();
  // delete feed item from database
  DatabaseRepository().deleteAction(action);
  // delete action from game state
  gameController.removeFeedAction(action);
  gameController.refresh();
}
