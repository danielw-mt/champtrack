import '../data/game_action.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import '../data/ef_score.dart';

class StatisticsEngine {
  var logger = Logger(
    printer: PrettyPrinter(
        methodCount: 2, // number of method calls to be displayed
        errorMethodCount: 8, // number of method calls if stacktrace is provided
        lineLength: 120, // width of the output
        colors: true, // Colorful log messages
        printEmojis: true, // Print an emoji for each log message
        printTime: true // Should each log print contain a timestamp
        ),
  );

  Map<String, dynamic> _statistics = {};
  bool _statistics_ready = false;

  generateStatistics(List<Map<String, dynamic>> gameDocuments) {
    logger.d("generate game statistics");
    gameDocuments.forEach((Map<String, dynamic> gameDocument) {
      List<Map<String, dynamic>> actions = gameDocument["actions"];
      _statistics[gameDocument["id"]] = {"player_stats": generatePlayerStatistics(actions)};
    });
    _statistics_ready = true;
    logger.d(_statistics);
  }

  Map<String, dynamic> generatePlayerStatistics(actions) {
    Map<String, dynamic> player_stats = {};
    Map<String, int> updatePlayerActionCounts(Map<String, dynamic> action, Map<String, int> action_counts) {
      logger.d("update action counts");
      String actionType = action["actionType"];
      if (!action_counts.containsKey(actionType)) {
        action_counts[actionType] = 1;
      } else {
        action_counts[actionType] = action_counts[actionType]! + 1;
      }
      return action_counts;
    }

    Map<String, List<int>> updatePlayerActionSeries(Map<String, dynamic> action, Map<String, List<int>> action_series) {
      logger.d("update action series");
      String actionType = action["actionType"];
      if (!action_series.containsKey(actionType)) {
        action_series[actionType] = [action["timestamp"]];
      } else {
        action_series[actionType]?.add(action["timestamp"]);
      }
      return action_series;
    }
    
    /// update the action_coordinates map with the throwLocation item of the 
    updateActionCoordinates(Map<String, dynamic> action, Map<String, dynamic> action_coordinates) {
      // if there is no throw location object inside the action
      if (action["throwLocation"] == null) return action_coordinates;
      String actionType = action["actionType"];
      if (!action_coordinates.containsKey(actionType)) {
        action_coordinates[actionType] = [action["throwLocation"]];
      } else {
        action_coordinates[actionType].add(action["throwLocation"]);
      }
      return action_coordinates;
    }

    updateAllEfScores(){
      // TODO simulate the live ef-score using the actions stored in the map already
      player_stats.forEach((playerId, playerStatistic) { 
        LiveEfScore playerEfScore = LiveEfScore();
      });
    }

    actions.forEach((Map<String, dynamic> action) {
      String playerId = action["playerId"];
      // only if a playerId is set the action can be associated
      if (playerId != "") {
        // if there is no player with that id in the player_stats map, create a map for that player
        if (!player_stats.containsKey(playerId)) {
          logger.d("creating player $playerId");
          player_stats[playerId] = {
            "action_counts": Map<String, int>(),
            "action_series": Map<String, List<int>>(),
            "action_coordinates": Map<String, dynamic>(),
            "all_action_timestamps": <int>[],
            "ef_score_series": <int>[]
          };
        }
        Map<String, dynamic> player_statistic = player_stats[playerId];
        Map<String, int> action_counts = player_statistic["action_counts"];
        Map<String, List<int>> action_series = player_statistic["action_series"];
        Map<String, dynamic> action_coordinates = player_statistic["action_coordinates"];
        List<int> all_action_timestamps = player_statistic["all_action_timestamps"];
        // update all maps
        action_counts = updatePlayerActionCounts(action, action_counts);
        action_series = updatePlayerActionSeries(action, action_series);
        action_coordinates = updateActionCoordinates(action, action_coordinates);
        logger.d("adding a new action timestamp");
        all_action_timestamps.add(action["timestamp"]);
        // TODO calculate updated ef-score

        // pass the maps to the player_statistic map
        player_statistic["action_counts"] = action_counts;
        player_statistic["action_series"] = action_series;
        player_statistic["action_coordinates"] = action_coordinates;
        player_statistic["all_action_timestamps"] = all_action_timestamps;

        // update the player_stats map with the new action that was added
        player_stats[playerId] = player_statistic;
      }
    });
    return player_stats;
  }

  Map<String, dynamic> getStatistics() {
    if (_statistics_ready) {
      return _statistics;
    } else {
      return {};
    }
  }
}
