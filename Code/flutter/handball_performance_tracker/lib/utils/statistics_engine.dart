import '../data/game_action.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import '../data/ef_score.dart';
import '../data/player.dart';

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

  /// Generate entire statistics map from
  ///
  /// @param gameDocuments: a map for the club for all games that are stored in the games collection
  ///
  /// @param players: a list of all players that correspond to the logged in club
  generateStatistics(
      List<Map<String, dynamic>> gameDocuments, List<Player> players) {
    logger.d("generate game statistics");
    gameDocuments.forEach((Map<String, dynamic> gameDocument) {
      DateTime stopWatchTimeAsDateTime = DateTime.fromMillisecondsSinceEpoch(
          (DateTime.fromMillisecondsSinceEpoch(0).millisecond +
                  gameDocument["stopWatchTime"])
              .toInt());
      // timestamp like 1664014756081
      int stopTimeAsIsoTimeStamp =
          stopWatchTimeAsDateTime.millisecondsSinceEpoch;
      List<Map<String, dynamic>> actions = gameDocument["actions"];
      Map<String, dynamic> playerStats =
          generatePlayerStatistics(actions, players);
      _statistics[gameDocument["id"]] = {
        "start_time": gameDocument["startTime"],
        "stop_time": stopTimeAsIsoTimeStamp,
        "player_stats": playerStats
      };
    });
    logger.d(_statistics);
    _statistics_ready = true;
  }

  /// create the map that contains all statistics for an individual player from all the actions in the game
  Map<String, dynamic> generatePlayerStatistics(actions, List<Player> players) {
    // map with statistics for all player by id of the player
    Map<String, dynamic> player_stats = {};

    /// update the action_counts entry for the current action
    Map<String, int> updatePlayerActionCounts(
        Map<String, dynamic> action, Map<String, int> action_counts) {
      String actionType = action["actionType"];
      if (!action_counts.containsKey(actionType)) {
        action_counts[actionType] = 1;
      } else {
        action_counts[actionType] = action_counts[actionType]! + 1;
      }
      return action_counts;
    }

    /// update the action_series entry for the current action
    Map<String, List<int>> updatePlayerActionSeries(
        Map<String, dynamic> action, Map<String, List<int>> action_series) {
      String actionType = action["actionType"];
      if (!action_series.containsKey(actionType)) {
        action_series[actionType] = [action["timestamp"]];
      } else {
        action_series[actionType]?.add(action["timestamp"]);
      }
      return action_series;
    }

    /// update the action_coordinates map with the throwLocation item of the
    updateActionCoordinates(
        Map<String, dynamic> action, Map<String, dynamic> action_coordinates) {
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

    /// @param quotes is [(List<double> <<seven_meter_quota>>, List<double> <<position_quota>>, List<double> <<throw_quota>>]
    /// the quotas are stored as a list of the two components for each quota ratio i.e. quotas[0][1, 2] for 1/2 7m quota
    /// quotas[0][0]: 7m goals
    /// quotas[0][1]: 7m shots
    /// quotas[1][0]: goals from position
    /// quotas[1][1]: shots from position
    /// quotas[2][0]: total goals
    /// quotas[2][1]: total shots
    List<List<double>> updateQuotas(
        Map<String, dynamic> action, List<List<double>> quotas) {
      switch (action["actionType"]) {
        // TODO use constants here instead of strings
        case "missed7m":
          {
            // incrase 7m shots
            quotas[0][1] = quotas[0][1] + 1;
            return quotas;
          }
        case "goal7m":
          {
            // incrase 7m shots
            quotas[0][1] = quotas[0][1] + 1;
            // increase 7m goals
            quotas[0][0] = quotas[0][0] + 1;
            return quotas;
          }
        case "goal":
          {
            // increase total shots
            quotas[2][1] = quotas[2][1] + 1;
            // increase total goals
            quotas[2][0] = quotas[2][0] + 1;
            return quotas;
          }
        case "goalPos":
          {
            // increase total shots
            quotas[2][1] = quotas[2][1] + 1;
            // increase total goals
            quotas[2][0] = quotas[2][0] + 1;
            // increase position shots
            quotas[1][1] = quotas[1][1] + 1;
            return quotas;
          }
        case "err":
          {
            // increase total shots
            quotas[2][1] = quotas[2][1] + 1;
            return quotas;
          }
        case "err_pos":
          {
            // increase total shots
            quotas[2][1] = quotas[2][1] + 1;
            // increase position shots
            quotas[1][1] = quotas[1][1] + 1;
            return quotas;
          }
        // TODO check if there are any other statuses missing that could increase total shots
        default:
          {
            // don't do anything
            return quotas;
          }
      }
    }

    updateAllEfScores() {
      // TODO simulate the live ef-score using the actions stored in the map already
      player_stats.forEach((playerId, playerStatistic) {
        LiveEfScore playerEfScore = LiveEfScore();
      });
    }

    /// go over all actions and update the player statistics map using the sub-methods above within generatePlayerStatistics()
    actions.forEach((Map<String, dynamic> action) {
      String playerId = action["playerId"];
      // only if a playerId is set the action can be associated. Sometimes the action is not associated with a player
      if (playerId != "") {
        // if there is no player with that id in the player_stats map, create a map for that player
        if (!player_stats.containsKey(playerId)) {
          logger.d("creating player $playerId");
          player_stats[playerId] = {
            "seven_meter_quota": <double>[0, 0],
            "position_quota": <double>[0, 0],
            "throw_quota": <double>[0, 0],
            "action_counts": Map<String, int>(),
            "action_series": Map<String, List<int>>(),
            "action_coordinates": Map<String, dynamic>(),
            "all_actions": <String>[],
            "all_action_timestamps": <int>[],
            "ef_score_series": <double>[]
          };
        }
        // get the reference to an individual player's statistics
        Map<String, dynamic> player_statistic = player_stats[playerId];
        // update all fields for an individual player's statistics
        player_statistic["action_counts"] =
            updatePlayerActionCounts(action, player_statistic["action_counts"]);
        player_statistic["action_series"] =
            updatePlayerActionSeries(action, player_statistic["action_series"]);
        player_statistic["action_coordinates"] = updateActionCoordinates(
            action, player_statistic["action_coordinates"]);
        player_statistic["all_actions"].add(action["actionType"]);
        player_statistic["all_action_timestamps"].add(action["timestamp"]);
        List quotas = updateQuotas(action, [
          player_statistic["seven_meter_quota"],
          player_statistic["position_quota"],
          player_statistic["throw_quota"]
        ]);
        player_statistic["seven_meter_quota"] = quotas[0];
        player_statistic["position_quota"] = quotas[1];
        player_statistic["throw_quota"] = quotas[2];
        // update the player_stats map with the new action that was added
        player_stats[playerId] = player_statistic;
      }
    });
    // after all the actions where processed, create the ef-score series for each individual player
    player_stats.forEach((String playerId, playerStatistic) {
      logger.d(playerStatistic);
      // TODO maybe incorporate timestamps later when the ef-score has a time component
      LiveEfScore playerEfScore = LiveEfScore();
      List<String> allActions = playerStatistic["all_actions"];
      allActions.forEach((String actionType) {
        // for some of our action tags the ef-score does not know what to do. So just keep the ef-score the same for those
        try {
          playerEfScore.addAction(GameAction(actionType: actionType),
              players.where((player) => player.id == playerId).first.positions);
        } catch (e) {
          logger.d("ef-score does not know what to do with action $actionType" +
              "\n" +
              e.toString());
        }
        playerStatistic["ef_score_series"].add(playerEfScore.score);
        logger.d("got here");
      });
      logger.d("ef-score for player $playerId: ${playerEfScore.score}}");
      player_stats[playerId] = playerStatistic;
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
