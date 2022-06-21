import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/persistentController.dart';
import '../../controllers/tempController.dart';
import '../../data/player.dart';
import '../../data/team.dart';
import 'on_field_checkbox.dart';

class PlayersList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TempController>(
      id: "players-list",
      builder: (tempController) => Expanded(
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: tempController.getPlayersFromSelectedTeam().length,
            itemBuilder: (context, index) {
              Player player =
                  tempController.getPlayersFromSelectedTeam()[index];
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
    // need to get fresh persistentController here every time the method is called
    final PersistentController persistentController = Get.find<PersistentController>();
    final TempController tempController = Get.find<TempController>();
    // in order to update the team in the teams list of the local state
    Team selectedCacheTeam = persistentController
        .getAvailableTeams()
        .where((cachedTeamItem) =>
            (cachedTeamItem.id == tempController.getSelectedTeam().id))
        .toList()[0];
    selectedCacheTeam.players.remove(player);
    // update selected team with the player list as well
    tempController.setSelectedTeam(selectedCacheTeam);
    // remove the player from onFieldPlayers if necessary
    if (tempController.getOnFieldPlayers().contains(player)) {
      tempController.removeOnFieldPlayer(player);
    }
  }
}
