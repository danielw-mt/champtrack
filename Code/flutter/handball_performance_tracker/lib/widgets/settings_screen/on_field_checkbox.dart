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

    // TODO adapt this to new player variables
    return GetBuilder<GlobalController>(
        builder: (_) => Checkbox(
              value: true, //playersOnField[index],
              onChanged: (value) {
                // count how many players are selected as starting players
                var numOnField =
                    playersOnField.where((c) => c == true).toList().length;
                // when you try to check a checkbox it should only be possible with less than 7 players
                // if (value == true) {
                //   if (numOnField < 7) {
                //     playersOnField[index] = true;
                //   }
                // } else {
                //   playersOnField[index] = false;
                // }
                globalController.refresh();
              },
            ));
  }
}
