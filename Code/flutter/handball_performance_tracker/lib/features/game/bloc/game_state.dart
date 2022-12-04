part of 'game_bloc.dart';

enum GameStatus { initial, running, paused, finished }

enum WorkflowStep {
  closed,
  actionMenuOffense,
  actionMenuDefense,
  actionMenuGoalKeeper,
  playerSelection,
  assistSelection,
  sevenMeterScorerSelection,
  sevenMeterFoulerSelection,
  sevenMeterExecutorSelection,
  substitutionTargetSelection,
  sevenMeterGoalkeeperSelection,
  sevenMeterDefenseResult,
  sevenMeterOffenseResult,
  forceClose
}

class GameState extends Equatable {
  // fields set during game creation
  final GameStatus status;
  final String opponent;
  final String location;
  DateTime? date = DateTime.now();
  Team selectedTeam = Team();
  final bool isHomeGame;
  final DocumentReference? documentReference;

  // fields set during game
  final bool attackIsLeft;
  final bool attacking;
  List<Player> onFieldPlayers;
  final int ownScore;
  final int opponentScore;
  StopWatchTimer stopWatchTimer = StopWatchTimer();
  List<GameAction> gameActions = [];
  List<String> lastClickedLocation = [];
  Map<Player, Timer> penalties = {};
  Player substitutionTarget = Player();
  Player substitutionPlayer = Player();
  Player sevenMeterExecutor = Player();
  Player sevenMeterGoalkeeper = Player();
  WorkflowStep workflowStep = WorkflowStep.closed;

  // Some of these fields can only be set in this constructor like date, opponent or location because they get passed from the previous screen
  GameState({
    // initial constructor fields (only set once)
    this.opponent = '',
    this.location = '',
    this.date,
    selectedTeam,
    this.isHomeGame = true,
    this.documentReference = null,
    // constructor fields changed during game
    this.status = GameStatus.initial,
    this.attackIsLeft = true,
    this.attacking = true,
    this.onFieldPlayers = const [],
    this.ownScore = 0,
    this.opponentScore = 0,
    stopWatchTimer,
    this.gameActions = const [],
    this.lastClickedLocation = const [],
    this.penalties = const {},
    substitutionTarget,
    substitutionPlayer,
    sevenMeterExecutor,
    sevenMeterGoalkeeper,
    this.workflowStep = WorkflowStep.closed,
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
    if (this.lastClickedLocation.isEmpty) {
      this.lastClickedLocation = [];
    }
    if (this.penalties.isEmpty) {
      this.penalties = {};
    }
    if (substitutionTarget != null) {
      this.substitutionTarget = substitutionTarget;
    }
    if (substitutionPlayer != null) {
      this.substitutionPlayer = substitutionPlayer;
    }
    if (sevenMeterExecutor != null) {
      this.sevenMeterExecutor = sevenMeterExecutor;
    }
    if (sevenMeterGoalkeeper != null) {
      this.sevenMeterGoalkeeper = sevenMeterGoalkeeper;
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
    Map<Player, Timer>? penalties,
    Player? substitutionTarget,
    Player? substitutionPlayer,
    Player? sevenMeterExecutor,
    Player? sevenMeterGoalkeeper,
    WorkflowStep? workflowStep,
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
      penalties: penalties ?? this.penalties,
      substitutionTarget: substitutionTarget ?? this.substitutionTarget,
      substitutionPlayer: substitutionPlayer ?? this.substitutionPlayer,
      sevenMeterExecutor: sevenMeterExecutor ?? this.sevenMeterExecutor,
      sevenMeterGoalkeeper: sevenMeterGoalkeeper ?? this.sevenMeterGoalkeeper,
      workflowStep: workflowStep ?? this.workflowStep,
    );
  }

  @override
  List<Object> get props => [
        this.status,
        this.attackIsLeft,
        this.attacking,
        this.onFieldPlayers.hashCode,
        this.ownScore,
        this.opponentScore,
        this.stopWatchTimer,
        this.gameActions,
        this.lastClickedLocation,
        this.penalties,
        this.substitutionTarget,
        this.substitutionPlayer,
        this.sevenMeterExecutor,
        this.sevenMeterGoalkeeper,
        this.workflowStep
      ];
}
