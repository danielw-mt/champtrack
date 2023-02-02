import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:handball_performance_tracker/core/core.dart';
import 'package:handball_performance_tracker/data/models/models.dart';
import 'package:handball_performance_tracker/data/repositories/game_repository.dart';
import 'package:handball_performance_tracker/data/repositories/player_repository.dart';
import 'package:handball_performance_tracker/data/repositories/team_repository.dart';
// import 'package:handball_performance_tracker/features/statistics/statistics.dart';
import 'generate_statistics.dart';
import 'dart:developer' as developer;
// import json package
import 'dart:convert';
import 'dart:io';

part 'statistics_event.dart';
part 'statistics_state.dart';

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  GameFirebaseRepository gameRepository;
  TeamFirebaseRepository teamRepository;
  PlayerFirebaseRepository playerRepository;

  StatisticsBloc(
      {required GameFirebaseRepository this.gameRepository,
      required PlayerFirebaseRepository this.playerRepository,
      required TeamFirebaseRepository this.teamRepository})
      : super(StatisticsState()) {
    on<StatisticsEvent>((event, emit) {});

    on<ChangeTabs>((event, emit) {
      emit(state.copyWith(selectedStatScreenIndex: event.tabIndex));
    });

    on<SelectTeam>((event, emit) {
      // get all games
      List<Game> fetchedGames = gameRepository.games;
      // build list of games for selected team
      List<Game> selectedTeamGames =
          fetchedGames.where((game) => game.teamId == event.team.id).toList();

      if (selectedTeamGames.length == 0) {
        selectedTeamGames = [
          Game(date: DateTime.now(), opponent: StringsGeneral.lNoTeamStats)
        ];
      }

      // set selected game
      Game selectedGame = selectedTeamGames.isNotEmpty
          ? selectedTeamGames[0]
          : Game(date: DateTime.now());

      List<Player> selectedTeamGamePlayers = event.team.players.toList();
      Player selectedPlayer = selectedTeamGamePlayers.isNotEmpty
          ? selectedTeamGamePlayers[0]
          : Player();

      PlayerStatistics selectedPlayerStats = _buildPlayerStatistics(
          state.statistics, selectedPlayer, selectedGame);

      TeamStatistics selectedTeamStats =
          _buildTeamStatistics(state.statistics, event.team, selectedGame);

      String selectedTeamPerformanceParameter =
          selectedTeamStats.actionSeries.keys.toList().isNotEmpty
              ? selectedTeamStats.actionSeries.keys.toList()[0]
              : StringsGeneral.lNoTeamStats;
      // String selectedPlayerPerformanceParameter =
      //     selectedPlayerStats.actionSeries.keys.toList()[0];

      emit(state.copyWith(
        selectedTeam: event.team,
        selectedTeamGames: selectedTeamGames,
        selectedGame: selectedGame,
        selectedTeamStats: selectedTeamStats,
        selectedTeamGamePlayers: selectedTeamGamePlayers,
        selectedPlayer: selectedPlayer,
        selectedPlayerStats: selectedPlayerStats,
        selectedTeamPerformanceParameter: selectedTeamPerformanceParameter,
      ));
    });

    on<SelectGame>((event, emit) {
      TeamStatistics newSelectedTeamStats = _buildTeamStatistics(
          state.statistics, state.selectedTeam, event.game);
      String selectedTeamPerformanceParameter =
          newSelectedTeamStats.actionSeries.keys.toList().isNotEmpty
              ? newSelectedTeamStats.actionSeries.keys.toList()[0]
              : StringsGeneral.lNoTeamStats;
      emit(state.copyWith(
          selectedGame: event.game,
          selectedTeamStats: newSelectedTeamStats,
          selectedTeamPerformanceParameter: selectedTeamPerformanceParameter));
    });

    on<SelectPlayer>((event, emit) {
      PlayerStatistics selectedPlayerStats = _buildPlayerStatistics(
          state.statistics, event.player, state.selectedGame);

      String selectedPlayerPerformanceParameter =
          selectedPlayerStats.actionSeries.keys.toList().isNotEmpty
              ? selectedPlayerStats.actionSeries.keys.toList()[0]
              : StringsGeneral.lNoTeamStats;

      emit(state.copyWith(
          selectedPlayer: event.player,
          selectedPlayerStats: selectedPlayerStats,
          selectedPlayerPerformanceParameter:
              selectedPlayerPerformanceParameter));
    });

    on<PieChartView>((event, emit) {
      if (state.pieChartView) {
        emit(state.copyWith(pieChartView: false));
      } else {
        emit(state.copyWith(pieChartView: true));
      }
    });

    on<SelectTeamPerformanceParameter>((event, emit) {
      print("teamParam");
      print(event.parameter);
      emit(state.copyWith(selectedTeamPerformanceParameter: event.parameter));
    });

    on<SelectPlayerPerformanceParameter>((event, emit) {
      print("playerParam");
      print(event.parameter);
      emit(state.copyWith(selectedPlayerPerformanceParameter: event.parameter));
    });

    on<SwitchField>((event, emit) {
      if (state.heatmapShowsAttack) {
        emit(state.copyWith(heatmapShowsAttack: false));
      } else {
        emit(state.copyWith(heatmapShowsAttack: true));
      }
    });

    on<SelectHeatmapParameter>((event, emit) {
      emit(state.copyWith(selectedHeatmapParameter: event.parameter));
    });

    on<InitStatistics>((event, emit) async {
      print("init statistics");
      emit(state.copyWith(status: StatisticsStatus.loading));
      try {
        // game actions already not available here
        List<Game> fetchedGames = gameRepository.games;

        List<Team> fetchedTeams = teamRepository.teams;

        // if fetchedTeams is not empty, then set selectedTeam to the first team in the list
        Team selectedTeam = fetchedTeams.isNotEmpty ? fetchedTeams[0] : Team();

        List<Game> selectedTeamGames = fetchedGames
            .where((game) => game.teamId == selectedTeam.id)
            .toList();

        Game selectedGame = selectedTeamGames.isNotEmpty
            ? selectedTeamGames[0]
            : Game(date: DateTime.now());

        List<Player> fetchedPlayers = playerRepository.players;
        //print("fetchedPlayers: $fetchedPlayers");

        // filter for players who are on the selected team
        List<Player> selectedTeamPlayers = fetchedPlayers
            .where((player) => player.teams
                .where((element) => element == selectedTeam.id)
                .isNotEmpty)
            .toList();
        //print("selectedTeamPlayers: $selectedTeamPlayers");

        // if selectedTeamGamePlayers is not empty, then set selectedPlayer to the first player in the list

        print("before generateStatistics");
        Map<String, dynamic> statistics =
            generateStatistics(fetchedGames, fetchedPlayers);
        // print("after generateStatistics" + statistics.toString());

        TeamStatistics selectedTeamStats =
            _buildTeamStatistics(statistics, selectedTeam, selectedGame);
        // print team statistics
        // print("team statistics: " + selectedTeamStats.toString());

        // filter selectedTeamPlayers for players who are on the selected game accourding to player.gameslist
        // List<Player> selectedTeamGamePlayers = selectedTeamPlayers
        //     .where((player) => player.games
        //         .where((element) => element == selectedGame.id)
        //         .isNotEmpty)
        //     .toList();
        List<Player> selectedTeamGamePlayers = selectedTeam.players.toList();
        // .where((player) => player.games
        //     .where((element) => element == selectedGame.id)
        //     .isNotEmpty)

        Player selectedPlayer = selectedTeamGamePlayers.isNotEmpty
            ? selectedTeamGamePlayers[0]
            : Player();

        PlayerStatistics selectedPlayerStats =
            _buildPlayerStatistics(statistics, selectedPlayer, selectedGame);

        // if actionSeries to list not empty select first parameter otherwise write string no parameter
        String selectedTeamPerformanceParameter =
            selectedTeamStats.actionSeries.keys.toList().isNotEmpty
                ? selectedTeamStats.actionSeries.keys.toList()[0]
                : StringsGeneral.lNoTeamStats;

        // String selectedTeamPerformanceParameter =
        //     selectedTeamStats.actionSeries.keys.toList()[0];
        // print selectedTeamPerformanceParameter
        print("selectedTeamPerformanceParameter: " +
            selectedTeamPerformanceParameter);
        String selectedPlayerPerformanceParameter =
            selectedPlayerStats.actionSeries.keys.toList().isNotEmpty
                ? selectedPlayerStats.actionSeries.keys.toList()[0]
                : StringsGeneral.lNoTeamStats;
        print("done init statistics");
        emit(state.copyWith(
            status: StatisticsStatus.loaded,
            allGames: fetchedGames,
            allTeams: fetchedTeams,
            allPlayers: fetchedPlayers,
            selectedTeam: selectedTeam,
            selectedTeamGames: selectedTeamGames,
            selectedTeamGamePlayers: selectedTeamGamePlayers,
            selectedPlayer: selectedPlayer,
            selectedGame: selectedGame,
            statistics: statistics,
            selectedTeamStats: selectedTeamStats,
            selectedPlayerStats: selectedPlayerStats,
            selectedTeamPerformanceParameter: selectedTeamPerformanceParameter,
            selectedPlayerPerformanceParameter:
                selectedPlayerPerformanceParameter));
      } catch (e) {
        print('Failure loading teams or players ' + e.toString());
        emit(state.copyWith(status: StatisticsStatus.error));
      }
    });

    on<AddCurrentGameStatistics>((event, emit) async {
      print("add current game statistics");
      List<Player> fetchedPlayers = playerRepository.players;
      // generate the stats for the current game
      Map<String, dynamic> statistics =
          generateStatistics([event.game], fetchedPlayers);
      JsonEncoder encoder = new JsonEncoder.withIndent('  ');
      String prettyprint = encoder.convert(statistics);
      print("adding current game to live statisttics");
      print(prettyprint);
      // // if current game is already part of the current statistics map, remove this event
      if (state.statistics.containsKey(event.game.id)) {
        print("game already exists in stats. Replacing game with newest stats");
        state.statistics[event.game.id!] = statistics[event.game.id];
      } else {
        // add the current game to the statistics map
        state.statistics.addAll(statistics);
      }
    });
  }

  TeamStatistics _buildTeamStatistics(
      Map<String, dynamic> statistics, Team team, Game game) {
    TeamStatistics teamStatistics = TeamStatistics();
    Map<String, dynamic> teamStats = {};

    try {
      teamStats = statistics[game.id]["team_stats"][team.id];
      // print teamStats
      print("teamStats: " + teamStats.toString());
      teamStatistics.teamStats = teamStats;
      //Map<String, dynamic> teamStats = _statistics[statisticsBloc.state.selectedGame.id]["team_stats"][statisticsBloc.state.selectedTeam.id];
      // try to get action counts for the player
      teamStatistics.actionCounts = teamStats["action_counts"];
      // print teamstats object action counts
      print("teamStats object action counts: " +
          teamStatistics.actionCounts.toString());
      // try to get action_series for player
      teamStatistics.actionSeries = teamStats["action_series"];

      // try to get ef-score series for player
      teamStatistics.efScoreSeries = teamStats["ef_score_series"];
      // try to get all action timestamps for player
      teamStatistics.timeStamps = teamStats["all_action_timestamps"];
      // try to get start time for game
      teamStatistics.startTime = statistics[game.id]["start_time"];
      teamStatistics.stopTime = statistics[game.id]["stop_time"];

      teamStatistics.quotas = [
        [
          double.parse(teamStats["seven_meter_quota"][0].toString()),
          double.parse(teamStats["seven_meter_quota"][1].toString())
        ],
        [
          double.parse(teamStats["position_quota"][0].toString()),
          double.parse(teamStats["position_quota"][1].toString())
        ],
        [
          double.parse(teamStats["throw_quota"][0].toString()),
          double.parse(teamStats["throw_quota"][1].toString())
        ],
        [
          double.parse(teamStats["parade_quota"][0].toString()),
          double.parse(teamStats["parade_quota"][1].toString())
        ],
      ];
    } on Exception catch (e) {
      developer.log(e.toString());
    } catch (e) {
      developer.log(e.toString());
    }
    // print selected teamsStats
    print("selected teamStats: $teamStatistics");
    return teamStatistics;
  }

  PlayerStatistics _buildPlayerStatistics(
      Map<String, dynamic> statistics, Player player, Game game) {
    PlayerStatistics playerStatistics = PlayerStatistics();
    Map<String, dynamic> playerStats = {};

    try {
      playerStats = statistics[game.id]["player_stats"][player.id];
      // print playerStats
      print("playerStats: " + playerStats.toString());
      playerStatistics.playerStats = playerStats;
      //Map<String, dynamic> teamStats = _statistics[statisticsBloc.state.selectedGame.id]["team_stats"][statisticsBloc.state.selectedTeam.id];
      // try to get action counts for the player
      playerStatistics.actionCounts = playerStats["action_counts"];
      // print playerstats object action counts
      print("playerStats object action counts: " +
          playerStatistics.actionCounts.toString());
      // try to get action_series for player
      playerStatistics.actionSeries = playerStats["action_series"];

      // try to get ef-score series for player
      playerStatistics.efScoreSeries = playerStats["ef_score_series"];
      // try to get all action timestamps for player
      playerStatistics.timeStamps = playerStats["all_action_timestamps"];
      // try to get start time for game
      playerStatistics.startTime = statistics[game.id]["start_time"];
      playerStatistics.stopTime = statistics[game.id]["stop_time"];

      playerStatistics.quotas = [
        [
          double.parse(playerStats["seven_meter_quota"][0].toString()),
          double.parse(playerStats["seven_meter_quota"][1].toString())
        ],
        [
          double.parse(playerStats["position_quota"][0].toString()),
          double.parse(playerStats["position_quota"][1].toString())
        ],
        [
          double.parse(playerStats["throw_quota"][0].toString()),
          double.parse(playerStats["throw_quota"][1].toString())
        ],
        [
          double.parse(playerStats["parade_quota"][0].toString()),
          double.parse(playerStats["parade_quota"][1].toString())
        ],
      ];
    } on Exception catch (e) {
      developer.log(e.toString());
    } catch (e) {
      developer.log(e.toString());
    }
    // print selected playerStats
    print("selected playerStats: $playerStatistics");

    return playerStatistics;
  }
}
