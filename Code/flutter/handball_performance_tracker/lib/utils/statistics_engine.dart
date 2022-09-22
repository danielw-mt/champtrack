import '../data/game_action.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StatisticsEngine {
  List<Map<String, dynamic>> _gamesData = [];
  List<Map<String, int>> _actionCounts = [];
  generateStatistics(List<Map<String, dynamic>> gamesDocumentSnapshots) {
    _gamesData = gamesDocumentSnapshots;
    _gamesData.forEach((Map<String, dynamic> gamesData) {
      List<Map<String, dynamic>> actions = gamesData["actions"];
      updateActionCountFromActions(actions);
    });
    print(_actionCounts[0]);
  }

  updateActionCountFromActions(List<Map<String, dynamic>> actions) {
    Map<String, int> actionCount = {};
    actions.forEach((Map<String, dynamic> action) {
      String actionType = action["actionType"];
      if (actionCount.containsKey(actionType)) {
        actionCount[actionType] = actionCount[actionType]! + 1;
      } else {
        actionCount[actionType] = 1;
      }
    });
    _actionCounts.add(actionCount);
  }

  List<Map<String, int>> getActionCounts() {
    return _actionCounts;
  }
}
