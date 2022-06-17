import 'package:handball_performance_tracker/controllers/globalController.dart';
import 'package:get/get.dart';

// Function to get list of indices where the list playersOnField is true.
// Those are the indices of players on field in chosenPlayers.
List<int> getOnFieldIndex() {
  final GlobalController globalController = Get.find<GlobalController>();
  List<int> ind = [];
  for (int i = 0; i < globalController.selectedTeam.value.players.length; i++) {
    if (globalController.selectedTeam.value.onFieldPlayers
        .contains(globalController.selectedTeam.value.players[i])) {
      ind.add(i);
    }
  }
  return ind;
}

// Function to get list of indices where the list playersOnField is false.
// Those are the indices of players not on field in chosenPlayers.
List<int> getNotOnFieldIndex() {
  final GlobalController globalController = Get.find<GlobalController>();
  List<int> ind = [];
  for (int i = 0; i < globalController.selectedTeam.value.players.length; i++) {
    if (globalController.selectedTeam.value.onFieldPlayers
            .contains(globalController.selectedTeam.value.players[i]) ==
        false) {
      ind.add(i);
    }
  }
  return ind;
}
