import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/constants/colors.dart';
import '../../constants/stringsGeneral.dart';
import '../../controllers/tempController.dart';

// Bottom Nav Bar for team settings screen
class TeamSettingsBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TempController>(
      id: "team-settings-bar",
      builder: (TempController tempController) {
        return Container(
          color: Color(0xFF3F5AA6),
          child: TabBar(
            controller: DefaultTabController.of(context),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding: EdgeInsets.all(5.0),
            indicatorColor: buttonDarkBlueColor,
            onTap: (int tabNumber) {
              tempController.setSelectedTeamSetting(tabNumber);
            },
            tabs: [
              Tab(
                text: StringsGeneral.lPlayer,
                icon: Icon(Icons.sports_handball),
              ),
              Tab(
                text: StringsGeneral.lGames,
                icon: Icon(Icons.list_alt),
              ),
              Tab(
                text: StringsGeneral.lTeamDetails,
                icon: Icon(Icons.book),
              ),
            ],
          ),
        );
      },
    );
  }
}
