part of 'game_bloc.dart';

enum GameStatus { initial, running, paused, finished }

enum WorkflowStep {
  closed,
  actionMenuOffense,
  actionMenuDefense,
  actionMenuGoalKeeper,
  playerSelection,
  assistSelection,
  sevenMeterPrompt,
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
  List<Player> onFieldPlayers = [];
  final int ownScore;
  final int opponentScore;
  StopWatchTimer stopWatchTimer = StopWatchTimer();
  List<GameAction> gameActions = [];
  List<String> lastClickedLocation = [];
  List<double> lastClickedCoordinates = [];
  Map<Player, Timer> penalties = Map<Player, Timer>();
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
    List<Player> onFieldPlayers = const [],
    this.ownScore = 0,
    this.opponentScore = 0,
    stopWatchTimer,
    List<GameAction> gameActions = const [],
    List<String> lastClickedLocation = const [],
    List<double> lastClickedCoordinates = const [],
    Map<Player, Timer> penalties = const {},
    substitutionTarget,
    substitutionPlayer,
    sevenMeterExecutor,
    sevenMeterGoalkeeper,
    this.workflowStep = WorkflowStep.closed,
  }) {
    // make sure that the list is growable
    if (!onFieldPlayers.isEmpty) {
      this.onFieldPlayers = onFieldPlayers;
    } else {
      this.onFieldPlayers = [];
    }
    if (!gameActions.isEmpty) {
      this.gameActions = gameActions;
    } else {
      this.gameActions = [];
    }
    if (stopWatchTimer != null) {
      this.stopWatchTimer = stopWatchTimer;
    }
    if (selectedTeam != null) {
      this.selectedTeam = selectedTeam;
    }
    if (!lastClickedLocation.isEmpty) {
      this.lastClickedLocation = lastClickedLocation;
    } else {
      this.lastClickedLocation = [];
    }
    if (!lastClickedCoordinates.isEmpty) {
      this.lastClickedCoordinates = lastClickedCoordinates;
    } else {
      this.lastClickedCoordinates = [];
    }
    if (!penalties.isEmpty) {
      this.penalties = penalties;
    } else {
      this.penalties = Map<Player, Timer>();
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
    List<double>? lastClickedCoordinates,
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
      documentReference: this.documentReference,
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
      lastClickedCoordinates: lastClickedCoordinates ?? this.lastClickedCoordinates,
      penalties: penalties ?? this.penalties,
      substitutionTarget: substitutionTarget ?? this.substitutionTarget,
      substitutionPlayer: substitutionPlayer ?? this.substitutionPlayer,
      sevenMeterExecutor: sevenMeterExecutor ?? this.sevenMeterExecutor,
      sevenMeterGoalkeeper: sevenMeterGoalkeeper ?? this.sevenMeterGoalkeeper,
      workflowStep: workflowStep ?? this.workflowStep,
    );
  }

  @override
  String toString() {
    return "GameState {status: $status, +\n " +
        "attackIsLeft: $attackIsLeft, +\n " +
        "attacking: $attacking, +\n " +
        // "onFieldPlayers: $onFieldPlayers, +\n " +
        "ownScore: $ownScore, +\n " +
        "opponentScore: $opponentScore, +\n " +
        "stopWatchTimer: $stopWatchTimer, +\n " +
        "gameActions: $gameActions, +\n " +
        "lastClickedLocation: $lastClickedLocation, +\n " +
        "lastClickedCoordinates: $lastClickedCoordinates, +\n " +
        "penalties: $penalties, +\n " +
        "substitutionTarget: $substitutionTarget, +\n " +
        "substitutionPlayer: $substitutionPlayer, +\n " +
        "sevenMeterExecutor: $sevenMeterExecutor, +\n " +
        "sevenMeterGoalkeeper: $sevenMeterGoalkeeper, +\n " +
        "workflowStep: $workflowStep, +\n " +
        "}";
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
        this.gameActions.hashCode,
        this.lastClickedLocation,
        this.lastClickedCoordinates,
        this.penalties.hashCode,
        this.substitutionTarget,
        this.substitutionPlayer,
        this.sevenMeterExecutor,
        this.sevenMeterGoalkeeper,
        this.workflowStep,
      ];
}
