import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/appController.dart';
import '../../controllers/gameController.dart';
import '../../data/player.dart';
import '../../data/team.dart';
import 'on_field_checkbox.dart';

class PlayersList extends GetView<GameController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<GameController>(
      builder: (gameController) => Expanded(
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: gameController.getPlayersFromSelectedTeam().length,
            itemBuilder: (context, index) {
              Player player =
                  gameController.getPlayersFromSelectedTeam()[index];
              return Row(
                children: [
                  FloatingActionButton(
                      key: Key("FloatingActionButton $index"),
                      child: const Icon(Icons.remove),
                      onPressed: () {
                        removePlayerFromTeam(player);
                      }),
                  Text(
                    "${player.firstName} ${player.lastName}",
                    key: Key("Playertext $index"),
                  ),
                  OnFieldCheckbox(
                    key: Key("Checkbox $index"),
                    player: player,
                  )
                ],
              );
            }),
      ),
    );
  }

  void removePlayerFromTeam(Player player) {
    // need to get fresh appController here every time the method is called
    final AppController appController = Get.find<AppController>();
    final GameController gameController = Get.find<GameController>();
    // in order to update the team in the teams list of the local state
    Team selectedCacheTeam = appController.getAvailableTeams()
        .where((cachedTeamItem) =>
            (cachedTeamItem.id == gameController.getSelectedTeam().id))
        .toList()[0];
    selectedCacheTeam.players.remove(player);
    // update selected team with the player list as well
    gameController.setSelectedTeam(selectedCacheTeam);
    // remove the player from onFieldPlayers if necessary
    if (gameController.getOnFieldPlayers().contains(player)) {
      gameController.removeOnFieldPlayer(player);
    }
    gameController.refresh();
  }
}
