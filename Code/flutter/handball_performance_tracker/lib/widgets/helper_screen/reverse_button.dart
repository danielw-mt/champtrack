import 'package:flutter/material.dart';
import '../../controllers/appController.dart';
import 'package:get/get.dart';
import '../../controllers/gameController.dart';

class ReverseButton extends GetView<GameController> {
  final AppController appController = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        onPressed: (() {
          if (!appController.actionsIsEmpty()) {
            appController.removeLastAction();
            // TODO: also remove last action from corresponding player and update Ef-Score
          }
        }),
        child: const Icon(Icons.undo));
  }
}
