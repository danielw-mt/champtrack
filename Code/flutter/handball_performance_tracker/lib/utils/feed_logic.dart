import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/controllers/globalController.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import '../data/game_action.dart';
import '../constants/settings_config.dart';

// when the periodic reset happens remove the first (oldest) item from the feedActions list
void periodicFeedTimerReset() async {
  final GlobalController globalController = Get.find<GlobalController>();
  globalController.periodicResetIsHappening.value = true;
  globalController.feedTimer.value.onExecute.add(StopWatchExecute.reset);
  await Future.delayed(Duration(milliseconds: 500));
  globalController.feedTimer.value.onExecute.add(StopWatchExecute.start);
  if (globalController.feedActions.length > 0) {
    globalController.feedActions.removeAt(0);
  }
  globalController.periodicResetIsHappening.value = false;
  globalController.periodicResetIsHappening.refresh();
  globalController.feedActions.refresh();
  globalController.feedTimer.refresh();
}

void addFeedItem(GameAction feedAction) async {
  
  final GlobalController globalController = Get.find<GlobalController>();
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
  globalController.feedActions.refresh();
  globalController.feedTimer.refresh();
  print("adding feed item: ${feedAction.actionType}");
}

void onFeedTimerEnded() {
  final GlobalController globalController = Get.find<GlobalController>();
  if (globalController.periodicResetIsHappening.value == false) {
    periodicFeedTimerReset();
  }
}

void removeFeedItem(int itemIndex) {
  final GlobalController globalController = Get.find<GlobalController>();
  // TODO implement backend
  //DatabaseRepository().deleteFeedItem(index);
  // delete action from game state
  globalController.feedActions.removeAt(itemIndex);
  globalController.feedActions.refresh();
}
