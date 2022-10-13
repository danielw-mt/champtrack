import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/stringsGeneral.dart';
import '../../controllers/persistent_controller.dart';
import '../../controllers/temp_controller.dart';
import 'package:get/get.dart';
import '../../data/team.dart';

// dropdown that shows all available teams belonging to the selected team type
class TeamDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PersistentController persistentController =
        Get.find<PersistentController>();
    // don't show the dropdown if there are no available teams
    if (persistentController.getAvailableTeams().length == 0) {
      return Container();
    }
    return // build the dropdown button
        GetBuilder<TempController>(
      id: "team-dropdown",
      builder: (TempController tempController) {
        // print("selected team: "+tempController.getSelectedTeam().name);
        print("available teams: "+persistentController.getAvailableTeams().length.toString());
        // available teams are all the ones that match the selected team type (0,1,2) => "men", "women", "youth"
        return Container(
          width: MediaQuery.of(context).size.width *0.25,
          child: DropdownButtonFormField<Team>(
              value: tempController.getSelectedTeam(),
              icon: const Icon(Icons.arrow_drop_down_circle_outlined),
              iconEnabledColor: Colors.black,
              elevation: 16,
              style: TextStyle(
                  fontSize: 18, color: Colors.black),
              dropdownColor: Colors.white,
              decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: buttonDarkBlueColor)),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: buttonDarkBlueColor)),
                  disabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: buttonDarkBlueColor)),
                  labelText: StringsGeneral.lTeam,
                  labelStyle: TextStyle(color: buttonDarkBlueColor),
                  filled: true,
                  fillColor: Colors.white),
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
              }).toList()),
        );
      },
    );
  }
}
