import 'package:flutter/material.dart';
import '../../controllers/persistentController.dart';
import 'package:get/get.dart';
import '../../controllers/tempController.dart';

class ReverseButton extends GetView<TempController> {
  final persistentController appController = Get.find<persistentController>();

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
