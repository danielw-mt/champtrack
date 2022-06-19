import 'package:flutter/material.dart';
import '../../controllers/tempController.dart';
import 'package:get/get.dart';
import '../../strings.dart';
import '../../utils/teamTypeHelpers.dart';

class TeamTypeSelectionBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TempController>(
      id: "team-type-selection-bar",
      builder: (TempController gameController) {
        return Container(
          color: Color(0xFF3F5AA6),
          child: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding: EdgeInsets.all(5.0),
            indicatorColor: Colors.blue,
            onTap: (int tabNumber) {
                gameController.setSelectedTeamType(tabNumber);
                updateSelectedTeamAccordingToTeamType();
            },
            tabs: [
              Tab(
                text: Strings.lMenTeams,
                icon: Icon(Icons.male),
              ),
              Tab(
                text: Strings.lWomenTeams,
                icon: Icon(Icons.female),
              ),
              Tab(
                text: Strings.lYouthTeams,
                icon: Icon(Icons.child_care),
              ),
            ],
          ),
        );
      },
    );
  }
}
