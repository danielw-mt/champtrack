import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Strings.dart';
import './../widgets/settings_screen/player_dropdown.dart';
import './../widgets/settings_screen/on_field_checkbox.dart';
import './../widgets/settings_screen/game_start_stop_buttons.dart';
import './../controllers/globalController.dart';

class SettingsScreen extends GetView<GlobalController> {
  // screen that allows players to be selected including what players are on the field or on the bench (non selected)
  final GlobalController globalController = Get.find<GlobalController>();

  @override
  Widget build(BuildContext context) {
    var chosenPlayers = globalController.chosenPlayers;
    var playersOnField = globalController.playersOnField;

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
                    var numStarting =
                        playersOnField.where((c) => c == true).toList().length;
                    chosenPlayers.add(globalController.selectedPlayer.value);
                    playersOnField.add(false);
                  })),
            ],
          ),
          Obx(() {
            if (chosenPlayers.isNotEmpty) {
              return Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: chosenPlayers.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          FloatingActionButton(
                              child: const Icon(Icons.remove),
                              onPressed: () {
                                chosenPlayers.removeAt(index);
                                playersOnField.removeAt(index);
                              }),
                          Text(globalController.chosenPlayers[index].name),
                          OnFieldCheckbox(index: index)
                        ],
                      );
                    }),
              );
            }
            return Container();
          }),
          GameStartStopButtons(),
          const Text(Strings.lFieldSideIsRight),
          Obx(() => Switch(
              value: globalController.attackIsLeft.value,
              onChanged: (bool) {
                globalController.attackIsLeft.value =
                    !globalController.attackIsLeft.value;
                globalController.refresh();
              }))
        ],
      ),
    );
  }
}
