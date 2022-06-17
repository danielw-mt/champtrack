import 'package:flutter/material.dart';
import '../../controllers/gameController.dart';
import 'package:get/get.dart';
import '../../data/game_action.dart';
import '../../data/player.dart';
import '../../utils/feed_logic.dart';

/// A widget that displays the newest actions. It can be tweaked in lib/const/settings_config
/// GameActions are periodically removed and can also be removed by clicking on them
class ActionFeed extends GetView<GameController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<GameController>(
      id: "action-feed",
      builder: (gameController) {
        List<GameAction> feedActions = gameController.getFeedActions();
        return Container(
          alignment: Alignment.centerLeft,
          width: MediaQuery.of(context).size.width * 0.3,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: feedActions.length,
              itemBuilder: (context, index) {
                GameAction feedAction = feedActions[index];
                String actionType = feedAction.actionType;
                // get the player object whose id matches the playerId in the action Object
                Player relevantPlayer = gameController.getPlayerFromSelectedTeam(feedAction.playerId);
                return GestureDetector(
                    onTap: () async {
                      removeFeedItem(feedAction);
                    },
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(100, 217, 217, 217),
                                    borderRadius: 
                                        BorderRadius.all(Radius.circular(10))),
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      actionType,
                                    )),
                              ),
                            ),
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  relevantPlayer.lastName,
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ), Icon(Icons.delete)
                          ],
                        ),
                        Divider()
                      ],
                    ));
              }),
        );
      },
    );
  }
}
