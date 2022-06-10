import 'package:flutter/material.dart';
import '../../data/database_repository.dart';
import '../../data/player.dart';
import '../../controllers/globalController.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/team.dart';
import '../../utils/teamTypeHelpers.dart';

// dropdown that shows all available teams belonging to the selected team type
class TeamDropdown extends GetView<GlobalController> {
  @override
  Widget build(BuildContext context) {
    DatabaseRepository repository = DatabaseRepository();

    // select a default team
    // TODO write a function to select the default team in globalController / utils instead of just having "Default team"

    return // build the dropdown button
        GetBuilder(
      builder: (GlobalController globalController) {
        List<String> teamTypeMapping = ["men", "women", "youth"];
        int selectedTeamTypeInt = globalController.selectedTeamType.value;
        String selectedTeamTypeString = teamTypeMapping[selectedTeamTypeInt];
        // available teams are all the ones that match the selected team type (0,1,2) => "men", "women", "youth"
        List<Team> availableTeams = globalController.cachedTeamsList
            .where((Team team) => team.type == selectedTeamTypeString)
            .toList();
        updateSelectedTeamAccordingToTeamType();
        return DropdownButton<Team>(
          value: globalController.selectedTeam.value,
          icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (Team? newTeam) {
            globalController.selectedTeam.value = availableTeams
                .where((Team teamItem) => teamItem.id == newTeam?.id)
                .first;
            globalController.refresh();
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
