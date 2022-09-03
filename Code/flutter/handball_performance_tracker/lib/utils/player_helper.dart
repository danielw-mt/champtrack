import 'package:get/get.dart';

import '../controllers/tempController.dart';

// Function to get list of indices where the list playersOnField is true.
// Those are the indices of players on field in chosenPlayers.
List<int> getOnFieldIndex() {
  TempController tempController = Get.find<TempController>();
  List<int> ind = [];
  print("getonfieldindex: " +
      tempController.getSelectedTeam().players.length.toString());
  for (int i = 0; i < tempController.getSelectedTeam().players.length; i++) {
    if (tempController
        .getOnFieldPlayers()
        .contains(tempController.getSelectedTeam().players[i])) {
      ind.add(i);
    }
  }
  return ind;
}

// Function to get list of indices where the list playersOnField is false.
// Those are the indices of players not on field in chosenPlayers.
List<int> getNotOnFieldIndex() {
  TempController tempController = Get.find<TempController>();
  List<int> ind = [];
  for (int i = 0; i < tempController.getSelectedTeam().players.length; i++) {
    if (tempController
            .getOnFieldPlayers()
            .contains(tempController.getSelectedTeam().players[i]) ==
        false) {
      ind.add(i);
    }
  }
  return ind;
}
