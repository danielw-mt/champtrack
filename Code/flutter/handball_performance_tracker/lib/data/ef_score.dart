import 'package:handball_performance_tracker/constants/game_actions.dart';
import 'package:handball_performance_tracker/constants/positions.dart';
import 'package:handball_performance_tracker/data/game_action.dart';

class EfScore {
  double score;
  Map<String, int> actionStats;
  double numOfActions;

  EfScore()
      : score = 0,
        actionStats = {
          for (var v in efScoreParameters.values.expand((e) => e.keys)) v: 0
        },
        numOfActions = 0;

  /// calculates the ef-score using the weights specified in game_actions.dart, updates property `score`
  void calculate() {
    double positiveScore = 0;
    double negativeScore = 0;
    efScoreParameters[positiveAction]!.forEach((key, value) {
      positiveScore += value * actionStats[key]!;
    });
    efScoreParameters[negativeAction]!.forEach((key, value) {
      negativeScore += value * actionStats[key]!;
    });
    score = (positiveScore - negativeScore) / numOfActions;
  }

  /// determine the correct string identifier from `efScoreParameters` for @param action
  /// distinguished between different throw positions and the player's specified @param position for goals and error throws
  String? _getActionType(GameAction action, List<String> positions) {
    String? actionType = action.actionType;
    if (actionType == goal) {
        // don't consider position and distance if goal happened after minute 55
      if (action.relativeTime > lastFiveMinThreshold) {
        actionType = goalLastFive;
      } else if (_isPosition(positions, action.throwLocation[0])) {
        actionType = goalPos;
      } else if (_isInNineMeters(action.throwLocation[1])) {
        actionType = goalUnderNine;
      } else {
        actionType = goalOutsideNine;
      }
    } else if (actionType == errThrow) {
      if (action.relativeTime > lastFiveMinThreshold) {
        // don't consider position and distance if err happened after minute 55
        actionType = errThrowLastFive;
      } else if (_isPosition(positions, action.throwLocation[0])) {
        actionType = errThrowPos;
      } else if (_isInNineMeters(action.throwLocation[1])) {
        actionType = errThrowUnderNine;
      } else {
        actionType = errThrowOutsideNine;
      }
    } else if (!actionStats.containsKey(actionType)) {
      actionType = null;
    }
    return actionType;
  }

  /// @return true if the throw sector @param sector belongs to one of the player's specialized @param positions
  bool _isPosition(List<String> positions, String sector) =>
      // TODO adapt for proper positions instead of sectors
      positions.contains(sector);

  /// @return true if the action happened within the 9-m-circle
  bool _isInNineMeters(String distance) => distance != outsideNine;
}

class LiveEfScore extends EfScore {
  void addAction(GameAction action, List<String> playerPositions) {
    String? actionType = _getActionType(action, playerPositions);
    if (actionType != null) {
      actionStats[actionType] = actionStats[actionType]! + 1;
      print("action added: $actionType");
      numOfActions++;
      calculate();
      print("new ef-score: $score");
    } else {
      print("Action type $actionType is unknown. Action ignored.");
    }
  }

  void revertAction(GameAction action, List<String> playerPositions) {
    String? actionType = _getActionType(action, playerPositions);
    if (actionType != null) {
      if (actionStats[actionType]! >= 1) {
        actionStats[actionType] = actionStats[actionType]! - 1;
      }
    } else {
      print("Action type $actionType is unknown. No revert performed.");
    }
  }
}
