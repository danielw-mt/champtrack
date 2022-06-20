import 'package:flutter/material.dart';
import '../../controllers/persistentController.dart';
import '../../controllers/tempController.dart';
import 'package:get/get.dart';
import '../../data/team.dart';
import '../../utils/team_type_helpers.dart';
import '../../constants/team_constants.dart';

// dropdown that shows all available teams belonging to the selected team type
class TeamDropdown extends GetView<TempController> {
  final PersistentController persistentController =
      Get.find<PersistentController>();

  @override
  Widget build(BuildContext context) {
    return // build the dropdown button
        GetBuilder<TempController>(
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
              Obx(() {
                tempController.setSelectedTeam(persistentController
                    .getAvailableTeams()
                    .where((Team teamItem) => teamItem.id == newTeam?.id)
                    .first);
                return Container();
              });
            },
            // build dropdown item widgets
            items: buildDropDownItems());
      },
    );
  }

  List<DropdownMenuItem<Team>> buildDropDownItems() {
    List<DropdownMenuItem<Team>> items = [];
    Obx(() {
      persistentController.getAvailableTeams().forEach((Team team) {
        items.add(DropdownMenuItem<Team>(
          value: team,
          child: Text(team.name),
        ));
      });
      return Container();
    });
    return items;
  }
}
