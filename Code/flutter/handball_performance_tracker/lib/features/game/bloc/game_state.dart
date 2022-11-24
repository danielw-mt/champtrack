part of 'game_bloc.dart';

enum GameStatus { initial, running, paused, finished }

class GameState extends Equatable {
  final GameStatus status;
  final String opponent;
  final String location;
  DateTime? date = DateTime.now();
  Team selectedTeam = Team();
  final bool isHomeGame;
  final bool attackIsLeft;
  final bool attacking;
  List<Player> onFieldPlayers;
  final int ownScore;
  final int opponentScore;
  StopWatchTimer stopWatchTimer = StopWatchTimer();
  List<GameAction> gameActions = [];
  Player playerToChange = Player();

  // Some of these fields can only be set in this constructor like date, opponent or location because they get passed from the previous screen
  GameState(
      {this.status = GameStatus.initial,
      this.opponent = '',
      this.location = '',
      this.date,
      selectedTeam,
      this.isHomeGame = true,
      this.attackIsLeft = true,
      this.attacking = true,
      this.onFieldPlayers = const [],
      this.ownScore = 0,
      this.opponentScore = 0,
      stopWatchTimer,
      this.gameActions = const [],
      playerToChange}) {
    // make sure that the list is growable
    if (this.onFieldPlayers.isEmpty) {
      this.onFieldPlayers = [];
    }
    if (this.gameActions.isEmpty) {
      this.gameActions = [];
    }
    if (stopWatchTimer != null) {
      this.stopWatchTimer = stopWatchTimer;
    }
    if (selectedTeam != null) {
      this.selectedTeam = selectedTeam;
    }
    if (playerToChange != null) {
      this.playerToChange = playerToChange;
    }
  }

  GameState copyWith({
    GameStatus? status,
    bool? attackIsLeft,
    bool? attacking,
    List<Player>? onFieldPlayers,
    int? ownScore,
    int? opponentScore,
    StopWatchTimer? stopWatchTimer,
    List<GameAction>? gameActions,
  }) {
    return GameState(
      status: status ?? this.status,
      attackIsLeft: attackIsLeft ?? this.attackIsLeft,
      attacking: attacking ?? this.attacking,
      onFieldPlayers: onFieldPlayers ?? this.onFieldPlayers,
      ownScore: ownScore ?? this.ownScore,
      opponentScore: opponentScore ?? this.opponentScore,
      stopWatchTimer: stopWatchTimer ?? this.stopWatchTimer,
      gameActions: gameActions ?? this.gameActions,
      // these properties cannot be changed after game initialization so they can only be set in the constructor but not in the copyWith method
      opponent: this.opponent,
      location: this.location,
      date: this.date,
      selectedTeam: this.selectedTeam,
      isHomeGame: this.isHomeGame,
    );
  }

  @override
  List<Object> get props =>
      [this.status, this.attackIsLeft, this.attacking, this.onFieldPlayers, this.ownScore, this.opponentScore, this.stopWatchTimer, this.gameActions];
}
