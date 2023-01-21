import 'package:handball_performance_tracker/data/models/models.dart';

// /// Function to get list of indices where the list playersOnField is true.
// /// Those are the indices of onFieldPlayer within the list of all players.
// List<int> getOnFieldIndex() {
//   TempController tempController = Get.find<TempController>();
//   List<int> ind = [];
//   for (int i = 0; i < tempController.getSelectedTeam().players.length; i++) {
//     if (tempController
//         .getOnFieldPlayers()
//         .contains(tempController.getSelectedTeam().players[i])) {
//       ind.add(i);
//     }
//   }
//   return ind;
// }

/// Function to get list of indices where the list playersOnField is false.
/// Those are the indices of players not on field in chosenPlayers.
List<int> getNotOnFieldIndex(Team selectedTeam, List<Player> onFieldPlayers) {
  List<int> ind = [];
  for (int i = 0; i < selectedTeam.players.length; i++) {
    if (onFieldPlayers.contains(selectedTeam.players[i]) == false) {
      ind.add(i);
    }
  }
  return ind;
}
