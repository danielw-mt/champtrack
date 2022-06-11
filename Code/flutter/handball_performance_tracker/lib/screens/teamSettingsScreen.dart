import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/widgets/nav_drawer.dart';
import '../widgets/team_settings_screen/players_list.dart';
import '../widgets/team_settings_screen/team_settings_bar.dart';
import './../controllers/globalController.dart';


class TeamSettingsScreen extends GetView<GlobalController> {
  // screen that allows players to be selected including what players are on the field or on the bench (non selected)
  final GlobalController globalController = Get.find<GlobalController>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GlobalController>(
      builder: (globalController) {
        return DefaultTabController(
          initialIndex: globalController.selectedTeamSetting.value,
          length: 3,
          child: Scaffold(
              key: _scaffoldKey,
              drawer: NavDrawer(),
              bottomNavigationBar: TeamSettingsBar(),
              body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Container for menu button on top left corner
                    MenuButton(_scaffoldKey),
                    if (globalController.selectedTeamSetting.value == 0) PlayersList(),
                    if (globalController.selectedTeamSetting.value == 1) Text("Games"),
                    if (globalController.selectedTeamSetting.value == 2) Text("Team Details")
                  ])),
        );
      },
    );
  }
}
