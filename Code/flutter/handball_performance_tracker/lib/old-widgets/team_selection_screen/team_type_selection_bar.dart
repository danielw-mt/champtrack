import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/old-constants/colors.dart';
import '../../controllers/temp_controller.dart';
import 'package:get/get.dart';
import '../../old-constants/stringsGeneral.dart';
import '../../old-utils/team_type_helpers.dart';

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
            indicatorColor: buttonDarkBlueColor,
            onTap: (int tabNumber) {
              gameController.setSelectedTeamType(tabNumber);
              updateSelectedTeamAccordingToTeamType();
            },
            tabs: [
              Tab(
                text: StringsGeneral.lMenTeams,
                icon: Icon(Icons.male),
              ),
              Tab(
                text: StringsGeneral.lWomenTeams,
                icon: Icon(Icons.female),
              ),
              Tab(
                text: StringsGeneral.lYouthTeams,
                icon: Icon(Icons.child_care),
              ),
            ],
          ),
        );
      },
    );
  }
}
