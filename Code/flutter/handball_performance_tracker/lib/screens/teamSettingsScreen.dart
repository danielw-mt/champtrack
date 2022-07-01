import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/widgets/nav_drawer.dart';
import '../controllers/tempController.dart';
import '../widgets/team_settings_screen/players_list.dart';
import '../widgets/team_settings_screen/team_settings_bar.dart';
import '../widgets/team_settings_screen/team_details_form.dart';

// A screen where all relevant Infos of a team can be edited (players, game history and team details like name)
// screen that allows players to be selected including what players are on the field or on the bench (non selected)
class TeamSettingsScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TempController tempController = Get.put(TempController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TempController>(
      id: "team-setting-screen",
      builder: (gameController) {
        return DefaultTabController(
          initialIndex: gameController.getSelectedTeamSetting(),
          length: 3,
          child: Scaffold(
              key: _scaffoldKey,
              drawer: NavDrawer(),
              // if drawer is closed notify, so if game is running the back to game button appears on next opening
              onDrawerChanged: (isOpened) {
                if (!isOpened) {
                  tempController.setMenuIsEllapsed(false);
                }
              },
              bottomNavigationBar: TeamSettingsBar(),
              body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Container for menu button on top left corner
                    MenuButton(_scaffoldKey),
                    if (gameController.getSelectedTeamSetting() == 0)
                      PlayersList(),
                    if (gameController.getSelectedTeamSetting() == 1)
                      Text("TODO Games"),
                    if (gameController.getSelectedTeamSetting() == 2)
                      TeamDetailsForm()
                  ])),
        );
      },
    );
  }
}
