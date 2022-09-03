import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/controllers/persistentController.dart';
import 'package:handball_performance_tracker/controllers/tempController.dart';
import 'package:handball_performance_tracker/controllers/tempController.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/constants/stringsDashboard.dart';
import '../../screens/mainScreen.dart';
import '../../utils/sync_game_state.dart';

class OldGameCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TempController>(builder: (tempController) {
      if (tempController.oldGameStateExists()) {
        return GestureDetector(
          onTap: () {
            // restore old game state
            recreateGameStateFromFirebase();
            PersistentController persistentController =
                Get.find<PersistentController>();
            print("most recent stopwatchtime: " +
                persistentController
                    .getCurrentGame()
                    .stopWatchTimer
                    .rawTime
                    .value
                    .toString());
            // move to main Screen
            Get.to(() => MainScreen());
          },
          child: Card(child: Text(StringsDashboard.lRecreateOldGame)),
        );
      } else {
        return Container();
      }
    });
  }
}
