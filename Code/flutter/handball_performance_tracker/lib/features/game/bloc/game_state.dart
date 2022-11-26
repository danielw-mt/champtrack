part of 'game_bloc.dart';

enum GameStatus { initial, running, paused, finished }

// we need these Menu Statuses to control the dialogs from the bloc. See game view for how these are used
enum MenuStatus { closed, actionMenu, playerMenu, sevenMeterMenu, forceClose, loadPlayerMenu }

class GameState extends Equatable {
  // fields set during game creation
  final GameStatus status;
  final String opponent;
  final String location;
  DateTime? date = DateTime.now();
  Team selectedTeam = Team();
  final bool isHomeGame;

  // fields set during game
  final bool attackIsLeft;
  final bool attacking;
  List<Player> onFieldPlayers;
  final int ownScore;
  final int opponentScore;
  StopWatchTimer stopWatchTimer = StopWatchTimer();
  List<GameAction> gameActions = [];
  Player playerToChange = Player();
  List<String> lastClickedLocation = [];
  String actionMenuHintText = '';
  String playerMenuHintText = '';
  // Player previousClickedPlayer = Player();
  List<Player> penalizedPlayers = [];
  MenuStatus menuStatus = MenuStatus.closed;
  bool assistAvailable = false;

  // Some of these fields can only be set in this constructor like date, opponent or location because they get passed from the previous screen
  GameState({
    // initial constructor fields (only set once)
    this.opponent = '',
    this.location = '',
    this.date,
    selectedTeam,
    this.isHomeGame = true,
    // constructor fields changed during game
    this.status = GameStatus.initial,
    this.attackIsLeft = true,
    this.attacking = true,
    this.onFieldPlayers = const [],
    this.ownScore = 0,
    this.opponentScore = 0,
    stopWatchTimer,
    this.gameActions = const [],
    playerToChange,
    this.lastClickedLocation = const [],
    this.actionMenuHintText = '',
    this.playerMenuHintText = '',
    // previousClickedPlayer,
    this.penalizedPlayers = const [],
    this.menuStatus = MenuStatus.closed,
    this.assistAvailable = false,
  }) {
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
    if (this.lastClickedLocation.isEmpty) {
      this.lastClickedLocation = [];
    }
    // if (previousClickedPlayer != null) {
    //   this.previousClickedPlayer = previousClickedPlayer;
    // }
    if (this.penalizedPlayers.isEmpty) {
      this.penalizedPlayers = [];
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
    List<String>? lastClickedLocation,
    String? actionMenuHintText,
    String? playerMenuHintText,
    // Player? previousClickedPlayer,
    List<Player>? penalizedPlayers,
    MenuStatus? menuStatus,
    bool? assistAvailable,
  }) {
    return GameState(
      // these properties cannot be changed after game initialization so they can only be set in the constructor but not in the copyWith method
      // thats why we don't have them in the parameters and just return their current value
      opponent: this.opponent,
      location: this.location,
      date: this.date,
      selectedTeam: this.selectedTeam,
      isHomeGame: this.isHomeGame,
      // these properties can be changed during the game
      status: status ?? this.status,
      attackIsLeft: attackIsLeft ?? this.attackIsLeft,
      attacking: attacking ?? this.attacking,
      onFieldPlayers: onFieldPlayers ?? this.onFieldPlayers,
      ownScore: ownScore ?? this.ownScore,
      opponentScore: opponentScore ?? this.opponentScore,
      stopWatchTimer: stopWatchTimer ?? this.stopWatchTimer,
      gameActions: gameActions ?? this.gameActions,
      lastClickedLocation: lastClickedLocation ?? this.lastClickedLocation,
      playerToChange: this.playerToChange,
      actionMenuHintText: actionMenuHintText ?? this.actionMenuHintText,
      playerMenuHintText: playerMenuHintText ?? this.playerMenuHintText,
      // previousClickedPlayer: previousClickedPlayer ?? this.previousClickedPlayer,
      penalizedPlayers: penalizedPlayers ?? this.penalizedPlayers,
      menuStatus: menuStatus ?? this.menuStatus,
      assistAvailable: assistAvailable ?? this.assistAvailable,
    );
  }

  @override
  List<Object> get props => [
        this.status,
        this.attackIsLeft,
        this.attacking,
        this.onFieldPlayers,
        this.ownScore,
        this.opponentScore,
        this.stopWatchTimer,
        this.gameActions,
        this.lastClickedLocation,
        this.playerToChange,
        this.actionMenuHintText,
        this.playerMenuHintText,
        // this.previousClickedPlayer,
        this.penalizedPlayers,
        this.menuStatus,
        this.assistAvailable,
      ];
}
