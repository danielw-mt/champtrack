import 'package:get/get.dart';
import '../controllers/tempController.dart';
import '../data/game_action.dart';
import '../constants/settings_config.dart';


/// adds item to the feedActions list
void addFeedItem(GameAction feedAction) async {
  TempController gameController = Get.find<TempController>();
  
  // when there are too many items in this feed remove the oldest item
  if (gameController.getFeedActions().length == MAX_FEED_ITEMS) {
    gameController.removeFirstFeedAction();
  }
  gameController.addFeedAction(feedAction);
}


/// Gets triggered when user clicks on a feed item
void removeFeedItem(GameAction action, TempController tempController) {
  // delete action from game state and database
  tempController.removeFeedAction(action);
  // update player's ef.score
  tempController.updatePlayerEfScore(action.playerId, action,
      removeAction: true);
}
