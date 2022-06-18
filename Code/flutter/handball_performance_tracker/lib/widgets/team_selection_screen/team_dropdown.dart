import 'package:flutter/material.dart';
import '../../controllers/persistentController.dart';
import '../../controllers/tempController.dart';
import 'package:get/get.dart';
import '../../data/team.dart';
import '../../utils/teamTypeHelpers.dart';
import '../../constants/team_constants.dart';

// dropdown that shows all available teams belonging to the selected team type
class TeamDropdown extends GetView<TempController> {
  @override
  Widget build(BuildContext context) {
    persistentController appController = Get.find<persistentController>();

    // select a default team
    // TODO write a function to select the default team in gameController / utils instead of just having "Default team"

    return // build the dropdown button
        GetBuilder(
      id: "team-dropdown",
      builder: (TempController gameController) {
        int selectedTeamTypeInt = gameController.getSelectedTeamType();
        String selectedTeamTypeString = TEAM_TYPE_MAPPING[selectedTeamTypeInt];
        // available teams are all the ones that match the selected team type (0,1,2) => "men", "women", "youth"
        List<Team> availableTeams = appController
            .getAvailableTeams()
            .where((Team team) => team.type == selectedTeamTypeString)
            .toList();
        updateSelectedTeamAccordingToTeamType();
        return DropdownButton<Team>(
          value: gameController.getSelectedTeam(),
          icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (Team? newTeam) {
            gameController.setSelectedTeam(availableTeams
                .where((Team teamItem) => teamItem.id == newTeam?.id)
                .first);
          },
          // build dropdown item widgets
          items: availableTeams.map<DropdownMenuItem<Team>>((Team team) {
            return DropdownMenuItem<Team>(
              value: team,
              child: Text(team.name),
            );
          }).toList(),
        );
      },
    );
  }
}
