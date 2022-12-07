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
      print("Select player event");
      print(event.player);
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
        // emit(state.copyWith(status: GlobalStatus.loading));
        // List<Player> fetchedPlayers = await PlayerFirebaseRepository().fetchPlayers();
        // List<Team> fetchedTeams = await TeamFirebaseRepository().fetchTeams(allPlayers: fetchedPlayers);
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
        print("selectedTeamPlayers: $selectedTeamPlayers");

        // filter selectedTeamPlayers for players who are on the selected game accourding to player.gameslist
        List<Player> selectedTeamGamePlayers =
            selectedTeamPlayers.where((player) => player.games.where((element) => element == selectedGame.id).isNotEmpty).toList();

        // if selectedTeamGamePlayers is not empty, then set selectedPlayer to the first player in the list
        Player selectedPlayer = selectedTeamGamePlayers.isNotEmpty ? selectedTeamGamePlayers[0] : Player();

        Map<String, dynamic> statistics = generateStatistics(fetchedGames, fetchedPlayers);

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
            statistics: statistics));
      } catch (e) {
        developer.log('Failure loading teams or players ' + e.toString(), name: this.runtimeType.toString(), error: e);
        emit(state.copyWith(status: StatisticsStatus.error));
      }
      //emit(state.copyWith());
    });
  }

  /// getter for the statistics map
  // Map<String, dynamic> getStatistics() {
  //   if (_statistics_ready) {
  //     return _statistics;
  //   } else {
  //     return {};
  //   }
  // }
//}

}
