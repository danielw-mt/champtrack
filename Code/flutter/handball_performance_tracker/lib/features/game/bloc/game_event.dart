part of 'game_bloc.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object> get props => [];
}

class InitializeGame extends GameEvent {
  final Game? game;

  InitializeGame({this.game});
}

class StartGame extends GameEvent {}

class PauseGame extends GameEvent {}

class UnPauseGame extends GameEvent {}

class QuitGame extends GameEvent {}

/// Switch from defense to offense
class SwipeField extends GameEvent {
  final bool isLeft;

  SwipeField({required this.isLeft});
}

/// Change the side our goal is on. I.e. half time
class SwitchSides extends GameEvent {}

/// Changing a player on the field
class SwitchPlayer extends GameEvent {
  final List<Player> newOnFieldPlayers;

  SwitchPlayer({required this.newOnFieldPlayers});
}

/// Clicking onto the game field
class RegisterClickOnField extends GameEvent {
  final Offset position;

  RegisterClickOnField({required this.position});
}

/// Click on an action in the action menu
class RegisterAction extends GameEvent {
  final GameAction action;

  RegisterAction({required this.action});
}

/// Selecting a player in the player menu
class RegisterClickOnPlayer extends GameEvent {
  final Player player;

  RegisterClickOnPlayer({required this.player});
}

/// Clicking on our own goal
class RegisterClickOnGoal extends GameEvent {}

class DeleteFeedAction extends GameEvent {
  final GameAction action;

  DeleteFeedAction({required this.action});
}

class ChangeScore extends GameEvent {
  final int score;
  final bool isOwnScore;

  ChangeScore({required this.score, required this.isOwnScore});
}
