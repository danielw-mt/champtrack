import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/controllers/globalController.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import '../data/game_action.dart';
import '../constants/settings_config.dart';

// when the periodic reset happens remove the first (oldest) item from the feedActions list
void periodicFeedTimerReset() async {
  GlobalController globalController = Get.find<GlobalController>();
  globalController.periodicResetIsHappening.value = true;
  globalController.feedTimer.value.onExecute.add(StopWatchExecute.reset);
  await Future.delayed(Duration(milliseconds: 500));
  globalController.feedTimer.value.onExecute.add(StopWatchExecute.start);
  if (globalController.feedActions.length > 0) {
    globalController.feedActions.removeAt(0);
  }
  globalController.periodicResetIsHappening.value = false;
  globalController.refresh();
}

/// adds item to the feedActions list
void addFeedItem(GameAction feedAction) async {
  GlobalController globalController = Get.find<GlobalController>();
  // this is needed so that when the timer is reset here it does not remove an item
  // every time the timer is reset it triggers onFeedTimerEnded() which would remove the item again
  globalController.addingFeedItem.value = true;
  StopWatchTimer feedTimer = globalController.feedTimer.value;
  if (feedTimer.isRunning == false) {
    feedTimer.onExecute.add(StopWatchExecute.start);
    await Future.delayed(Duration(milliseconds: 500));
  } else {
    feedTimer.onExecute.add(StopWatchExecute.reset);
    await Future.delayed(Duration(milliseconds: 500));
    feedTimer.onExecute.add(StopWatchExecute.start);
  }
  // when there are too many items in this feed remove the oldest item
  if (globalController.feedActions.length == MAX_FEED_ITEMS) {
    globalController.feedActions.removeAt(0);
  }
  globalController.feedActions.add(feedAction);
  globalController.addingFeedItem.value = false;
  globalController.refresh();
}

/// gets triggered every time the period of the timer runs out or when the timer is reset
void onFeedTimerEnded() {
  GlobalController globalController = Get.find<GlobalController>();
  if (globalController.periodicResetIsHappening.value == false && globalController.addingFeedItem.value == false) {
    periodicFeedTimerReset();
  }
}

/// Gets triggered when user clicks on a feed item
void removeFeedItem(int itemIndex) {
  final GlobalController globalController = Get.find<GlobalController>();
  // TODO implement backend
  //DatabaseRepository().deleteFeedItem(index);
  // delete action from game state
  globalController.feedActions.removeAt(itemIndex);
  globalController.refresh();
}
