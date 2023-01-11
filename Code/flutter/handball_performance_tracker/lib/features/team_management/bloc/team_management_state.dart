part of 'team_management_bloc.dart';

enum TeamManagementStatus { loading, loaded, error }

class TeamManagementState extends Equatable {
  TeamManagementStatus status = TeamManagementStatus.loading;
  int selectedTabIndex = 0;
  int selectedTeamIndex = 0;

  TeamManagementState({
    this.status = TeamManagementStatus.loading,
    this.selectedTabIndex = 0,
    this.selectedTeamIndex = 0,
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
  }

  @override
  List<Object> get props =>
      [this.status, this.selectedTabIndex, this.selectedTeamIndex];

  TeamManagementState copyWith({
    TeamManagementStatus? status,
    int? selectedTabIndex,
    int? selectedTeamIndex,
  }) {
    return TeamManagementState(
      status: status ?? this.status,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      selectedTeamIndex: selectedTeamIndex ?? this.selectedTeamIndex,
    );
  }
}

//class TeamManagementInitial extends TeamManagementState {}
