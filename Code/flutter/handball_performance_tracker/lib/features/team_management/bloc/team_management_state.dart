part of 'team_management_bloc.dart';

enum TeamManagementStatus { loading, loaded, error }

class TeamManagementState extends Equatable {
  TeamManagementStatus status = TeamManagementStatus.loading;
  int selectedTabIndex = 0;
  int selectedTeamIndex = 0;
  bool addingTeam = false;
  bool addingPlayer = false;
  int selectedTeamType = 0;

  TeamManagementState({
    this.status = TeamManagementStatus.loading,
    this.selectedTabIndex = 0,
    this.selectedTeamIndex = 0,
    this.addingTeam = false,
    this.addingPlayer = false,
    this.selectedTeamType = 0,
  }) {
    if (status != null) {
      this.status = status;
    }
    if (selectedTabIndex != null) {
      this.selectedTabIndex = selectedTabIndex;
    }
    if (selectedTeamIndex != null) {
      this.selectedTeamIndex = selectedTeamIndex;
    }
    if (addingTeam != null) {
      this.addingTeam = addingTeam;
    }
    if (addingPlayer != null) {
      this.addingPlayer = addingPlayer;
    }
    if (selectedTeamType != null) {
      this.selectedTeamType = selectedTeamType;
    }
  }

  @override
  List<Object> get props => [
        this.status,
        this.selectedTabIndex,
        this.selectedTeamIndex,
        this.addingTeam,
        this.addingPlayer,
        this.selectedTeamType
      ];

  TeamManagementState copyWith({
    TeamManagementStatus? status,
    int? selectedTabIndex,
    int? selectedTeamIndex,
    bool? addingTeam,
    bool? addingPlayer,
    int? selectedTeamType,
  }) {
    return TeamManagementState(
      status: status ?? this.status,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      selectedTeamIndex: selectedTeamIndex ?? this.selectedTeamIndex,
      addingTeam: addingTeam ?? this.addingTeam,
      addingPlayer: addingPlayer ?? this.addingPlayer,
      selectedTeamType: selectedTeamType ?? this.selectedTeamType,
    );
  }
}

//class TeamManagementInitial extends TeamManagementState {}
