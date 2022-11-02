import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/core/constants/colors.dart';
import 'package:handball_performance_tracker/core/constants/stringsGeneral.dart';
import 'package:handball_performance_tracker/core/constants/stringsTeamManagement.dart';
import 'package:handball_performance_tracker/controllers/persistent_controller.dart';
import 'package:handball_performance_tracker/old-widgets/nav_drawer.dart';
import '../controllers/temp_controller.dart';
import '../old-widgets/team_selection_screen/team_dropdown.dart';
import '../old-widgets/team_selection_screen/team_type_selection_bar.dart';
import '../old-widgets/team_selection_screen/add_new_team_form.dart';
import 'team_settings_screen.dart';

// A screen where all the available teams are listed for men, women and youth teams
class TeamSelectionScreen extends StatelessWidget {
  // screen that allows players to be selected including what players are on the field or on the bench (non selected)
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // TODO Get.find instead of Get.put?
  final TempController tempController = Get.put(TempController());
  final PersistentController persistentController = Get.find<PersistentController>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: GetBuilder<TempController>(
      id: "team-selection-screen",
      builder: (gameController) {
        return DefaultTabController(
          initialIndex: gameController.getSelectedTeamSetting(),
          length: 3,
          child: Scaffold(
              appBar: AppBar(backgroundColor: buttonDarkBlueColor, title: Text("Teams")),
              key: _scaffoldKey,
              drawer: NavDrawer(),
              // if drawer is closed notify, so if game is running the back to game button appears on next opening
              onDrawerChanged: (isOpened) {
                if (!isOpened) {
                  tempController.setMenuIsEllapsed(false);
                }
              },
              bottomNavigationBar: TeamTypeSelectionBar(),
              body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                //MenuButton(_scaffoldKey),
                // TODO implement team cards here instead of dropdown
                Center(child: TeamDropdown()),

                Container(
                  height: 20,
                ),
                // don't display edit button if there are no teams
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      persistentController.getAvailableTeams().length == 0
                          ? Container()
                          : Flexible(
                              child: ElevatedButton(
                                  onPressed: () {
                                    Get.to(() => TeamSettingsScreen());
                                  },
                                  child: Text(StringsTeamManagement.lManageTeam)),
                            ),
                      Container(
                        width: 20,
                      ),
                      Flexible(
                        child: ElevatedButton(
                          onPressed: (() => showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text(StringsGeneral.lAddTeam),
                                    content: NewTeamForm(),
                                  ))),
                          child: Text(StringsTeamManagement.lAddTeam),
                        ),
                      )
                    ],
                  ),
                ),
              ])),
        );
      },
    ));
  }
}
