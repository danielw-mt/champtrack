part of 'team_management_cubit.dart';

enum TeamManagementTab { playersTab, gamesTab, settingsTab }

// TODO look into using Equatable and abstracting properly

class TeamManagementState extends Equatable {
  final TeamManagementTab currentTab;
  final int selectedTeamIndex;

  TeamManagementState({
    this.currentTab = TeamManagementTab.playersTab,
    this.selectedTeamIndex = 0,
  });

  TeamManagementState copyWith({
    TeamManagementTab? currentTab,
    int? selectedTeamIndex,
  }) {
    return TeamManagementState(
      currentTab: currentTab ?? this.currentTab,
      selectedTeamIndex: selectedTeamIndex ?? this.selectedTeamIndex,
    );
  }

  @override
  String toString() {
    return ''' TeamManagementState {
      currentTab: $currentTab,
      selectedTeamIndex: $selectedTeamIndex,
    }''';
  }

  @override
  List<Object> get props => [];
}