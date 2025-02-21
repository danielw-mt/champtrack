import 'package:handball_performance_tracker/core/core.dart';
import 'package:handball_performance_tracker/core/constants/game_actions.dart';
import 'package:handball_performance_tracker/data/ef_score.dart';
import 'package:handball_performance_tracker/data/models/models.dart';
import 'dart:collection';

/// Generate entire statistics map from
///
/// @param gameDocuments: a map for the club for all games that are stored in the games collection
///
/// @param players: a list of all players that correspond to the logged in club
Map<String, dynamic> generateStatistics(
    List<Game> games, List<Player> players) {
  Map<String, dynamic> _statistics = {};
  //developer.log("generate game statistics");
  // print length of games
  print("games length");
  print(games.length);
  games.forEach((Game game) {
    // quality check that game document contains all the fields it needs and also actions
    // otherwise don't deal with this game
    // print game object
    // print("game chck");
    // print(game);
    if (game.teamId != null &&
        game.startTime != null &&
        !game.gameActions.isEmpty &&
        game.id != null &&
        game.stopWatchTimer != null) {
      // print("game is valid");
      // print(_statistics);
      List<GameAction> actions = game.gameActions;
      // generate statistics for each player
      Map<String, dynamic> playerStats =
          _generatePlayerStatistics(actions, players);
      Map<String, dynamic> teamStats = _generateTeamStatistics(playerStats);
      String teamID = game.teamId!;

      // timestamp like 1664014756081
      int stopTimeAsIsoTimeStamp;
      // if the game was stopped correctly we will have a stopTime field
      if (game.stopTime != null) {
        // generate stop time
        DateTime stopWatchTimeAsDateTime = DateTime.fromMillisecondsSinceEpoch(
            (DateTime.fromMillisecondsSinceEpoch(0).millisecond +
                    game.stopWatchTimer!.rawTime.value)
                .toInt());
        stopTimeAsIsoTimeStamp = stopWatchTimeAsDateTime.millisecondsSinceEpoch;
        // if the game crashed or was not stopped correctly we will not have a stoptime and have to infere this
        // do so by just adding 60 minutes to the start time
        // TODO maybe change this method in the future to use timestamps
      } else {
        stopTimeAsIsoTimeStamp =
            DateTime.fromMillisecondsSinceEpoch(game.startTime!)
                .add(Duration(minutes: 60))
                .millisecondsSinceEpoch;
      }

      _statistics[game.id!] = {
        "start_time": game.startTime,
        "stop_time": stopTimeAsIsoTimeStamp,
        "player_stats": playerStats,
        "team_stats": {teamID: teamStats}
      };
      //
    }
  });
  // print done with generate statistics
  print("done with generate statistics");
  return _statistics;
}

