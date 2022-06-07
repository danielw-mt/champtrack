import 'package:flutter/material.dart';
import './../../controllers/globalController.dart';
import 'package:get/get.dart';
import '../../data/player.dart';

class OnFieldCheckbox extends StatelessWidget {
  final Player player;
  // constructor: index parameter of index of the player in the selected players list
  OnFieldCheckbox({Key? key, required this.player}) : super(key: key);

  // GlobalController globalController = Get.find<GlobalController>();

  @override
  Widget build(BuildContext context) {
    // TODO adapt this to new player variables
    return GetBuilder<GlobalController>(builder: (globalController) {
      List<Player> playersOnField =
          globalController.selectedTeam.value.onFieldPlayers;
      return Checkbox(
        value: playersOnField.contains(player), //playersOnField[index],
        onChanged: (value) {
          // count how many players are selected as starting players
          int numOnField = playersOnField.length;
          // when you try to check a checkbox it should only be possible with less than 7 players
          if (value == true) {
            if (numOnField < 7) {
              if (!playersOnField.contains(player)) {
                playersOnField.add(player);
              }
            }
          } else {
            if (playersOnField.contains(player)) {
              playersOnField.remove(player);
            }
          }
          globalController.refresh();
        },
      );
    });
  }
}
