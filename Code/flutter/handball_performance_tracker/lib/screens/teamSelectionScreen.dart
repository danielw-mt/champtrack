import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/widgets/nav_drawer.dart';
import '../widgets/team_selection_screen/team_dropdown.dart';
import '../widgets/team_selection_screen/team_type_selection_bar.dart';
import './../controllers/globalController.dart';
import 'teamSettingsScreen.dart';


// A screen where all the available teams are listed for men, women and youth teams
class TeamSelectionScreen extends GetView<GlobalController> {
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
              bottomNavigationBar: TeamTypeSelectionBar(),
              body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MenuButton(_scaffoldKey),
                    TeamDropdown(),
                    TextButton(
                        onPressed: () {
                          Get.to(TeamSettingsScreen());
                        },
                        child: Icon(Icons.edit))
                  ])),
        );
      },
    );
  }
}
