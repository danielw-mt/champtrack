import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/settings_screen/team_dropdown.dart';
// import './../widgets/settings_screen/on_field_checkbox.dart';
import './../widgets/settings_screen/game_start_stop_buttons.dart';
import './../widgets/settings_screen/players_list.dart';
import './../controllers/globalController.dart';
import '../data/player.dart';

class SettingsScreen extends GetView<GlobalController> {
  // screen that allows players to be selected including what players are on the field or on the bench (non selected)
  final GlobalController globalController = Get.find<GlobalController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings Screen'),
      ),
      body: Column(
        children: [
          TeamDropdown(),
          //PlayersList(),
          GameStartStopButtons(),
          Text("Home goal is right side of screen"),
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
