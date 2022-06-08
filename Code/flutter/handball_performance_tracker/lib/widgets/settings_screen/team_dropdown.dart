import 'package:flutter/material.dart';
import '../../data/database_repository.dart';
import '../../data/player.dart';
import '../../controllers/globalController.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/team.dart';

// dropdown that shows all available teams
class TeamDropdown extends GetView<GlobalController> {
  GlobalController globalController = Get.find<GlobalController>();

  // TODO:
  // * list all the teams
  // when team is selected updated global state

  @override
  Widget build(BuildContext context) {
    DatabaseRepository repository = DatabaseRepository();

    List<Team> availableTeams = globalController.cachedTeamsList;
    // select a default team
    // TODO change this once it is selected by default in global controller
    print(globalController.selectedTeam.value.name);
    if (globalController.selectedTeam.value.name == "Default team") {
      globalController.selectedTeam.value = globalController.cachedTeamsList[0];
    }
    return // build the dropdown button
        DropdownButton<String>(
      value: globalController.selectedTeam.value.id,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        globalController.selectedTeam.value =
            availableTeams.firstWhere((element) => element.id == newValue);
      },
      // build dropdown item widgets
      items: availableTeams.map<DropdownMenuItem<String>>((Team team) {
        return DropdownMenuItem<String>(
          value: team.id,
          child: Text(team.name),
        );
      }).toList(),
    );
  }
}
