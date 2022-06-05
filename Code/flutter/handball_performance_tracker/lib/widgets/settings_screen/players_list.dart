import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/../controllers/globalController.dart';
import '../../data/player.dart';
import '../../data/team.dart';
import '../../data/database_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlayersList extends GetView<GlobalController> {
  final GlobalController globalController = Get.find<GlobalController>();
  // List<Player> chosenPlayers = [];
  // List<Player> playersOnField = [];
  DatabaseRepository repository = DatabaseRepository();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: repository.getTeamStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // if there is no team selected yet in global controller select the first team in the database
            if (globalController.selectedTeam.value.name == "Default team") {
              globalController.selectedTeam.value = Team.fromDocumentSnapshot(
                  snapshot.data!.docs[0]
                      as DocumentSnapshot<Map<String, dynamic>>);
              globalController.refresh();
            }
            return Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: globalController.selectedTeam.value.players.length,
                  itemBuilder: (context, index) {
                    Player player =
                        globalController.selectedTeam.value.players[index];
                    return Row(
                      children: [
                        FloatingActionButton(
                            child: const Icon(Icons.remove),
                            onPressed: () {
                              removePlayerFromTeam(player);
                            }),
                        Text("${player.firstName} ${player.lastName}"),
                        //OnFieldCheckbox(index: index)
                      ],
                    );
                  }),
            );
          }
          return Container();
        });
  }

  void removePlayerFromTeam(Player player) {
    globalController.selectedTeam.value.players.remove(player);
    if (globalController.selectedTeam.value.onFieldPlayers.contains(player)) {
      globalController.selectedTeam.value.onFieldPlayers.remove(player);
    }
  }
}
