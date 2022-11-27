part of 'game_bloc.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object> get props => [];
}

class InitializeGame extends GameEvent {
  List<Player> onFieldPlayers = [];
  Team selectedTeam = Team();
  String opponent = "";
  String location = "";
  DateTime date = DateTime.now();
  bool isHomeGame = true;
  bool attackIsLeft = true;

  InitializeGame({onFieldPlayers, selectedTeam, this.opponent = "", this.location = "", date, this.isHomeGame = true, this.attackIsLeft = true}) {
    if (onFieldPlayers != null && onFieldPlayers.length > 0) {
      this.onFieldPlayers = onFieldPlayers;
    }
    if (selectedTeam != null) {
      this.selectedTeam = selectedTeam;
    }
    if (date != null) {
      this.date = date;
    }
  }
}

class StartGame extends GameEvent {}

class PauseGame extends GameEvent {}

class UnPauseGame extends GameEvent {}

class ChangeTime extends GameEvent {
  final int offset;

  ChangeTime({required this.offset});
}

class SetSeconds extends GameEvent {
  final int seconds;

  SetSeconds({required this.seconds});
}

class SetMinutes extends GameEvent {
  final int minutes;

  SetMinutes({required this.minutes});
}

class QuitGame extends GameEvent {}

/// Switch from defense to offense
class SwipeField extends GameEvent {
  final bool isLeft;

  SwipeField({required this.isLeft});
}

/// Change the field programmatically
class SwitchField extends GameEvent {
  // TODO implement this. Basically set the field to the opposite of the current field

  SwitchField();
}

/// Change the side our goal is on. I.e. half time
class SwitchSides extends GameEvent {}

/// Changing a player on the field
class SubstitutePlayer extends GameEvent {
  final Player substitutionPlayer;
  final Player toBeSubstitutedPlayer;

  SubstitutePlayer({required this.substitutionPlayer, required this.toBeSubstitutedPlayer});
}

/// Clicking onto the game field
class RegisterClickOnField extends GameEvent {
  final Offset position;
  final bool fieldIsLeft;

  RegisterClickOnField({required this.position, required this.fieldIsLeft});
}

/// Click on an action in the action menu
class RegisterAction extends GameEvent {
  final String actionTag;
  final String actionContext;

  RegisterAction({required this.actionTag, required this.actionContext});
}

/// Selecting a player in the player menu
class RegisterPlayerSelection extends GameEvent {
  final Player player;
  final bool isSubstitute;

  RegisterPlayerSelection({required this.player, required this.isSubstitute});
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

class UpdatePlayerMenuHintText extends GameEvent {
  final String hintText;

  UpdatePlayerMenuHintText({required this.hintText});
}

class UpdateActionMenuHintText extends GameEvent {
  final String hintText;

  UpdateActionMenuHintText({required this.hintText});
}

class ChangeMenuStatus extends GameEvent {
  final MenuStatus menuStatus;

  ChangeMenuStatus({required this.menuStatus});
}
