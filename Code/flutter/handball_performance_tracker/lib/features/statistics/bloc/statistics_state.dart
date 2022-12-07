part of 'statistics_bloc.dart';

enum StatisticsStatus { loading, loaded, error }

class StatisticsState extends Equatable {
  StatisticsStatus status = StatisticsStatus.loading;
  List<Game> allGames = [];
  List<Team> allTeams = [];
  List<Player> allPlayers = [];
  Team selectedTeam = Team();
  List<Game> selectedTeamGames = [];
  List<Player> selectedTeamGamePlayers = [];
  Game selectedGame =
      Game(date: DateTime.now()); // TODO check if this is needed
  Player selectedPlayer = Player();
  int selectedStatScreenIndex = 0;
  Map<String, dynamic> statistics = {};
  TeamStatistics selectedTeamStats = TeamStatistics();

  //bool statistics_ready = false;
  bool heatmapShowsAttack = true;
  String selectedHeatmapParameter = "goals";

  StatisticsState({
    this.status = StatisticsStatus.loading,
    allGames,
    allTeams,
    allPlayers,
    selectedTeam,
    selectedTeamGames,
    selectedTeamGamePlayers,
    selectedGame,
    selectedPlayer,
    selectedStatScreenIndex,
    statistics,
    selectedTeamStats,
    heatmapShowsAttack,
    selectedHeatmapParameter,
  }) {
    if (allGames != null) {
      this.allGames = allGames;
    }
    if (allTeams != null) {
      this.allTeams = allTeams;
    }
    if (allPlayers != null) {
      this.allPlayers = allPlayers;
    }
    if (selectedTeam != null) {
      this.selectedTeam = selectedTeam;
    }
    if (selectedTeamGames != null) {
      this.selectedTeamGames = selectedTeamGames;
    }
    if (selectedTeamGamePlayers != null) {
      this.selectedTeamGamePlayers = selectedTeamGamePlayers;
    }
    if (selectedGame != null) {
      this.selectedGame = selectedGame;
    }
    if (selectedPlayer != null) {
      this.selectedPlayer = selectedPlayer;
    }
    if (statistics != null) {
      this.statistics = statistics;
    }
    if (selectedTeamStats != null) {
      this.selectedTeamStats = selectedTeamStats;
    }
    if (heatmapShowsAttack != null) {
      this.heatmapShowsAttack = heatmapShowsAttack;
    }
    if (selectedHeatmapParameter != null) {
      this.selectedHeatmapParameter = selectedHeatmapParameter;
    }
  }

  @override
  List<Object> get props => [
        this.status,
        this.allGames,
        this.allTeams,
        this.allPlayers,
        this.selectedTeam,
        this.selectedTeamGames,
        this.selectedTeamGamePlayers,
        this.selectedGame,
        this.selectedPlayer,
        this.selectedStatScreenIndex,
        this.statistics,
        this.selectedTeamStats,
        this.heatmapShowsAttack,
        this.selectedHeatmapParameter,
      ];

  StatisticsState copyWith({
    StatisticsStatus? status,
    List<Game>? allGames,
    List<Team>? allTeams,
    List<Player>? allPlayers,
    Team? selectedTeam,
    List<Game>? selectedTeamGames,
    List<Player>? selectedTeamGamePlayers,
    Game? selectedGame,
    Player? selectedPlayer,
    int? selectedStatScreenIndex,
    Map<String, dynamic>? statistics,
    TeamStatistics? selectedTeamStats,
    bool? heatmapShowsAttack,
    String? selectedHeatmapParameter,
  }) {
    return StatisticsState(
      status: status ?? this.status,
      allGames: allGames ?? this.allGames,
      allTeams: allTeams ?? this.allTeams,
      allPlayers: allPlayers ?? this.allPlayers,
      selectedTeam: selectedTeam ?? this.selectedTeam,
      selectedTeamGames: selectedTeamGames ?? this.selectedTeamGames,
      selectedTeamGamePlayers:
          selectedTeamGamePlayers ?? this.selectedTeamGamePlayers,
      selectedGame: selectedGame ?? this.selectedGame,
      selectedPlayer: selectedPlayer ?? this.selectedPlayer,
      selectedStatScreenIndex:
          selectedStatScreenIndex ?? this.selectedStatScreenIndex,
      statistics: statistics ?? this.statistics,
      selectedTeamStats: selectedTeamStats ?? this.selectedTeamStats,
      heatmapShowsAttack: heatmapShowsAttack ?? this.heatmapShowsAttack,
      selectedHeatmapParameter:
          selectedHeatmapParameter ?? this.selectedHeatmapParameter,
    );
  }
}

//class StatisticsInitial extends StatisticsState {}
