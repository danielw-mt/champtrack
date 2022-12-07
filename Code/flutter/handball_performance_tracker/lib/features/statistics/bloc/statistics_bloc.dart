import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
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
      List<Game> selectedTeamGames = fetchedGames.where((game) => game.teamId == event.team.id).toList();
      // set selected game
      Game selectedGame = selectedTeamGames.isNotEmpty ? selectedTeamGames[0] : Game(date: DateTime.now());



      emit(state.copyWith(selectedTeam: event.team, selectedTeamGames: selectedTeamGames, selectedGame: selectedGame));
    });

    on<SelectGame>((event, emit) {
      // print selected game name
      print("Select game event");
      print(event.game);
      emit(state.copyWith(selectedGame: event.game));
    });

    on<SelectPlayer>((event, emit) {
      // print selected player name
      //print("Select player event");
      //print(event.player);
      emit(state.copyWith(selectedPlayer: event.player));
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
      try {
        List<Game> fetchedGames = gameRepository.games;

        // print("game metadata: " + fetchedGames.first.toString());
        // print("actions: " + fetchedGames.first.gameActions.toString());

        // print("fetched games: $fetchedGames");
        List<Team> fetchedTeams = teamRepository.teams;
        //print("fetchedTeams: $fetchedTeams");
        // if fetchedTeams is not empty, then set selectedTeam to the first team in the list
        Team selectedTeam = fetchedTeams.isNotEmpty ? fetchedTeams[0] : Team();

        List<Game> selectedTeamGames = fetchedGames.where((game) => game.teamId == selectedTeam.id).toList();

        Game selectedGame = selectedTeamGames.isNotEmpty ? selectedTeamGames[0] : Game(date: DateTime.now());

        List<Player> fetchedPlayers = playerRepository.players;
        //print("fetchedPlayers: $fetchedPlayers");

        // filter for players who are on the selected team
        List<Player> selectedTeamPlayers =
            fetchedPlayers.where((player) => player.teams.where((element) => element == selectedTeam.id).isNotEmpty).toList();
        //print("selectedTeamPlayers: $selectedTeamPlayers");

        // filter selectedTeamPlayers for players who are on the selected game accourding to player.gameslist
        List<Player> selectedTeamGamePlayers =
            selectedTeamPlayers.where((player) => player.games.where((element) => element == selectedGame.id).isNotEmpty).toList();

        // if selectedTeamGamePlayers is not empty, then set selectedPlayer to the first player in the list
        Player selectedPlayer = selectedTeamGamePlayers.isNotEmpty ? selectedTeamGamePlayers[0] : Player();

        Map<String, dynamic> statistics = generateStatistics(fetchedGames, fetchedPlayers);

        TeamStatistics selectedTeamStats = buildTeamStatistics(statistics, selectedTeam, selectedGame);

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
        developer.log('Failure loading teams or players ' + e.toString(), name: this.runtimeType.toString(), error: e);
        emit(state.copyWith(status: StatisticsStatus.error));
      }
      //emit(state.copyWith());
    });
  }

  TeamStatistics buildTeamStatistics(Map<String, dynamic> statistics, Team team, Game game){
    TeamStatistics teamStatistics = TeamStatistics();
    Map<String, dynamic> teamStats = {};
    Map<String, int> actionCounts = {};
    Map<String, List<int>> actionSeries = {};
    int startTime = 0;
    int stopTime = 0;
    List<List<double>> quotas = [
      [0, 0],
      [0, 0],
      [0, 0]
    ];
    List<double> efScoreSeries = [];
    List<int> timeStamps = [];

    try { 
      teamStats = statistics[game.id]["team_stats"][team.id];
      teamStatistics.teamStats = teamStats;
      //Map<String, dynamic> teamStats = _statistics[statisticsBloc.state.selectedGame.id]["team_stats"][statisticsBloc.state.selectedTeam.id];
      // try to get action counts for the player
      teamStatistics.actionCounts = teamStats["action_counts"];
      // try to get action_series for player
      teamStatistics.actionSeries = teamStats["action_series"];

      // try to get ef-score series for player
      teamStatistics.efScoreSeries = teamStats["ef_score_series"];
      // try to get all action timestamps for player
      teamStatistics.timeStamps = teamStats["all_action_timestamps"];
      // try to get start time for game
      teamStatistics.startTime = statistics[game.id]["start_time"];
      teamStatistics.stopTime = statistics[game.id]["stop_time"];

      // try to get quotas for player
      teamStatistics.quotas[0][0] = double.parse(teamStats["seven_meter_quota"][0].toString());
      teamStatistics.quotas[0][1] = double.parse(teamStats["seven_meter_quota"][1].toString());
      teamStatistics.quotas[1][0] = double.parse(teamStats["position_quota"][0].toString());
      teamStatistics.quotas[1][1] = double.parse(teamStats["position_quota"][1].toString());
      teamStatistics.quotas[2][0] = double.parse(teamStats["throw_quota"][0].toString());
      teamStatistics.quotas[2][1] = double.parse(teamStats["throw_quota"][1].toString());
    } on Exception catch (e) {
      //logger.e(e);
    } catch (e) {
      //logger.e(e);
    }
    return teamStatistics;
  }

}
