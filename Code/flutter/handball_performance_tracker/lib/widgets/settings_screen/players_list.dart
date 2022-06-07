import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/../controllers/globalController.dart';
import '../../data/player.dart';
import '../../data/team.dart';
import '../../data/database_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'on_field_checkbox.dart';

class PlayersList extends GetView<GlobalController> {
  DatabaseRepository repository = DatabaseRepository();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<GlobalController>(
      builder: (globalController) => Expanded(
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: globalController.selectedTeam.value.players.length,
            itemBuilder: (context, index) {
              Player player =
                  globalController.selectedTeam.value.players[index];
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
    // need to get fresh globalController here every time the method is called
    final GlobalController globalController = Get.find<GlobalController>();
    // in order to update the team in the teams list of the local state
    Team selectedCacheTeam = globalController.cachedTeamsList
        .where((cachedTeamItem) =>
            (cachedTeamItem.id == globalController.selectedTeam.value.id))
        .toList()[0];
    selectedCacheTeam.players.remove(player);
    // update selected team with the player list as well
    globalController.selectedTeam.value = selectedCacheTeam;
    // remove the player from onFieldPlayers if necessary
    if (globalController.selectedTeam.value.onFieldPlayers.contains(player)) {
      globalController.selectedTeam.value.onFieldPlayers.remove(player);
    }
    globalController.refresh();
  }
}
