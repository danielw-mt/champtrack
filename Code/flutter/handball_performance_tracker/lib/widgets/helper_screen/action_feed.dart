import 'package:flutter/material.dart';
import './../../controllers/globalController.dart';
import 'package:get/get.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import '../../data/game_action.dart';

class ActionFeed extends GetView<GlobalController> {
  // stop watch widget that allows to the time to be started, stopped, resetted and in-/decremented by 1 sec
  final GlobalController globalController = Get.find<GlobalController>();
  final numFeedItems = 5;

  @override
  Widget build(BuildContext context) {
    StopWatchTimer feedTimer = globalController.feedTimer.value;
    return Column(
      children: [
        StreamBuilder<int>(
          stream: feedTimer.rawTime,
          initialData: feedTimer.rawTime.value,
          builder: (context, snap) {
            final value = snap.data!;
            final displayTime =
                StopWatchTimer.getDisplayTime(value, hours: true);
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    displayTime,
                    style: const TextStyle(
                        fontSize: 40,
                        fontFamily: 'Helvetica',
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        ),
        GetBuilder<GlobalController>(
          builder: (_) => ListView.builder(
              shrinkWrap: true,
              itemCount: globalController.numCurrentFeedItems.value,
              itemBuilder: (context, index) {
                var actions = globalController.actions;
                List<dynamic> lastActions = actions.sublist(
                    actions.length - globalController.numCurrentFeedItems.value,
                    actions.length);
                print(lastActions);
                GameAction lastAction = lastActions[index];
                String actionType = lastAction.actionType;
                return Text(actionType);
              }),
        )
      ],
    );
  }
}
//   List<dynamic> getLastActions() {
   
//     print("last actions: " + numLastActions.toString());
//     // get last x itmes
//     GetBuilder<GlobalController>(
//           builder: (_) => actions.sublist(
//         actions.length - globalController.numCurrentFeedItems.value,
//         actions.length););
//   }
// }
