import 'package:flutter/material.dart';
import './../../controllers/globalController.dart';
import 'package:get/get.dart';
import '../../data/database_repository.dart';

class ReverseButton extends GetView<GlobalController> {
  final GlobalController globalController = Get.find<GlobalController>();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        onPressed: (() {
          if (globalController.actions.isNotEmpty) {
            globalController.repository.deleteLastAction();
            globalController.actions.removeLast();
          }
        }),
        child: const Icon(Icons.undo));
  }
}
