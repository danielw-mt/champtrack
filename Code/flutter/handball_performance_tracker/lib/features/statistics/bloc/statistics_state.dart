part of 'statistics_bloc.dart';

class StatisticsState extends Equatable {
  List<Game> allGames = [];
  List<Team> allTeams = [];
  List<Player> allPlayers = [];
  Team selectedTeam = Team();
  List<Game> selectedTeamGames = [];
  List<Player> selectedTeamGamePlayers = [];
  Game selectedGame =
      Game(date: DateTime.now()); // TODO check if this is needed
  Player selectedPlayer = Player();
  int selectedStatScreenIndex;
  Map<String, dynamic> statistics = {};
  //bool statistics_ready = false;

  StatisticsState({
    allGames,
    allTeams,
    allPlayers,
    selectedTeam,
    selectedTeamGames,
    selectedTeamGamePlayers,
    selectedGame,
    selectedPlayer,
    this.selectedStatScreenIndex = 2,
    statistics,
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
  }

  @override
  List<Object> get props => [
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
      ];

  StatisticsState copyWith({
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
  }) {
    return StatisticsState(
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
    );
  }
}

//class StatisticsInitial extends StatisticsState {}
