part of 'team_management_cubit.dart';

enum TeamManagementTab { playersTab, gamesTab, settingsTab }

// TODO look into using Equatable and abstracting properly

abstract class TeamManagementState {
  List<Team> allTeams;
  List<Player> allPlayers;
  final int selectedTeamIndex;
  final TeamManagementTab selectedTab;
  TeamManagementState(
      {this.allTeams = const [], this.allPlayers = const [], this.selectedTeamIndex = 0, this.selectedTab = TeamManagementTab.playersTab}) {
    if (this.allTeams.isEmpty) {
      this.allTeams = [];
    }
    if (this.allPlayers.isEmpty) {
      this.allPlayers = [];
    }
  }
}

class TeamManagementLoading extends TeamManagementState {
  List<Team> allTeams;
  List<Player> allPlayers;
  final int selectedTeamIndex;
  final TeamManagementTab selectedTab;
  TeamManagementLoading(
      {this.allTeams = const [], this.allPlayers = const [], this.selectedTeamIndex = 0, this.selectedTab = TeamManagementTab.playersTab}) {
    if (this.allTeams.isEmpty) {
      this.allTeams = List.empty(growable: true);
    }
    if (this.allPlayers.isEmpty) {
      this.allPlayers = List.empty(growable: true);
    }
  }
}

class TeamManagementLoaded extends TeamManagementState {
  List<Team> allTeams;
  List<Player> allPlayers;
  final int selectedTeamIndex;
  final TeamManagementTab selectedTab;
  TeamManagementLoaded(
      {this.allTeams = const [], this.allPlayers = const [], this.selectedTeamIndex = 0, this.selectedTab = TeamManagementTab.playersTab}) {
    if (this.allTeams.isEmpty) {
      this.allTeams = List.empty(growable: true);
    }
    if (this.allPlayers.isEmpty) {
      this.allPlayers = List.empty(growable: true);
    }
  }
}

class TeamManagementError extends TeamManagementState {
  final String errorMessage;

  TeamManagementError({required this.errorMessage});
}
