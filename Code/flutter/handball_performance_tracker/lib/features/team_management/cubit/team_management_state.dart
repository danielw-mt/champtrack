part of 'team_management_cubit.dart';

enum TeamManagementTab { playersTab, gamesTab, settingsTab }

// TODO look into using Equatable

abstract class TeamManagementState {
  List<Team> allTeams;
  List<Player> allPlayers;
  final int selectedTeamIndex;
  final TeamManagementTab selectedTab;
  TeamManagementState({this.allTeams = const [], this.allPlayers = const[], this.selectedTeamIndex = 0, this.selectedTab = TeamManagementTab.playersTab}){
    if (this.allTeams.isEmpty){
      this.allTeams = [];
    }
    if (this.allPlayers.isEmpty){
      this.allPlayers = [];
    }
  }
}

class TeamManagementLoading extends TeamManagementState {
  TeamManagementLoading({super.allTeams, super.allPlayers, super.selectedTeamIndex, super.selectedTab}) : super();
}

class TeamManagementLoaded extends TeamManagementState {
  TeamManagementLoaded({super.allTeams, super.allPlayers, super.selectedTeamIndex, super.selectedTab}) : super();
}

class TeamManagementError extends TeamManagementState {
  final String errorMessage;

  TeamManagementError({required this.errorMessage});
}
