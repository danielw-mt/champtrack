import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/widgets/main_screen/action_menu.dart';
import '../../controllers/globalController.dart';
import 'package:get/get.dart';
import '../../strings.dart';
import '../../utils/team_type_helpers.dart';


// Bottom Nav Bar for team settings screen
class TeamSettingsBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<GlobalController>(
      builder: (GlobalController globalController) {
        return Container(
          color: Color(0xFF3F5AA6),
          child: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding: EdgeInsets.all(5.0),
            indicatorColor: Colors.blue,
            onTap: (int tabNumber) {
              globalController.selectedTeamSetting.value = tabNumber;
              globalController.refresh();
            },
            tabs: [
              Tab(
                text: Strings.lPlayer,
                icon: Icon(Icons.sports_handball),
              ),
              Tab(
                text: Strings.lGames,
                icon: Icon(Icons.list_alt),
              ),
              Tab(
                text: Strings.lTeamDetails,
                icon: Icon(Icons.book),
              ),
            ],
          ),
        );
      },
    );
  }
}
