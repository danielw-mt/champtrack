import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:handball_performance_tracker/data/models/models.dart';
import 'package:handball_performance_tracker/data/repositories/repositories.dart';
import 'dart:developer' as developer;

part 'team_management_state.dart';

class TeamManagementCubit extends Cubit<TeamManagementState> {
  TeamManagementCubit() : super(TeamManagementLoading());

  Future<void> loadTeamManagement() async {
    try {
      List<Team> fetchedTeams = await TeamFirebaseRepository().fetchTeams();
      // TODO fetch players or maybe not for team management
      // List<Player> fetchedPlayers = await PlayerFirebaseRepository().fetchPlayers();
      List<Game> fetchedGames = await GameFirebaseRepository().fetchGames();
      emit(TeamManagementLoaded(allTeams: fetchedTeams, allGames: fetchedGames, selectedTeamIndex: 0));
    } catch (e) {
      developer.log('Failure loading teams or players ' + e.toString(), name: 'TeamManagementCubit', error: e);
      emit(TeamManagementError(errorMessage: "Error loading teams and players"));
    }
  }

  changeTab(TeamManagementTab tab) {
    emit(TeamManagementLoaded(allTeams: state.allTeams, allGames: state.allGames, selectedTeamIndex: state.selectedTeamIndex, selectedTab: tab));
  }

  selectTeam(Team team) {
    int index = state.allTeams.indexWhere((Team teamInList) => teamInList.id == team.id);
    emit(TeamManagementLoaded(allTeams: state.allTeams, allGames: state.allGames, selectedTeamIndex: index, selectedTab: state.selectedTab));
  }

  Future<void> createTeam(Team team) async {
    try {
      emit(TeamManagementLoading(
          allTeams: state.allTeams, allGames: state.allGames, selectedTeamIndex: state.selectedTeamIndex, selectedTab: state.selectedTab));
      await TeamFirebaseRepository().createTeam(team);
      emit(TeamManagementLoaded(
          allTeams: state.allTeams, allGames: state.allGames, selectedTeamIndex: state.selectedTeamIndex, selectedTab: state.selectedTab));
      state.allTeams.add(team);
    } catch (e) {
      developer.log('Failure creating team ' + e.toString(), name: 'TeamManagementCubit', error: e);
      emit(TeamManagementError(errorMessage: "Error creating team"));
    }
  }

  Future<void> updateTeam(Team team) async {
    try {
      await TeamFirebaseRepository().updateTeam(team);
      if (state is TeamManagementLoaded) {
        TeamManagementLoaded state = this.state as TeamManagementLoaded;
        state.allTeams[state.allTeams.indexWhere((Team teamInList) => teamInList.id == team.id)] = team;
        emit(TeamManagementLoaded(allTeams: state.allTeams, allGames: state.allGames, selectedTeamIndex: state.selectedTeamIndex, selectedTab: state.selectedTab));
      }
    } catch (e) {
      developer.log('Failure updating team ' + e.toString(), name: 'TeamManagementCubit', error: e);
      emit(TeamManagementError(errorMessage: "Error updating team"));
    }
  }

  Future<void> deleteTeam(Team team) async {
    try {
      TeamFirebaseRepository().deleteTeam(team);
      if (state is TeamManagementLoaded) {
        TeamManagementLoaded state = this.state as TeamManagementLoaded;
        state.allTeams.removeWhere((Team teamInList) => teamInList.id == team.id);
        emit(TeamManagementLoaded(allTeams: state.allTeams, allGames: state.allGames, selectedTeamIndex: state.selectedTeamIndex, selectedTab: state.selectedTab));
      }
    } catch (e) {
      developer.log('Failure deleting team ' + e.toString(), name: 'TeamManagementCubit', error: e);
      emit(TeamManagementError(errorMessage: "Error deleting team"));
    }
  }

  Future<void> deleteGame(Game game) async {
    try {
      GameFirebaseRepository().deleteGame(game);
      if (state is TeamManagementLoaded) {
        TeamManagementLoaded state = this.state as TeamManagementLoaded;
        state.allGames.removeWhere((Game gameInList) => gameInList.id == game.id);
        emit(TeamManagementLoaded(allTeams: state.allTeams, allGames: state.allGames, selectedTeamIndex: state.selectedTeamIndex, selectedTab: state.selectedTab));
      }
    } catch (e) {
      developer.log('Failure deleting game ' + e.toString(), name: 'TeamManagementCubit', error: e);
      emit(TeamManagementError(errorMessage: "Error deleting game"));
    }
  }
}
