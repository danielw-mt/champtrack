import 'package:flutter/material.dart';
import '../../controllers/persistentController.dart';
import '../../controllers/tempController.dart';
import 'package:get/get.dart';
import '../../data/team.dart';
import '../../utils/team_type_helpers.dart';
import '../../constants/team_constants.dart';

// dropdown that shows all available teams belonging to the selected team type
class TeamDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PersistentController persistentController =
        Get.find<PersistentController>();
    return // build the dropdown button
        GetBuilder<TempController>(
      id: "team-dropdown",
      builder: (TempController tempController) {
        // available teams are all the ones that match the selected team type (0,1,2) => "men", "women", "youth"

        // start TODO: keep this for # 174
        // int selectedTeamTypeInt = globalController.selectedTeamType.value;
        // String selectedTeamTypeString = TEAM_TYPE_MAPPING[selectedTeamTypeInt];
        // List<Team> availableTeams = globalController.cachedTeamsList
        //     .where((Team team) => team.type == selectedTeamTypeString)
        //     .toList();
        // updateSelectedTeamAccordingToTeamType();
        // end TODO
        return DropdownButton<Team>(
            value: tempController.getSelectedTeam(),
            icon: const Icon(Icons.arrow_downward),
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (Team? newTeam) {
              tempController.setSelectedTeam(persistentController
                  .getAvailableTeams()
                  .where((Team teamItem) => teamItem.id == newTeam?.id)
                  .first);
              tempController.setPlayingTeam(persistentController
                  .getAvailableTeams()
                  .where((Team teamItem) => teamItem.id == newTeam?.id)
                  .first);
            },
            // build dropdown item widgets
            items: persistentController.getAvailableTeams().map((Team team) {
              return DropdownMenuItem<Team>(
                  value: team, child: Text(team.name));
            }).toList());
      },
    );
  }
}
