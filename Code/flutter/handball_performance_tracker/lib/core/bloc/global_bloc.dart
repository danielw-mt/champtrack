import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:handball_performance_tracker/data/repositories/repositories.dart';
import 'package:handball_performance_tracker/data/models/models.dart';
import 'dart:developer' as developer;

part 'global_event.dart';
part 'global_state.dart';

class GlobalBloc extends Bloc<GlobalEvent, GlobalState> {
  GlobalBloc() : super(GlobalState().copyWith(status: GlobalStatus.loading)) {
    on<LoadGlobalState>((event, emit) async {
      try {
        List<Team> fetchedTeams = await TeamFirebaseRepository().fetchTeams();
        List<Player> fetchedPlayers = await PlayerFirebaseRepository().fetchPlayers();
        List<Game> fetchedGames = await GameFirebaseRepository().fetchGames();
        emit(state.copyWith(status: GlobalStatus.success, allTeams: fetchedTeams, allPlayers: fetchedPlayers, allGames: fetchedGames));
      } catch (e) {
        developer.log('Failure loading teams or players ' + e.toString(), name: 'TeamManagementCubit', error: e);
        emit(state.copyWith(status: GlobalStatus.failure));
      }
    });

    on<CreateTeam>((event, emit) async {
      try {
        Team newTeam = await TeamFirebaseRepository().createTeam(event.team);
        emit(state.copyWith(allTeams: [...state.allTeams, newTeam]));
      } catch (e) {
        developer.log('Failure creating team ' + e.toString(), name: 'TeamManagementCubit', error: e);
        emit(state.copyWith(status: GlobalStatus.failure));
      }
    });

    on<UpdateTeam>((event, emit) async {
      try {
        await TeamFirebaseRepository().updateTeam(event.team);
        // updated teams is where the team with the same id as the updated team is replaced with the updated team
        List<Team> updatedTeams = state.allTeams.map((team) => team.id == event.team.id ? event.team : team).toList();
        emit(state.copyWith(allTeams: updatedTeams));
      } catch (e) {
        developer.log('Failure updating team ' + e.toString(), name: 'TeamManagementCubit', error: e);
        emit(state.copyWith(status: GlobalStatus.failure));
      }
    });

    on<DeleteTeam>((event, emit) async {
      try {
        await TeamFirebaseRepository().deleteTeam(event.team);
        // updated teams are all teams where the id does not match the deleted team
        List<Team> updatedTeams = state.allTeams.where((team) => team.id != event.team.id).toList();
        emit(state.copyWith(allTeams: updatedTeams));
      } catch (e) {
        developer.log('Failure deleting team ' + e.toString(), name: 'TeamManagementCubit', error: e);
        emit(state.copyWith(status: GlobalStatus.failure));
      }
    });

    on<CreatePlayer>((event, emit) async {
      try {
        Player newPlayer = await PlayerFirebaseRepository().createPlayer(event.player);
        emit(state.copyWith(allPlayers: [...state.allPlayers, newPlayer]));
      } catch (e) {
        developer.log('Failure creating player ' + e.toString(), name: 'PlayerManagementCubit', error: e);
        emit(state.copyWith(status: GlobalStatus.failure));
      }
    });

    on<UpdatePlayer>((event, emit) async {
      try {
        await PlayerFirebaseRepository().updatePlayer(event.player);
        // updated players is where the player with the same id as the updated player is replaced with the updated player
        List<Player> updatedPlayers = state.allPlayers.map((player) => player.id == event.player.id ? event.player : player).toList();
        emit(state.copyWith(allPlayers: updatedPlayers));
      } catch (e) {
        developer.log('Failure updating player ' + e.toString(), name: 'PlayerManagementCubit', error: e);
        emit(state.copyWith(status: GlobalStatus.failure));
      }
    });

    on<DeletePlayer>((event, emit) async {
      try {
        await PlayerFirebaseRepository().deletePlayer(event.player);
        // updated players are all players where the id does not match the deleted player
        List<Player> updatedPlayers = state.allPlayers.where((player) => player.id != event.player.id).toList();
        emit(state.copyWith(allPlayers: updatedPlayers));
      } catch (e) {
        developer.log('Failure deleting player ' + e.toString(), name: 'PlayerManagementCubit', error: e);
        emit(state.copyWith(status: GlobalStatus.failure));
      }
    });

    on<CreateGame>((event, emit) async {
      try {
        Game newGame = await GameFirebaseRepository().createGame(event.game);
        emit(state.copyWith(allGames: [...state.allGames, newGame]));
      } catch (e) {
        developer.log('Failure creating game ' + e.toString(), name: 'GameManagementCubit', error: e);
        emit(state.copyWith(status: GlobalStatus.failure));
      }
    });

    on<UpdateGame>((event, emit) async {
      try {
        await GameFirebaseRepository().updateGame(event.game);
        // updated games is where the game with the same id as the updated game is replaced with the updated game
        List<Game> updatedGames = state.allGames.map((game) => game.id == event.game.id ? event.game : game).toList();
        emit(state.copyWith(allGames: updatedGames));
      } catch (e) {
        developer.log('Failure updating game ' + e.toString(), name: 'GameManagementCubit', error: e);
        emit(state.copyWith(status: GlobalStatus.failure));
      }
    });

    on<DeleteGame>((event, emit) async {
      try {
        await GameFirebaseRepository().deleteGame(event.game);
        // updated games are all games where the id does not match the deleted game
        List<Game> updatedGames = state.allGames.where((game) => game.id != event.game.id).toList();
        emit(state.copyWith(allGames: updatedGames));
      } catch (e) {
        developer.log('Failure deleting game ' + e.toString(), name: 'GameManagementCubit', error: e);
        emit(state.copyWith(status: GlobalStatus.failure));
      }
    });
  }
}
