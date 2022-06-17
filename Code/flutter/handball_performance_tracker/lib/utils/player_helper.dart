import 'package:get/get.dart';

import '../controllers/gameController.dart';

// Function to get list of indices where the list playersOnField is true.
// Those are the indices of players on field in chosenPlayers.
List<int> getOnFieldIndex() {
  GameController gameController = Get.find<GameController>();
  List<int> ind = [];
  for (int i = 0; i < gameController.getSelectedTeam().players.length; i++) {
    if (gameController.getSelectedTeam().onFieldPlayers
        .contains(gameController.getSelectedTeam().players[i])) {
      ind.add(i);
    }
  }
  return ind;
}

// Function to get list of indices where the list playersOnField is false.
// Those are the indices of players not on field in chosenPlayers.
List<int> getNotOnFieldIndex() {
  GameController gameController = Get.find<GameController>();
  List<int> ind = [];
  for (int i = 0; i < gameController.getSelectedTeam().players.length; i++) {
    if (gameController.getSelectedTeam().onFieldPlayers
            .contains(gameController.getSelectedTeam().players[i]) ==
        false) {
      ind.add(i);
    }
  }
  return ind;
}
