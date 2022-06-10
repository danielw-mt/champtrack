import 'package:flutter/material.dart';
import '../../data/database_repository.dart';
import '../../data/player.dart';
import '../../controllers/globalController.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/team.dart';

// dropdown that shows all available teams
class TeamDropdown extends GetView<GlobalController> {
  // TODO:
  // * list all the teams
  // when team is selected updated global state

  @override
  Widget build(BuildContext context) {
    DatabaseRepository repository = DatabaseRepository();

    // select a default team
    // TODO write a function to select the default team in globalController / utils

    return // build the dropdown button
        GetBuilder(
      builder: (GlobalController globalController) {
        if (globalController.selectedTeam.value.name == "Default team") {
          globalController.selectedTeam.value =
              globalController.cachedTeamsList[0];
        }
        List<Team> availableTeams = globalController.cachedTeamsList;
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
