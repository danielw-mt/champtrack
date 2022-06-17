import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/gameController.dart';


// Bottom Nav Bar for team settings screen
class TeamSettingsBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<GameController>(
      id: "team-settings-bar",
      builder: (GameController gameController) {
        return Container(
          color: Color(0xFF3F5AA6),
          child: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding: EdgeInsets.all(5.0),
            indicatorColor: Colors.blue,
            onTap: (int tabNumber) {
              gameController.setSelectedTeamSetting(tabNumber);
            },
            tabs: [
              Tab(
                text: "Players",
                icon: Icon(Icons.sports_handball),
              ),
              Tab(
                text: "Games",
                icon: Icon(Icons.list_alt),
              ),
              Tab(
                text: "Team Details",
                icon: Icon(Icons.book),
              ),
            ],
          ),
        );
      },
    );
  }
}
