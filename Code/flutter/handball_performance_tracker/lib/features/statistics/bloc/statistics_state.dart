part of 'statistics_bloc.dart';

class StatisticsState extends Equatable {
  List<Game> allGames = [];
  Team selectedTeam = Team();
  Game selectedGame =
      Game(date: DateTime.now()); // TODO check if this is needed
  Player selectedPlayer = Player();
  int selectedStatScreenIndex;
  
  StatisticsState({
    allGames,
    selectedTeam,
    selectedGame,
    selectedPlayer,
    this.selectedStatScreenIndex = 2,
  }) {
    if (allGames != null) {
      this.allGames = allGames;
    }
    if (selectedTeam != null) {
      this.selectedTeam = selectedTeam;
    }
    if (selectedGame != null) {
      this.selectedGame = selectedGame;
    }
    if (selectedPlayer != null) {
      this.selectedPlayer = selectedPlayer;
    }
  }

  @override
  List<Object> get props => [
    this.allGames,
        this.selectedTeam,
        this.selectedGame,
        this.selectedPlayer,
        this.selectedStatScreenIndex
      ];

  StatisticsState copyWith({
    List<Game>? allGames,
    Team? selectedTeam,
    Game? selectedGame,
    Player? selectedPlayer,
    int? selectedStatScreenIndex,
  }) {
    return StatisticsState(
      allGames: allGames ?? this.allGames,
      selectedTeam: selectedTeam ?? this.selectedTeam,
      selectedGame: selectedGame ?? this.selectedGame,
      selectedPlayer: selectedPlayer ?? this.selectedPlayer,
      selectedStatScreenIndex:
          selectedStatScreenIndex ?? this.selectedStatScreenIndex,
    );
  }
}

//class StatisticsInitial extends StatisticsState {}
