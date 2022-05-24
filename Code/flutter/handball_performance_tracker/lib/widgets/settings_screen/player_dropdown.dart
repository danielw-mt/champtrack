import 'package:flutter/material.dart';
import '../../data/database_repository.dart';
import '../../data/player.dart';
import '../../controllers/globalController.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlayerDropdown extends StatelessWidget {
  // dropdown that pull the available players from the players collection in firestore

  GlobalController globalController = Get.find<GlobalController>();

  @override
  Widget build(BuildContext context) {
    DatabaseRepository repository = DatabaseRepository();

    List<Player> availablePlayers = [];

    return StreamBuilder<QuerySnapshot>(
      stream: repository.getPlayerStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // set default selection
          globalController.selectedPlayer.value = Player.fromDocumentSnapshot(
              snapshot.data!.docs[0] as DocumentSnapshot<Map<String, dynamic>>);
          for (var element in snapshot.data!.docs) {
            Player player = Player.fromDocumentSnapshot(
                element as DocumentSnapshot<Map<String, dynamic>>);
            if (!availablePlayers.contains(player)) {
              availablePlayers.add(player);
            }
          }
          return Obx(() => DropdownButton<String>(
                value: globalController.selectedPlayer.value.name,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String? newValue) {
                  globalController.selectedPlayer.value = availablePlayers
                      .firstWhere((element) => element.name == newValue);
                },
                items: availablePlayers
                    .map<DropdownMenuItem<String>>((Player player) {
                  return DropdownMenuItem<String>(
                    value: player.name,
                    child: Text(player.name),
                  );
                }).toList(),
              ));
        }
        return Container();
      },
    );
  }
}
