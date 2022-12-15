import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:handball_performance_tracker/data/models/models.dart';
import 'package:handball_performance_tracker/data/repositories/game_repository.dart';
import 'package:handball_performance_tracker/data/repositories/player_repository.dart';
import 'package:handball_performance_tracker/data/repositories/team_repository.dart';
import 'generate_statistics.dart';
import 'dart:developer' as developer;

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

      // set selected game
      Game selectedGame = selectedTeamGames.isNotEmpty
          ? selectedTeamGames[0]
          : Game(date: DateTime.now());

      TeamStatistics selectedTeamStats =
          buildTeamStatistics(state.statistics, event.team, selectedGame);

      emit(state.copyWith(
          selectedTeam: event.team,
          selectedTeamGames: selectedTeamGames,
          selectedGame: selectedGame,
          selectedTeamStats: selectedTeamStats));
    });

    on<SelectGame>((event, emit) {
      TeamStatistics newSelectedTeamStats =
          buildTeamStatistics(state.statistics, state.selectedTeam, event.game);
      emit(state.copyWith(
          selectedGame: event.game, selectedTeamStats: newSelectedTeamStats));
    });

    on<SelectPlayer>((event, emit) {
      emit(state.copyWith(selectedPlayer: event.player));
    });

    on<PieChartView>((event, emit) {
      if (state.pieChartView) {
        emit(state.copyWith(pieChartView: false));
      } else {
        emit(state.copyWith(pieChartView: true));
      }
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

        // filter selectedTeamPlayers for players who are on the selected game accourding to player.gameslist
        List<Player> selectedTeamGamePlayers = selectedTeamPlayers
            .where((player) => player.games
                .where((element) => element == selectedGame.id)
                .isNotEmpty)
            .toList();

        // if selectedTeamGamePlayers is not empty, then set selectedPlayer to the first player in the list
        Player selectedPlayer = selectedTeamGamePlayers.isNotEmpty
            ? selectedTeamGamePlayers[0]
            : Player();

        print("before generateStatistics");
        Map<String, dynamic> statistics =
            generateStatistics(fetchedGames, fetchedPlayers);
        print("after generateStatistics" + statistics.toString());

        TeamStatistics selectedTeamStats =
            buildTeamStatistics(statistics, selectedTeam, selectedGame);
        // print team statistics
        print("team statistics: " + selectedTeamStats.toString());

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
            selectedTeamStats: selectedTeamStats));
      } catch (e) {
        print('Failure loading teams or players ' + e.toString());
        emit(state.copyWith(status: StatisticsStatus.error));
      }
      //emit(state.copyWith());
    });
  }

  TeamStatistics buildTeamStatistics(
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
        [double.parse(teamStats["seven_meter_quota"][0].toString()), double.parse(teamStats["seven_meter_quota"][1].toString())],
        [double.parse(teamStats["position_quota"][0].toString()), double.parse(teamStats["position_quota"][1].toString())],
        [double.parse(teamStats["throw_quota"][0].toString()), double.parse(teamStats["throw_quota"][1].toString())]
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
}
