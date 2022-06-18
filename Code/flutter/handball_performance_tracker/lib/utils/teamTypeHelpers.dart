import 'package:get/get.dart';
import 'package:handball_performance_tracker/controllers/persistentController.dart';
import '../controllers/tempController.dart';
import '../data/team.dart';
import '../constants/team_constants.dart';

void updateSelectedTeamAccordingToTeamType() {
  TempController gameController = Get.find<TempController>();
  persistentController appController = Get.find<persistentController>();
  int selectedTeamTypeInt = gameController.getSelectedTeamType();
  String selectedTeamTypeString = TEAM_TYPE_MAPPING[selectedTeamTypeInt];
  // available teams are all the ones that match the selected team type (0,1,2) => "men", "women", "youth"
  List<Team> availableTeams = appController
      .getAvailableTeams()
      .where((Team team) => team.type == selectedTeamTypeString)
      .toList();
  // if a team was already selected before and team type still matches return
  if (gameController.getSelectedTeam().type ==
      TEAM_TYPE_MAPPING[gameController.getSelectedTeamType()]) {
    return;
  }
  // if team type of previously selected team doesnt match update selected team with the first team that matches types
  if (availableTeams.length > 0) {
    gameController.setSelectedTeam(availableTeams[0]);
    return;
  }
  // if no teams are available for the team type just take the first team in teams collection
  gameController.setSelectedTeam(appController.getAvailableTeams()[0]);
  return;
}
