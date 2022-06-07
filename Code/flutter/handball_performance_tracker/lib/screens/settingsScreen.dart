import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/widgets/nav_drawer.dart';
import '../widgets/settings_screen/team_dropdown.dart';
// import './../widgets/settings_screen/on_field_checkbox.dart';
import './../widgets/settings_screen/game_start_stop_buttons.dart';
import './../widgets/settings_screen/players_list.dart';
import './../controllers/globalController.dart';
import '../data/player.dart';

class SettingsScreen extends GetView<GlobalController> {
  // screen that allows players to be selected including what players are on the field or on the bench (non selected)
  final GlobalController globalController = Get.find<GlobalController>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: NavDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container for menu button on top left corner
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                color: Colors.white),
            child: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                _scaffoldKey.currentState!.openDrawer();
              },
            ),
          ),
          TeamDropdown(),
          PlayersList(),
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
