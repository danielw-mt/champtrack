import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/constants/colors.dart';
import 'package:handball_performance_tracker/constants/stringsGeneral.dart';
import 'package:handball_performance_tracker/widgets/nav_drawer.dart';
import '../controllers/tempController.dart';
import '../widgets/team_selection_screen/team_dropdown.dart';
import '../widgets/team_selection_screen/team_type_selection_bar.dart';
import '../widgets/team_selection_screen/add_new_team_form.dart';
import 'teamSettingsScreen.dart';

// A screen where all the available teams are listed for men, women and youth teams
class TeamSelectionScreen extends StatelessWidget {
  // screen that allows players to be selected including what players are on the field or on the bench (non selected)
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // TODO Get.find instead of Get.put?
  final TempController tempController = Get.put(TempController());

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
              key: _scaffoldKey,
              drawer: NavDrawer(),
              // if drawer is closed notify, so if game is running the back to game button appears on next opening
              onDrawerChanged: (isOpened) {
                if (!isOpened) {
                  tempController.setMenuIsEllapsed(false);
                }
              },
              bottomNavigationBar: TeamTypeSelectionBar(),
              body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MenuButton(_scaffoldKey),
                    // TODO implement team cards here instead of dropdown
                    TeamDropdown(),
                    TextButton(
                        onPressed: () {
                          Get.to(() => TeamSettingsScreen());
                        },
                        child: Icon(Icons.edit, color: buttonDarkBlueColor)),
                    Spacer(),
                    FloatingActionButton(
                        onPressed: (() => showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text(StringsGeneral.lAddTeam),
                                  content: NewTeamForm(),
                                ))),
                        child: Icon(Icons.add),
                        backgroundColor: buttonDarkBlueColor)
                  ])),
        );
      },
    ));
  }
}
