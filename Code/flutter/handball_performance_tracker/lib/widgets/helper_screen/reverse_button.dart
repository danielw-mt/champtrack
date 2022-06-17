import 'package:flutter/material.dart';
import '../../controllers/appController.dart';
import './../../controllers/globalController.dart';
import 'package:get/get.dart';

class ReverseButton extends GetView<GlobalController> {
  final AppController appController = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        onPressed: (() {
          if (!appController.actionsIsEmpty()) {
            appController.repository.deleteLastAction();
            appController.removeLastAction();
            // TODO: also remove last action from corresponding player and update Ef-Score
          }
        }),
        child: const Icon(Icons.undo));
  }
}
