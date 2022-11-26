import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/gestures.dart';
import 'package:handball_performance_tracker/data/models/models.dart';
import 'package:handball_performance_tracker/features/game/widgets/action_menu/action_menu.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:handball_performance_tracker/core/constants/game_actions.dart';
import 'package:handball_performance_tracker/core/constants/strings_game_screen.dart';
import 'package:handball_performance_tracker/core/constants/positions.dart';
import 'game_field_math.dart';
part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(GameState()) {
    on<InitializeGame>((event, emit) async {
      // TODO create game in repository

      // create the initial game state. Only overload the necessary fields that are not already defined as necessary in the constructor
      emit(GameState(
        opponent: event.opponent,
        location: event.location,
        date: event.date,
        selectedTeam: event.selectedTeam,
        isHomeGame: event.isHomeGame,
        attackIsLeft: event.attackIsLeft,
        onFieldPlayers: event.onFieldPlayers,
      ));
    });

    on<SwipeField>((event, emit) async {
      if (state.attackIsLeft && event.isLeft || !state.attackIsLeft && !event.isLeft) {
        emit(state.copyWith(attacking: true));
      } else {
        emit(state.copyWith(attacking: false));
      }
    });

    on<StartGame>((event, emit) {
      // TODO update game in repository
      StopWatchTimer stopWatchTimer = state.stopWatchTimer;
      stopWatchTimer.onExecute.add(StopWatchExecute.start);
      emit(state.copyWith(status: GameStatus.running, stopWatchTimer: stopWatchTimer));
    });

    on<PauseGame>((event, emit) {
      StopWatchTimer stopWatchTimer = state.stopWatchTimer;
      stopWatchTimer.onExecute.add(StopWatchExecute.stop);
      emit(state.copyWith(status: GameStatus.paused, stopWatchTimer: stopWatchTimer));
    });

    on<UnPauseGame>((event, emit) {
      StopWatchTimer stopWatchTimer = state.stopWatchTimer;
      stopWatchTimer.onExecute.add(StopWatchExecute.start);
      emit(state.copyWith(status: GameStatus.running, stopWatchTimer: stopWatchTimer));
    });

    /// Change time by the given offset
    on<ChangeTime>((event, emit) {
      StopWatchTimer stopWatchTimer = state.stopWatchTimer;
      int currentTime = stopWatchTimer.rawTime.value;
      // make sure the timer can't go negative
      if (currentTime < -event.offset && event.offset < 0) return;
      stopWatchTimer.clearPresetTime();
      if (stopWatchTimer.isRunning) {
        stopWatchTimer.onExecute.add(StopWatchExecute.reset);
        stopWatchTimer.setPresetTime(mSec: currentTime + event.offset);
        stopWatchTimer.onExecute.add(StopWatchExecute.start);
      } else {
        stopWatchTimer.onExecute.add(StopWatchExecute.reset);
        stopWatchTimer.setPresetTime(mSec: currentTime + event.offset);
      }
      emit(state.copyWith(stopWatchTimer: stopWatchTimer));
    });

    /// Set the seconds of the timer to the given value
    on<SetSeconds>((event, emit) {
      StopWatchTimer stopWatchTimer = state.stopWatchTimer;
      // get current minutes
      int currentMins = (stopWatchTimer.rawTime.value / 60000).floor();
      // make sure the timer can't go negative
      if (event.seconds < 0) return;
      stopWatchTimer.clearPresetTime();
      if (stopWatchTimer.isRunning) {
        stopWatchTimer.onExecute.add(StopWatchExecute.reset);
        stopWatchTimer.setPresetSecondTime(currentMins * 60 + event.seconds);
        stopWatchTimer.onExecute.add(StopWatchExecute.start);
      } else {
        stopWatchTimer.onExecute.add(StopWatchExecute.reset);
        stopWatchTimer.setPresetSecondTime(currentMins * 60 + event.seconds);
      }
    });

    /// Set the minutes of the timer to the given value
    on<SetMinutes>((event, emit) {
      StopWatchTimer stopWatchTimer = state.stopWatchTimer;
      // get current seconds
      int currentSecs = (stopWatchTimer.rawTime.value % 60000 / 1000).floor();
      // make sure the timer can't go negative
      if (event.minutes < 0) return;
      stopWatchTimer.clearPresetTime();
      if (stopWatchTimer.isRunning) {
        stopWatchTimer.onExecute.add(StopWatchExecute.reset);
        stopWatchTimer.setPresetSecondTime(event.minutes * 60 + currentSecs);
        stopWatchTimer.onExecute.add(StopWatchExecute.start);
      } else {
        stopWatchTimer.onExecute.add(StopWatchExecute.reset);
        stopWatchTimer.setPresetSecondTime(event.minutes * 60 + currentSecs);
      }
    });

    on<RegisterClickOnField>((event, emit) {
      // set last clicked location
      List<String> lastLocation = SectorCalc(event.fieldIsLeft).calculatePosition(event.position);
      emit(state.copyWith(lastClickedLocation: lastLocation));
    });

    on<RegisterAction>((event, emit) {
      DateTime dateTime = DateTime.now();
      int unixTime = dateTime.toUtc().millisecondsSinceEpoch;
      int secondsSinceGameStart = state.stopWatchTimer.secondTime.value;
      // get most recent game id from game state
      // TODO: get game id from gameBloc
      String currentGameId = "";
      GameAction action = GameAction(
          teamId: state.selectedTeam.id!,
          gameId: currentGameId,
          context: event.actionContext,
          tag: event.actionTag,
          throwLocation: List.from(state.lastClickedLocation.cast<String>()),
          timestamp: unixTime,
          relativeTime: secondsSinceGameStart);
      
      if (event.actionTag == paradeTag || event.actionTag == emptyGoalTag || event.actionTag == goalOpponentTag) {
//         gameBloc.add(SwitchField());
      }
      // if an action inside goalkeeper menu that does not correspond to the opponent was hit try to assign this action directly to the goalkeeper
      if (event.actionContext == actionContextGoalkeeper && event.actionTag != goalOpponentTag && event.actionTag != emptyGoalTag) {
        List<Player> goalKeepers = [];
        state.onFieldPlayers.forEach((Player player) {
          if (player.positions.contains(goalkeeperPos)) {
            goalKeepers.add(player);
          }
        });
        // if there is only one player with a goalkeeper position on field right now assign the action to him
        if (goalKeepers.length == 1) {
          // we know the player id so we assign it here. For all other actions it is assigned in the player menu
          action.playerId = goalKeepers[0].id!;
          // TODO implement closing the dialog
          // Navigator.pop(context);
        // if there is more than one player with a goalkeeper position on field right now open the player menu
        } else {
          state.playerMenuHintText = StringsGameScreen.lChooseGoalkeeper;
          
          // TODO implement closing the action menu
          //Navigator.pop(context);
          // TODO call player menu
          // callPlayerMenu(context);
        }
      }

    });
  }
}


