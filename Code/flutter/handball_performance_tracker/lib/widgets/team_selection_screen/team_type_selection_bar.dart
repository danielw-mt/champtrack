import 'package:flutter/material.dart';
import '../../controllers/gameController.dart';
import 'package:get/get.dart';
import '../../utils/teamTypeHelpers.dart';

class TeamTypeSelectionBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<GameController>(
      id: "team-type-selection-bar",
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
              gameController.setSelectedTeamType(tabNumber);
              updateSelectedTeamAccordingToTeamType();
            },
            tabs: [
              Tab(
                text: "Herren",
                icon: Icon(Icons.male),
              ),
              Tab(
                text: "Damen",
                icon: Icon(Icons.female),
              ),
              Tab(
                text: "Jugend",
                icon: Icon(Icons.child_care),
              ),
            ],
          ),
        );
      },
    );
  }
}
