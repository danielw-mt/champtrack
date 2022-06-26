import 'package:flutter/material.dart';
import '../../controllers/persistentController.dart';
import 'package:get/get.dart';

class ReverseButton extends StatelessWidget {
  final PersistentController persistentController = Get.find<PersistentController>();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        onPressed: (() {
          if (!persistentController.actionsIsEmpty()) {
            persistentController.removeLastAction();
            // TODO: also remove last action from corresponding player and update Ef-Score
          }
        }),
        child: const Icon(Icons.undo));
  }
}
