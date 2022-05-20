import 'package:flutter/material.dart';
import './../../controllers/globalController.dart';
import 'package:get/get.dart';

class OnFieldCheckbox extends StatelessWidget {
  final int index;
  // constructor: index parameter of index of the player in the selected players list
  OnFieldCheckbox({Key? key, required this.index}) : super(key: key);

  GlobalController globalController = Get.find<GlobalController>();

  @override
  Widget build(BuildContext context) {
    var playersOnField = globalController.playersOnField;

    return GetBuilder<GlobalController>(
        builder: (_) => Checkbox(
              value: playersOnField[index],
              onChanged: (value) {
                // count how many players are selected as starting players
                var numStarting =
                    playersOnField.where((c) => c == true).toList().length + 1;
                if (numStarting < 8) {
                  playersOnField[index] = !playersOnField[index];
                  globalController.refresh();
                }
              },
            ));
  }
}
