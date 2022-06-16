import 'package:get/get.dart';
import '../controllers/globalController.dart';
import '../data/team.dart';
import '../constants/team_constants.dart';

void updateSelectedTeamAccordingToTeamType() {
  GlobalController globalController = Get.find<GlobalController>();
  int selectedTeamTypeInt = globalController.selectedTeamType.value;
  String selectedTeamTypeString = TEAM_TYPE_MAPPING[selectedTeamTypeInt];
  // available teams are all the ones that match the selected team type (0,1,2) => "men", "women", "youth"
  List<Team> availableTeams = globalController.cachedTeamsList
      .where((Team team) => team.type == selectedTeamTypeString)
      .toList();
  // if a team was already selected before and team type still matches return
  if (globalController.selectedTeam.value.type ==
      TEAM_TYPE_MAPPING[globalController.selectedTeamType.value]) {
    return;
  }
  // if team type of previously selected team doesnt match update selected team with the first team that matches types
  if (availableTeams.length > 0) {
    globalController.selectedTeam.value = availableTeams[0];
    globalController.selectedTeam.refresh();
    return;
  }
  // if no teams are available for the team type just take the firs team in teams collection
  globalController.selectedTeam.value = globalController.cachedTeamsList[0];
  globalController.selectedTeam.refresh();
  return;
}
