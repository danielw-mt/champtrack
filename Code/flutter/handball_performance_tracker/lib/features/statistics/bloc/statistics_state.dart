part of 'statistics_bloc.dart';

enum StatisticsStatus {initial, loading, loaded, error }

class StatisticsState extends Equatable {
  StatisticsStatus status = StatisticsStatus.initial;
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
  int teamQuotaIndex = 0;
  int playerQuotaIndex = 0;
  Map<String, dynamic> statistics = {};
  TeamStatistics selectedTeamStats = TeamStatistics();
  PlayerStatistics selectedPlayerStats = PlayerStatistics();
  bool pieChartView = true;

  //bool statistics_ready = false;
  bool heatmapShowsAttack = true;
  String selectedHeatmapParameter = "goals";
  String selectedTeamPerformanceParameter = "";
  String selectedPlayerPerformanceParameter = "goals";

  StatisticsState({
    this.status = StatisticsStatus.initial,
    allGames,
    allTeams,
    allPlayers,
    selectedTeam,
    selectedTeamGames,
    selectedTeamGamePlayers,
    selectedGame,
    selectedPlayer,
    selectedStatScreenIndex,
    teamQuotaIndex,
    playerQuotaIndex,
    statistics,
    selectedTeamStats,
    selectedPlayerStats,
    heatmapShowsAttack,
    selectedHeatmapParameter,
    selectedTeamPerformanceParameter,
    selectedPlayerPerformanceParameter,
    pieChartView,
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
    if (selectedStatScreenIndex != null) {
      this.selectedStatScreenIndex = selectedStatScreenIndex;
    }
    if (teamQuotaIndex != null) {
      this.teamQuotaIndex = teamQuotaIndex;
    }
    if (playerQuotaIndex != null) {
      this.playerQuotaIndex = playerQuotaIndex;
    }
    if (statistics != null) {
      this.statistics = statistics;
    }
    if (selectedTeamStats != null) {
      this.selectedTeamStats = selectedTeamStats;
    }
    if (selectedPlayerStats != null) {
      this.selectedPlayerStats = selectedPlayerStats;
    }
    if (heatmapShowsAttack != null) {
      this.heatmapShowsAttack = heatmapShowsAttack;
    }
    if (selectedHeatmapParameter != null) {
      this.selectedHeatmapParameter = selectedHeatmapParameter;
    }
    if (selectedTeamPerformanceParameter != null) {
      this.selectedTeamPerformanceParameter = selectedTeamPerformanceParameter;
    }
    if (selectedPlayerPerformanceParameter != null) {
      this.selectedPlayerPerformanceParameter =
          selectedPlayerPerformanceParameter;
    }
    if (pieChartView != null) {
      this.pieChartView = pieChartView;
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
        this.teamQuotaIndex,
        this.playerQuotaIndex,
        this.statistics,
        this.selectedTeamStats,
        this.selectedPlayerStats,
        this.heatmapShowsAttack,
        this.selectedHeatmapParameter,
        this.selectedTeamPerformanceParameter,
        this.selectedPlayerPerformanceParameter,
        this.pieChartView,
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
    int? teamQuotaIndex,
    int? playerQuotaIndex,
    Map<String, dynamic>? statistics,
    TeamStatistics? selectedTeamStats,
    PlayerStatistics? selectedPlayerStats,
    bool? heatmapShowsAttack,
    String? selectedHeatmapParameter,
    String? selectedTeamPerformanceParameter,
    String? selectedPlayerPerformanceParameter,
    bool? pieChartView,
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
      teamQuotaIndex: teamQuotaIndex ?? this.teamQuotaIndex,
      playerQuotaIndex: playerQuotaIndex ?? this.playerQuotaIndex,
      statistics: statistics ?? this.statistics,
      selectedTeamStats: selectedTeamStats ?? this.selectedTeamStats,
      selectedPlayerStats: selectedPlayerStats ?? this.selectedPlayerStats,
      heatmapShowsAttack: heatmapShowsAttack ?? this.heatmapShowsAttack,
      selectedHeatmapParameter:
          selectedHeatmapParameter ?? this.selectedHeatmapParameter,
      selectedTeamPerformanceParameter: selectedTeamPerformanceParameter ??
          this.selectedTeamPerformanceParameter,
      selectedPlayerPerformanceParameter: selectedPlayerPerformanceParameter ??
          this.selectedPlayerPerformanceParameter,
      pieChartView: pieChartView ?? this.pieChartView,
    );
  }
}

//class StatisticsInitial extends StatisticsState {}
