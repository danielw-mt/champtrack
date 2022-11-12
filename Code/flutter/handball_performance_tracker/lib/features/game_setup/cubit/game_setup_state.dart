part of 'game_setup_cubit.dart';

enum GameSetupStep { gameSettings, playerSelection }

class GameSetupState extends Equatable {
  final GameSetupStep currentStep;
  final String opponent;
  final String location;
  DateTime? date = DateTime.now();
  final int selectedTeamIndex;
  final bool isHomeGame;
  final bool attackIsLeft;
  List<Player>? onFieldPlayers;

  GameSetupState({
    this.currentStep = GameSetupStep.gameSettings,
    this.opponent = '',
    this.location = '',
    this.date,
    this.selectedTeamIndex = 0,
    this.isHomeGame = true,
    this.attackIsLeft = true,
    this.onFieldPlayers,
  });

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
    }''';
  }

  @override
  List<Object> get props => [currentStep, opponent, location, selectedTeamIndex, isHomeGame, attackIsLeft];
}
