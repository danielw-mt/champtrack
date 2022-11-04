import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/oldcontrollers/persistent_controller.dart';
import 'package:handball_performance_tracker/oldcontrollers/temp_controller.dart';
import 'package:handball_performance_tracker/oldcontrollers/temp_controller.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/core/constants/stringsDashboard.dart';
import '../../old-screens/main_screen.dart';
import '../../old-utils/sync_game_state.dart';

class OldGameCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TempController>(builder: (tempController) {
      if (tempController.oldGameStateExists()) {
        return GestureDetector(
          onTap: () async {
            // restore old game state
            await recreateGameStateFromFirebase();
            PersistentController persistentController =
                Get.find<PersistentController>();
            // move to main Screen
            Get.to(() => MainScreen());
            tempController.update(["action-feed", "ef-score-bar"]);
          },
          child: Card(child: Text(StringsDashboard.lRecreateOldGame)),
        );
      } else {
        return Container();
      }
    });
  }
}
