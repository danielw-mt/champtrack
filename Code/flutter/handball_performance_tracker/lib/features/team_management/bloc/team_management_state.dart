part of 'team_management_bloc.dart';

enum TeamManagementStatus { loading, loaded, error }

enum TeamManagementViewField { players, addingTeams, addingPlayers, editPlayer }

class TeamManagementState extends Equatable {
  TeamManagementStatus status = TeamManagementStatus.loading;
  int selectedTabIndex = 0;
  int selectedTeamIndex = 0;
  TeamManagementViewField viewField = TeamManagementViewField.players;
  bool addingTeam = false;
  bool addingPlayer = false;
  int selectedTeamType = 0;
  String selectedTeamName = "";
  int selectedPlayerIndex = 0;
  Player selectedPlayer = Player();

  TeamManagementState({
    this.status = TeamManagementStatus.loading,
    this.selectedTabIndex = 0,
    this.selectedTeamIndex = 0,
    this.viewField = TeamManagementViewField.players,
    this.addingTeam = false,
    this.addingPlayer = false,
    this.selectedTeamType = 0,
    this.selectedTeamName = "",
    this.selectedPlayerIndex = 0,
    selectedPlayer,
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
    if (viewField != null) {
      this.viewField = viewField;
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
    if (selectedTeamName != null) {
      this.selectedTeamName = selectedTeamName;
    }
    if (selectedPlayerIndex != null) {
      this.selectedPlayerIndex = selectedPlayerIndex;
    }
    if (selectedPlayer != null) {
      this.selectedPlayer = selectedPlayer;
    }
  }

  @override
  List<Object> get props => [
        this.status,
        this.selectedTabIndex,
        this.selectedTeamIndex,
        this.viewField,
        this.addingTeam,
        this.addingPlayer,
        this.selectedTeamType,
        this.selectedTeamName,
        this.selectedPlayerIndex,
        this.selectedPlayer,
      ];

  TeamManagementState copyWith({
    TeamManagementStatus? status,
    int? selectedTabIndex,
    int? selectedTeamIndex,
    TeamManagementViewField? viewField,
    bool? addingTeam,
    bool? addingPlayer,
    int? selectedTeamType,
    String? selectedTeamName,
    int? selectedPlayerIndex,
    Player? selectedPlayer,
  }) {
    return TeamManagementState(
      status: status ?? this.status,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      selectedTeamIndex: selectedTeamIndex ?? this.selectedTeamIndex,
      viewField: viewField ?? this.viewField,
      addingTeam: addingTeam ?? this.addingTeam,
      addingPlayer: addingPlayer ?? this.addingPlayer,
      selectedTeamType: selectedTeamType ?? this.selectedTeamType,
      selectedTeamName: selectedTeamName ?? this.selectedTeamName,
      selectedPlayerIndex: selectedPlayerIndex ?? this.selectedPlayerIndex,
      selectedPlayer: selectedPlayer ?? this.selectedPlayer,
    );
  }
}

//class TeamManagementInitial extends TeamManagementState {}
