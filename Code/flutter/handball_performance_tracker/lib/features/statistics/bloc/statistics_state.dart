part of 'statistics_bloc.dart';

class StatisticsState extends Equatable {
  Team selectedTeam = Team();
  Game selectedGame =
      Game(date: DateTime.now()); // TODO check if this is needed
  Player selectedPlayer = Player();
  int selectedStatScreenIndex;
  StatisticsState({
    selectedTeam,
    selectedGame,
    selectedPlayer,
    this.selectedStatScreenIndex = 2,
  }) {
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
        this.selectedTeam,
        this.selectedGame,
        this.selectedPlayer,
        this.selectedStatScreenIndex
      ];

  StatisticsState copyWith({
    Team? selectedTeam,
    Game? selectedGame,
    Player? selectedPlayer,
    int? selectedStatScreenIndex,
  }) {
    return StatisticsState(
      selectedTeam: selectedTeam ?? this.selectedTeam,
      selectedGame: selectedGame ?? this.selectedGame,
      selectedPlayer: selectedPlayer ?? this.selectedPlayer,
      selectedStatScreenIndex:
          selectedStatScreenIndex ?? this.selectedStatScreenIndex,
    );
  }
}

//class StatisticsInitial extends StatisticsState {}
