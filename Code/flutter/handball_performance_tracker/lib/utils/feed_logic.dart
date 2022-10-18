import 'package:get/get.dart';
import 'package:handball_performance_tracker/constants/game_actions.dart';
import '../controllers/temp_controller.dart';
import '../data/game_action.dart';
import '../constants/settings_config.dart';

/// adds item to the feedActions list
void addFeedItem(GameAction feedAction) async {
  TempController gameController = Get.find<TempController>();
  gameController.addFeedAction(feedAction);
}

/// Gets triggered when user clicks on a feed item
void removeFeedItem(GameAction action, TempController tempController) {
  // delete action from game state and database
  tempController.removeFeedAction(action);
  // decrease own score by one if a goal action was deleted
  if (action.tag == goalTag) {
    tempController.decOwnScore();
  } else if (action.tag == goalOpponentTag || action.tag == emptyGoalTag) {
    tempController.decOpponentScore();
  }
  // update player's ef.score
  tempController.updatePlayerEfScore(action.playerId, action, removeAction: true);
}
