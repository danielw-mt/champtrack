import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/../controllers/globalController.dart';
import '../../data/player.dart';
import '../../data/team.dart';
import '../../data/database_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'on_field_checkbox.dart';

class PlayersList extends GetView<GlobalController> {
  final GlobalController globalController = Get.find<GlobalController>();
  // List<Player> chosenPlayers = [];
  // List<Player> playersOnField = [];
  DatabaseRepository repository = DatabaseRepository();
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: globalController.selectedTeam.value.players.length,
          itemBuilder: (context, index) {
            Player player = globalController.selectedTeam.value.players[index];
            return Row(
              children: [
                FloatingActionButton(
                    child: const Icon(Icons.remove),
                    onPressed: () {
                      removePlayerFromTeam(player);
                    }),
                Text("${player.firstName} ${player.lastName}"),
                OnFieldCheckbox(index: index)
              ],
            );
          }),
    );
  }

  void removePlayerFromTeam(Player player) {
    // remove player inside the teams stored in global controller
    // TODO solve this
    Team selectedCacheTeam = globalController.cachedTeamsList
        .where((cachedTeamItem) =>
            (cachedTeamItem.id == globalController.selectedTeam.value.id))
        .toList()[0];
    selectedCacheTeam.players.remove(player);
    globalController.selectedTeam.value = selectedCacheTeam;
    if (globalController.selectedTeam.value.onFieldPlayers.contains(player)) {
      globalController.selectedTeam.value.onFieldPlayers.remove(player);
    }
  }
}
