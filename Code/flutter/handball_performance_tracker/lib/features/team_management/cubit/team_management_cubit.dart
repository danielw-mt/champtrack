import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:handball_performance_tracker/data/models/models.dart';
import 'package:handball_performance_tracker/data/repositories/repositories.dart';
import 'dart:developer' as developer;

part 'team_management_state.dart';

class TeamManagementCubit extends Cubit<TeamManagementState> {
  TeamManagementCubit() : super(TeamManagementLoading());

  Future<void> loadTeamsAndPlayers() async {
    try {
      var allTeams = await TeamFirebaseRepository().fetchTeams();
      var allPlayers = await PlayerFirebaseRepository().fetchPlayers();
      emit(TeamManagementLoaded(allTeams: allTeams, allPlayers: allPlayers, selectedTeamIndex: 0));
    } catch (e) {
      developer.log('Failure loading teams or players ' + e.toString(), name: 'TeamManagementCubit', error: e);
      emit(TeamManagementError(errorMessage: "Error loading teams and players"));
    }
  }

  selectTeam(Team team) {
    if (state is TeamManagementLoaded) {
      TeamManagementLoaded state = this.state as TeamManagementLoaded;
      int index = state.allTeams.indexWhere((Team team) => team.id == team.id);
      emit(TeamManagementLoaded(allTeams: state.allTeams, allPlayers: state.allPlayers, selectedTeamIndex: index));
    }
  }

  Future<void> createTeam(Team team) async {
    try {
      emit(TeamManagementLoading(
          allTeams: state.allTeams, allPlayers: state.allPlayers, selectedTeamIndex: state.selectedTeamIndex, selectedTab: state.selectedTab));
      await TeamFirebaseRepository().createTeam(team);
      emit(TeamManagementLoaded(
          allTeams: state.allTeams, allPlayers: state.allPlayers, selectedTeamIndex: state.selectedTeamIndex, selectedTab: state.selectedTab));
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
        state.allTeams[state.allTeams.indexWhere((Team team) => team.id == team.id)] = team;
        emit(TeamManagementLoaded(allTeams: state.allTeams, allPlayers: state.allPlayers, selectedTeamIndex: state.selectedTeamIndex));
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
        state.allTeams.removeWhere((Team team) => team.id == team.id);
        emit(TeamManagementLoaded(allTeams: state.allTeams, allPlayers: state.allPlayers, selectedTeamIndex: state.selectedTeamIndex));
      }
    } catch (e) {
      developer.log('Failure deleting team ' + e.toString(), name: 'TeamManagementCubit', error: e);
      emit(TeamManagementError(errorMessage: "Error deleting team"));
    }
  }

  changeTab(TeamManagementTab tab) {
    if (state is TeamManagementLoaded) {
      TeamManagementLoaded state = this.state as TeamManagementLoaded;
      emit(
          TeamManagementLoaded(allTeams: state.allTeams, allPlayers: state.allPlayers, selectedTeamIndex: state.selectedTeamIndex, selectedTab: tab));
    }
  }
}
