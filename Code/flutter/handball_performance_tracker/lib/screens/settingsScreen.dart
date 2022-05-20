import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './../widgets/settings_screen/player_dropdown.dart';
import './../controllers/globalController.dart';

class SettingsScreen extends GetView<GlobalController> {
  // screen that allows players to be selected including what players are on the field or on the bench (non selected)

  final GlobalController globalController = Get.find<GlobalController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Two'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: PlayerDropdown()),
              FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: (() {
                    globalController.chosenPlayers
                        .add(globalController.selectedPlayer.value);
                    globalController.startingPlayers.add(false);
                  })),
            ],
          ),
          Obx(() {
            if (globalController.chosenPlayers.length > 0) {
              return Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: globalController.chosenPlayers.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          FloatingActionButton(
                              child: Icon(Icons.remove),
                              onPressed: () {
                                globalController.chosenPlayers.removeAt(index);
                                globalController.startingPlayers
                                    .removeAt(index);
                              }),
                          Text(globalController.chosenPlayers[index]),
                          GetBuilder<GlobalController>(
                              builder: (_) => Checkbox(
                                    value:
                                        globalController.startingPlayers[index],
                                    onChanged: (value) {
                                      // count how many players are selected as starting players
                                      var num_starting = globalController
                                              .startingPlayers
                                              .where((c) => c == true)
                                              .toList()
                                              .length +
                                          1;
                                      if (num_starting < 8) {
                                        globalController
                                                .startingPlayers[index] =
                                            !globalController
                                                .startingPlayers[index];
                                        globalController.refresh();
                                      }
                                    },
                                  ))
                        ],
                      );
                    }),
              );
            }
            return Container();
          })
        ],
      ),
    );
  }
}
