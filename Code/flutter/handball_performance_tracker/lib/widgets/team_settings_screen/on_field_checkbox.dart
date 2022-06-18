import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/constants/team_constants.dart';
import '../../controllers/tempController.dart';
import 'package:get/get.dart';
import '../../data/player.dart';

class OnFieldCheckbox extends StatelessWidget {
  final Player player;
  // constructor: index parameter of index of the player in the selected players list
  OnFieldCheckbox({Key? key, required this.player}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TempController>(
        id: "on-field-checkbox",
        builder: (gameController) {
          List<Player> playersOnField = gameController.getOnFieldPlayers();
          return Checkbox(
            value: playersOnField.contains(player), //playersOnField[index],
            onChanged: (value) {
              // count how many players are selected as starting players
              int numOnField = playersOnField.length;
              // when you try to check a checkbox it should only be possible with less than 7 players
              if (value == true) {
                if (numOnField < PLAYER_NUM) {
                  if (!playersOnField.contains(player)) {
                    gameController.addOnFieldPlayer(player);
                  }
                }
              } else {
                if (playersOnField.contains(player)) {
                  gameController.removeOnFieldPlayer(player);
                }
              }
              // after changing players with the checkboxes, update the player bar with those players
              gameController.setPlayerBarPlayers();
            },
          );
        });
  }
}