// void handleAction(String actionTag) async {
//       DateTime dateTime = DateTime.now();
//       int unixTime = dateTime.toUtc().millisecondsSinceEpoch;
//       int secondsSinceGameStart = gameBloc.state.stopWatchTimer.secondTime.value;
//       // get most recent game id from game state
//       // TODO: get game id from gameBloc
//       String currentGameId = "";

//       // switch field side after hold of goalkeeper
//       if (actionTag == paradeTag || actionTag == emptyGoalTag || actionTag == goalOpponentTag) {
//         gameBloc.add(SwitchField());
//       }
//       GameAction action = GameAction(
//           teamId: gameBloc.state.selectedTeam.id!,
//           gameId: currentGameId,
//           context: actionContext,
//           tag: actionTag,
//           throwLocation: List.from(gameBloc.state.lastClickedLocation.cast<String>()),
//           timestamp: unixTime,
//           relativeTime: secondsSinceGameStart);
//       // store most recent action id in game state for the player menu
//       // when a player was selected in that menu the action document can be
//       // updated in firebase with their player_id using the action_id

//       // if an action inside goalkeeper menu that does not correspond to the opponent was hit try to assign this action directly to the goalkeeper
//       if (actionContext == actionContextGoalkeeper && actionTag != goalOpponentTag && actionTag != emptyGoalTag) {
//         List<Player> goalKeepers = [];
//         gameBloc.state.onFieldPlayers.forEach((Player player) {
//           if (player.positions.contains(goalkeeperPos)) {
//             goalKeepers.add(player);
//           }
//         });
//         // if there is only one player with a goalkeeper position on field right now assign the action to him
//         if (goalKeepers.length == 1) {
//           // we know the player id so we assign it here. For all other actions it is assigned in the player menu
//           action.playerId = goalKeepers[0].id!;
//           gameBloc.add(RegisterAction(actionTag: actionTag));
//           Navigator.pop(context);
//           // if there is more than one player with a goalkeeper position on field right now
//         } else {
//           gameBloc.add(UpdatePlayerMenuHintText(hintText: StringsGameScreen.lChooseGoalkeeper));
//           gameBloc.add(RegisterAction(actionTag: actionTag));
//           Navigator.pop(context);
//           // TODO call player menu
//           // callPlayerMenu(context);
//         }
//       }
//       if (action.tag == goalTag) {}
//       if (action.tag == oneVOneSevenTag) {
//         gameBloc.add(UpdateActionMenuHintText(hintText: StringsGameScreen.lChoose7mReceiver));
//       }
//       if (action.tag == foulSevenMeterTag) {
//         gameBloc.add(UpdateActionMenuHintText(hintText: StringsGameScreen.lChoose7mCause));
//       }
//       if (action.tag == goalOpponentTag || action.tag == emptyGoalTag) {
//         gameBloc.add(ChangeScore(score: gameBloc.state.opponentScore + 1, isOwnScore: false));
//         // we can add a gameaction here to DB because the player does not need to be selected in the player menu later
//         action.playerId = "opponent";
//         gameBloc.add(RegisterAction(actionTag: actionTag));
//         Navigator.pop(context);
//       }
//       // don't show player menu if a goalkeeper action or opponent action was logged
//       // for all other actions show player menu
//       if (actionContext != actionContextGoalkeeper && actionTag != goalOpponentTag) {
//         Navigator.pop(context);
//         // TODO callPlayerMenu
//         // callPlayerMenu(context);
//         gameBloc.add(RegisterAction(actionTag: actionTag));
//       }
//     }
