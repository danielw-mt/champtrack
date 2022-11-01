import 'package:get/get.dart';
import 'package:handball_performance_tracker/controllers/persistent_controller.dart';
import '../controllers/temp_controller.dart';
import '../data/models/team_model.dart';
import '../old-constants/team_constants.dart';

void updateSelectedTeamAccordingToTeamType() {
  TempController tempController = Get.find<TempController>();
  PersistentController persistentController = Get.find<PersistentController>();
  int selectedTeamTypeInt = tempController.getSelectedTeamType();
  String selectedTeamTypeString = TEAM_TYPE_MAPPING[selectedTeamTypeInt];
  // available teams are all the ones that match the selected team type (0,1,2) => "men", "women", "youth"
  List<Team> availableTeams = persistentController
      .getAvailableTeams()
      .where((Team team) => team.type == selectedTeamTypeString)
      .toList();
  // if a team was already selected before and team type still matches return
  if (tempController.getSelectedTeam().type ==
      TEAM_TYPE_MAPPING[tempController.getSelectedTeamType()]) {
    return;
  }
  // if team type of previously selected team doesnt match update selected team with the first team that matches types
  if (availableTeams.length > 0) {
    tempController.setSelectedTeam(availableTeams[0]);
    tempController.setPlayingTeam(availableTeams[0]);

    return;
  }
  // if no teams are available for the team type just take the first team in teams collection
  tempController.setSelectedTeam(persistentController.getAvailableTeams()[0]);
  tempController.setPlayingTeam(persistentController.getAvailableTeams()[0]);

  return;
}
