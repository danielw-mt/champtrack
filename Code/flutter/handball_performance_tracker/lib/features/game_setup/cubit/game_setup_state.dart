part of 'game_setup_cubit.dart';

enum GameSetupStep { gameSettings, playerSelection }

class GameSetupState extends Equatable {
  final GameSetupStep currentStep;
  final String opponent;
  final String location;
  DateTime date = DateTime.now();
  final int selectedTeamIndex;
  final bool isHomeGame;
  final bool attackIsLeft;
  List<Player> onFieldPlayers;

  GameSetupState({
    this.currentStep = GameSetupStep.gameSettings,
    this.opponent = '',
    this.location = '',
    date,
    this.selectedTeamIndex = 0,
    this.isHomeGame = true,
    this.attackIsLeft = true,
    this.onFieldPlayers = const [],
  }) {
    // make sure that the list is growable
    if (this.onFieldPlayers.isEmpty) {
      this.onFieldPlayers = [];
    }
    if (date != null) {
      this.date = date;
    }
  }

  GameSetupState copyWith({
    GameSetupStep? currentStep,
    String? opponent,
    String? location,
    DateTime? date,
    int? selectedTeamIndex,
    bool? isHomeGame,
    bool? attackIsLeft,
    List<Player>? onFieldPlayers,
  }) {
    return GameSetupState(
      currentStep: currentStep ?? this.currentStep,
      opponent: opponent ?? this.opponent,
      location: location ?? this.location,
      date: date ?? this.date,
      selectedTeamIndex: selectedTeamIndex ?? this.selectedTeamIndex,
      isHomeGame: isHomeGame ?? this.isHomeGame,
      attackIsLeft: attackIsLeft ?? this.attackIsLeft,
      onFieldPlayers: onFieldPlayers ?? this.onFieldPlayers,
    );
  }

  @override
  String toString() {
    return ''' GameSetupState {
      opponent: $opponent,
      location: $location,
      selectedTeamIndex: $selectedTeamIndex,
      isHomeGame: $isHomeGame,
      attackIsLeft: $attackIsLeft,
      onFieldPlayers: $onFieldPlayers,
      date: $date,
    }''';
  }

  @override
  List<Object> get props => [currentStep, opponent, location, selectedTeamIndex, isHomeGame, attackIsLeft, onFieldPlayers, date];
}