/// create the map that contains all statistics for an individual player from all the actions in the game
Map<String, dynamic> _generatePlayerStatistics(
    List<GameAction> actions, List<Player> players) {
  //developer.log("generating player statistics");
  // map with statistics for all player by id of the player
  Map<String, dynamic> player_stats = {};

  /// @return updated @param actions_counts from @param action
  ///
  /// called for every action
  Map<String, int> updateActionCounts(
      GameAction action, Map<String, int> action_counts) {
    //developer.log("update action counts");
    String actionTag = action.tag;
    if (!action_counts.containsKey(actionTag)) {
      action_counts[actionTag] = 1;
    } else {
      action_counts[actionTag] = action_counts[actionTag]! + 1;
    }
    return action_counts;
  }

  /// @return updated @param action_series from @param action
  ///
  /// Called for every action.
  Map<String, List<int>> updateActionSeries(
      GameAction action, Map<String, List<int>> action_series) {
    //developer.log("action series");
    String actionTag = action.tag;
    if (!action_series.containsKey(actionTag)) {
      action_series[actionTag] = [action.timestamp];
    } else {
      action_series[actionTag]?.add(action.timestamp);
    }
    return action_series;
  }

  /// @return updated @param action_coordinates from @param action
  ///
  /// Called for every action
  Map<String, dynamic> updateActionCoordinates(
      GameAction action, Map<String, dynamic> action_coordinates) {
    //developer.log("update action coordinates");
    // if there is no throw location object inside the action
    if (action.throwLocation == null) return action_coordinates;
    String actionTag = action.tag;
    if (!action_coordinates.containsKey(actionTag)) {
      action_coordinates[actionTag] = [action.throwLocation];
    } else {
      action_coordinates[actionTag].add(action.throwLocation);
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
  /// quotas[3][0]: parades
  /// quotas[3][1]: total throws on own goal
  List<List<double>> updateQuotas(
      GameAction action, List<List<double>> quotas) {
    switch (action.tag) {
      // TODO calculate position quota by infering whether action position matches player position
      case missed7mTag:
        {
          // incrase 7m shots
          quotas[0][1] = quotas[0][1] + 1;
          return quotas;
        }
      case goal7mTag:
        {
          // incrase 7m shots
          quotas[0][1] = quotas[0][1] + 1;
          // increase 7m goals
          quotas[0][0] = quotas[0][0] + 1;
          return quotas;
        }
      case goalTag:
        {
          // increase total shots
          quotas[2][1] = quotas[2][1] + 1;
          // increase total goals
          quotas[2][0] = quotas[2][0] + 1;
          return quotas;
        }
      case goalPosTag:
        {
          // increase total shots
          quotas[2][1] = quotas[2][1] + 1;
          // increase total goals
          quotas[2][0] = quotas[2][0] + 1;
          // increase position shots
          quotas[1][1] = quotas[1][1] + 1;
          return quotas;
        }
      case goalGoalKeeperTag:
        {
          // increase total shots
          quotas[2][1] = quotas[2][1] + 1;
          // increase total goals
          quotas[2][0] = quotas[2][0] + 1;
          // increase position shots
          quotas[1][1] = quotas[1][1] + 1;
          return quotas;
        }
      case missTag:
        {
          // increase total shots
          quotas[2][1] = quotas[2][1] + 1;
          return quotas;
        }
      case missPosTag:
        {
          // increase total shots
          quotas[2][1] = quotas[2][1] + 1;
          // increase position shots
          quotas[1][1] = quotas[1][1] + 1;
          return quotas;
        }
      case paradeTag:
        {
          // increase parades
          quotas[3][0] = quotas[3][0] + 1;
          // increase total throws on own goal
          quotas[3][1] = quotas[3][1] + 1;
          return quotas;
        }
      case goalOpponentTag:
        {
          // increase total throws on own goal
          quotas[3][1] = quotas[3][1] + 1;
          return quotas;
        }
      case parade7mTag:
        {
          // increase parades
          quotas[3][0] = quotas[3][0] + 1;
          // increase total throws on own goal
          quotas[3][1] = quotas[3][1] + 1;
          return quotas;
        }
      case goalOpponent7mTag:
        {
          // increase total throws on own goal
          quotas[3][1] = quotas[3][1] + 1;
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

  /// go over all actions and update the player statistics map using the sub-methods above within generatePlayerStatistics()
  actions.forEach((GameAction action) {
    //developer.log(action.toString());
    String playerId = action.playerId;
    // only if a playerId is set the action can be associated. Sometimes the action is not associated with a player
    if (playerId != "") {
      // if there is no player with that id in the player_stats map, create a map for that player
      if (!player_stats.containsKey(playerId)) {
        player_stats[playerId] = {
          "seven_meter_quota": <double>[0, 0],
          "position_quota": <double>[0, 0],
          "throw_quota": <double>[0, 0],
          "parade_quota": <double>[0, 0],
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
          updateActionCounts(action, player_statistic["action_counts"]);
      player_statistic["action_series"] =
          updateActionSeries(action, player_statistic["action_series"]);
      player_statistic["action_coordinates"] = updateActionCoordinates(
          action, player_statistic["action_coordinates"]);
      player_statistic["all_actions"].add(action.tag);
      player_statistic["all_action_timestamps"].add(action.timestamp);
      List quotas = updateQuotas(action, [
        player_statistic["seven_meter_quota"],
        player_statistic["position_quota"],
        player_statistic["throw_quota"],
        player_statistic["parade_quota"]
      ]);
      player_statistic["seven_meter_quota"] = quotas[0];
      player_statistic["position_quota"] = quotas[1];
      player_statistic["throw_quota"] = quotas[2];
      player_statistic["parade_quota"] = quotas[3];
      // update the player_stats map with the new action that was added
      player_stats[playerId] = player_statistic;
    }
  });
  // after all the actions where processed, create the ef-score series for each individual player
  player_stats.forEach((String playerId, playerStatistic) {
    // TODO maybe incorporate timestamps later when the ef-score has a time component
    LiveEfScore playerEfScore = LiveEfScore();
    List<String> allActions = playerStatistic["all_actions"];
    allActions.forEach((String actionTag) {
      // for some of our action tags the ef-score does not know what to do. So just keep the ef-score the same for those
      try {
        playerEfScore.addAction(GameAction(tag: actionTag),
            players.where((player) => player.id == playerId).first.positions);
      } catch (e) {
        // developer.log(
        //     "ef-score does not know what to do with action $actionTag" +
        //         "\n" +
        //         e.toString());
      }
      playerStatistic["ef_score_series"].add(playerEfScore.score);
    });
    player_stats[playerId] = playerStatistic;
  });

  return player_stats;
}

/// updates _statistics element with team statistics data using game data
Map<String, dynamic> _generateTeamStatistics(Map<String, dynamic> playerStats) {
  //developer.log("generating team statistics");
  // team stats for the current team (only one team per game is implicit assumption)
  Map<String, dynamic> teamStats = {
    "seven_meter_quota": <double>[0, 0],
    "position_quota": <double>[0, 0],
    "throw_quota": <double>[0, 0],
    "parade_quota": <double>[0, 0],
    "action_counts": Map<String, int>(),
    "action_series": Map<String, List<int>>(),
    "action_coordinates": Map<String, List<dynamic>>(),
    "all_actions": <String>[],
    "all_action_timestamps": <int>[],
    "ef_score_series": <double>[]
  };
  // update team stats from previous player stats
  playerStats.forEach((String playerID, dynamic playerStatistic) {
    // make sure that we have initialized values in the player statistic otherwise don't generate team statistic

    // TODO implement a quality check here whether player statistics were implemented correctly
    // if (playerStatistic["seven_meter_quota"] != <double>[0, 0] &&
    //     playerStatistic["position_quota"] != <double>[0, 0] &&
    //     playerStatistic["throw_quota"] != <double>[0, 0] &&
    //     playerStatistic["action_counts"] != Map<String, int>() &&
    //     playerStatistic["action_series"] != Map<String, List<int>>() &&
    //     playerStatistic["action_coordinates"] != Map<String, dynamic>() &&
    //     playerStatistic["all_actions"] != <String>[] &&
    //     playerStatistic["all_action_timestamps"] != <int>[] &&
    //     playerStatistic["ef_score_series"] != <double>[]) {}
    // update quotas by summing up numerators and denominators of every player
    teamStats["seven_meter_quota"][0] +=
        playerStatistic["seven_meter_quota"][0];
    teamStats["seven_meter_quota"][1] +=
        playerStatistic["seven_meter_quota"][1];
    teamStats["position_quota"][0] += playerStatistic["position_quota"][0];
    teamStats["position_quota"][1] += playerStatistic["position_quota"][1];
    teamStats["throw_quota"][0] += playerStatistic["throw_quota"][0];
    teamStats["throw_quota"][1] += playerStatistic["throw_quota"][1];
    teamStats["parade_quota"][0] += playerStatistic["parade_quota"][0];
    teamStats["parade_quota"][1] += playerStatistic["parade_quota"][1];
    // update action counts by summing up all action counts of every player
    playerStatistic["action_counts"].forEach((String actionTag, int count) {
      if (teamStats["action_counts"].containsKey(actionTag)) {
        teamStats["action_counts"][actionTag] += count;
      } else {
        teamStats["action_counts"][actionTag] = count;
      }
    });
    // add each player's action series timestamp to the team's action series timestamp and sort them afterwards
    playerStatistic["action_series"]
        .forEach((String actionTag, List<int> timestamps) {
      if (teamStats["action_series"].containsKey(actionTag)) {
        teamStats["action_series"][actionTag].addAll(timestamps);
      } else {
        teamStats["action_series"][actionTag] = timestamps;
      }
      teamStats["action_series"][actionTag].sort();
    });
    // add each player's action coordinates to the team's action coordinates do not sort these
    playerStatistic["action_coordinates"]
        .forEach((String actionTag, dynamic coordinates) {
      if (teamStats["action_coordinates"].containsKey(actionTag)) {
        teamStats["action_coordinates"][actionTag].addAll(coordinates);
      } else {
        teamStats["action_coordinates"][actionTag] = coordinates;
      }
    });
    List<String> allActions = playerStatistic["all_actions"];
    List<int> allActionTimestamps = playerStatistic["all_action_timestamps"];
    allActions.forEach((String actionTag) {
      teamStats["all_actions"].add(actionTag);
    });
    allActionTimestamps.forEach((int timestamp) {
      teamStats["all_action_timestamps"].add(timestamp);
    });

    // TODO calculate the ef-score series for the team by building the average through all players through time
    // go through every player and update the ef-score by adding to the global ef score average at the time when a new action is added
    // ef score depends on the player position which is why we need to do this
  });
  // sort all_actions and all_action_timestamps chronologically. Keys are timestamp and values are actions

  Map<int, String> allActionsUnsorted = Map<int, String>();
  teamStats["all_action_timestamps"].forEach((int timestamp) {
    allActionsUnsorted[timestamp] = teamStats["all_actions"]
        [teamStats["all_action_timestamps"].indexOf(timestamp)];
  });
  Map<int, String> sortedByTimeStampMap = new SplayTreeMap<int, String>.from(
      allActionsUnsorted, (k1, k2) => k1.compareTo(k2));

  teamStats["all_actions"] = sortedByTimeStampMap.values.toList();
  teamStats["all_action_timestamps"] = sortedByTimeStampMap.keys.toList();
  return teamStats;
}
