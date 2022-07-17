import 'package:handball_performance_tracker/constants/game_actions.dart';
import 'package:handball_performance_tracker/constants/positions.dart';
import 'package:handball_performance_tracker/data/game_action.dart';
import 'package:logger/logger.dart';

var logger = Logger(
  printer: PrettyPrinter(
      methodCount: 2, // number of method calls to be displayed
      errorMethodCount: 8, // number of method calls if stacktrace is provided
      lineLength: 120, // width of the output
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
      printTime: false // Should each log print contain a timestamp
      ),
);

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
    if (numOfActions > 0) {
      score = (positiveScore - negativeScore) / numOfActions;
    } else {
      score = 0;
    }
  }

  /// determine the correct string identifier from `efScoreParameters` for @param action
  /// distinguished between different throw positions and the player's specified @param position for goals and error throws
  String? _getActionType(GameAction action, List<String> positions) {
    String? actionType = action.actionType;
    if (actionType == goal) {
      // don't consider position and distance if goal happened after minute 55
      if (action.relativeTime > lastFiveMinThreshold) {
        actionType = goalLastFive;
      } else if (_isPosition(positions, action.throwLocation)) {
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
      } else if (_isPosition(positions, action.throwLocation)) {
        actionType = errThrowPos;
      } else if (_isInNineMeters(action.throwLocation[1])) {
        actionType = errThrowUnderNine;
      } else {
        actionType = errThrowOutsideNine;
      }
    } else if (actionType == goal7m){ 
      // 7m goal is weighted identically to goal under nine
      actionType = goalUnderNine;
    } else if (actionType == missed7m){
      // 7m error throw is weighted identically to errow throw under nine
      actionType = goalUnderNine;
    } else if (!actionStats.containsKey(actionType)) {
      actionType = null;
    }
    return actionType;
  }

  /// @return true if the throw sector @param sector belongs to one of the player's specialized @param positions (according to #60)
  bool _isPosition(List<String> positions, List<String> sector) {
    // player has one of the positions leftOutside, backcourtLeft, backcourtMiddle, backcourtRight, rightOutside and action was performed there
    if (positions.contains(sector[0])) {
      return true;
    }
    // player has circle position and action was performed in 9m circle
    if (positions.contains(circle) && _isInNineMeters(sector[1])) {
      // action was performed in backcourt area
      if ((sector[0] == backcourtLeft) ||
          (sector[0] == backcourtMiddle) ||
          (sector[0] == backcourtRight)) {
        return true;
      }
    }
    return false;
  }

  /// @return true if the action happened within the 9-m-circle
  bool _isInNineMeters(String distance) => distance != outsideNine;
}

class LiveEfScore extends EfScore {
  void addAction(GameAction action, List<String> playerPositions) {
    String? actionType = _getActionType(action, playerPositions);
    if (actionType != null) {
      actionStats[actionType] = actionStats[actionType]! + 1;
      numOfActions++;
      logger.d("Action added: $actionType, old ef-score: $score");
      calculate();
      logger.d("New ef-score: $score");
    } else {
      logger.i("Action type $actionType is unknown. Action ignored.");
    }
  }

  void removeAction(GameAction action, List<String> playerPositions) {
    String? actionType = _getActionType(action, playerPositions);
    if (actionType != null) {
      if (actionStats[actionType]! >= 1) {
        actionStats[actionType] = actionStats[actionType]! - 1;
        numOfActions--;
        logger.d("Action deleted: $actionType, old ef-score: $score");
        calculate();
        logger.d("New ef-score: $score");
      }
    } else {
      logger.i("Action type $actionType is unknown. No delete performed.");
    }
  }
}
