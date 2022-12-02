import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/gestures.dart';
import 'package:handball_performance_tracker/data/models/models.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:handball_performance_tracker/core/core.dart';
import 'game_field_math.dart';
import 'package:handball_performance_tracker/features/game/game.dart';

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
        print("attacking: true");
        emit(state.copyWith(attacking: true));
      } else {
        print("attacking: false");
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

    on<ChangeScore>((event, emit) {
      if (event.isOwnScore) {
        emit(state.copyWith(ownScore: event.score));
      } else {
        emit(state.copyWith(opponentScore: event.score));
      }
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

    on<SwitchField>((event, emit) {
      if (GameField.pageController.page == 0) {
        if (state.attackIsLeft) {
          emit(state.copyWith(attacking: false));
        } else {
          emit(state.copyWith(attacking: true));
        }
        GameField.pageController.jumpToPage(1);
      } else {
        if (state.attackIsLeft) {
          emit(state.copyWith(attacking: true));
        } else {
          emit(state.copyWith(attacking: false));
        }
        GameField.pageController.jumpToPage(0);
      }
    });

    on<SubstitutePlayer>((event, emit) {
      List<Player> onFieldPlayers = state.onFieldPlayers;
      // if a substitution target was chosen that already is on field it means that we can just swap players in the onfieldplayers
      print("substituting ${event.oldPlayer.lastName} with ${event.newPlayer.lastName}");
      if (onFieldPlayers.contains(event.oldPlayer) && onFieldPlayers.contains(event.newPlayer)) {
        int indexOfNewPlayer = onFieldPlayers.indexOf(event.newPlayer);
        onFieldPlayers[onFieldPlayers.indexOf(event.oldPlayer)] = event.newPlayer;
        onFieldPlayers[indexOfNewPlayer] = event.oldPlayer;
        emit(state.copyWith(onFieldPlayers: onFieldPlayers.toList()));
      } else {
        onFieldPlayers[onFieldPlayers.indexOf(event.oldPlayer)] = event.newPlayer;
        emit(state.copyWith(onFieldPlayers: onFieldPlayers.toList()));
      }
    });

    on<DeleteGameAction>((event, emit) {
      emit(state.copyWith(gameActions: state.gameActions..remove(event.action)));
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

      // for an action from opponent we can switch directly, we don't need the player menu to choose a player because these actions can be
      // directly assigned to the opponent
      if (event.actionTag == emptyGoalTag || event.actionTag == goalOpponentTag || event.actionTag == goalOpponent7mTag) {
        print("logging opponent action");
        // trigger switch field event
        this.add(SwitchField());
        action.playerId = "opponent";
        emit(state.copyWith(opponentScore: state.opponentScore + 1, workflowStep: WorkflowStep.forceClose));
        // if an action inside goalkeeper menu that does not correspond to the opponent was hit try to assign this action directly to the goalkeeper
      } else if (event.actionContext == actionContextGoalkeeper && event.actionTag != goalOpponentTag && event.actionTag != emptyGoalTag) {
        print("our own goalkeeper action");
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
          // TODO add action to FB here
          this.add(SwitchField());
          emit(state.copyWith(workflowStep: WorkflowStep.forceClose));
          // if there is more than one player with a goalkeeper position on field right now open the player menu with goalkeeper selection style
        } else {
          // TODO open player menu with goalkeeper selection style
          this.add(WorkflowEvent(selectedAction: action));
        }
      } else if (state.workflowStep == WorkflowStep.sevenMeterOffenseResult) {
        print("logging 7m result");
        action.playerId = state.sevenMeterExecutor.id!;
        this.add(WorkflowEvent(selectedAction: action));
        this.add(SwitchField());
      } else if (state.workflowStep == WorkflowStep.sevenMeterDefenseResult) {
        print("logging 7m result");
        action.playerId = state.sevenMeterGoalkeeper.id!;
        this.add(WorkflowEvent(selectedAction: action));
        this.add(SwitchField());
      } else {
        // add the action to the list of actions
        print("adding normal action");
        // don't show player menu if a goalkeeper action or opponent action was logged
        // for all other actions show player menu
        this.add(WorkflowEvent(selectedAction: action));
      }
      emit(state.copyWith(gameActions: state.gameActions..add(action)));
    });

    on<RegisterPlayerSelection>((event, emit) {
      GameAction lastAction = state.gameActions.last;
      if (state.workflowStep == WorkflowStep.assistSelection && event.player.id != state.gameActions.last.playerId) {
        print("player selection: adding assist");
        GameAction assistAction = GameAction(
            teamId: state.selectedTeam.id!,
            gameId: lastAction.gameId,
            context: state.gameActions.last.context,
            tag: assistTag,
            throwLocation: List.from(state.lastClickedLocation.cast<String>()),
            timestamp: lastAction.timestamp,
            relativeTime: lastAction.relativeTime,
            playerId: event.player.id!);
        emit(state.copyWith(gameActions: state.gameActions..add(assistAction), ownScore: state.ownScore + 1));
        this.add(WorkflowEvent(selectedPlayer: event.player));
      } else if (state.workflowStep == WorkflowStep.substitutionTargetSelection) {
        print("player selection: selecting substitution target");
        this.add(SubstitutePlayer(newPlayer: state.substitutionPlayer, oldPlayer: event.player));
        this.add(WorkflowEvent(selectedPlayer: event.player));
        List<GameAction> gameActions = state.gameActions;
        gameActions.last.playerId = state.substitutionPlayer.id!;
        emit(state.copyWith(gameActions: gameActions));
      } else if (event.isSubstitute) {
        print("player selection: substitute");
        // if a player was selected from the not on field players in the player menu
        List<Player> playersWithSamePosition = [];
        // if there is only one player on field with the same position as the substitution player just swap that player with them
        event.player.positions.forEach((String position) {
          state.onFieldPlayers.forEach((Player player) {
            if (player.positions.contains(position)) {
              playersWithSamePosition.add(player);
            }
          });
        });
        if (playersWithSamePosition.length == 1) {
          print("there is one clear player to be substituted. Not calling substitution menu for now");
          this.add(SubstitutePlayer(newPlayer: event.player, oldPlayer: playersWithSamePosition[0]));
          this.add(WorkflowEvent(selectedPlayer: event.player));
          List<GameAction> gameActions = state.gameActions;
          gameActions.last.playerId = event.player.id!;
          emit(state.copyWith(gameActions: gameActions));
        } else {
          // if there are more than one player on field with the same position as the substitution player open the substituion menu
          print("there is no clear player to be substituted. Calling substitution menu");
          emit(state.copyWith(substitutionPlayer: event.player, workflowStep: WorkflowStep.substitutionTargetSelection));
        }
      } else if (state.workflowStep == WorkflowStep.sevenMeterExecutorSelection) {
        print("seven meter executor selection");
        emit(state.copyWith(sevenMeterExecutor: event.player));
        this.add(WorkflowEvent(selectedPlayer: event.player));
      } else if (state.workflowStep == WorkflowStep.sevenMeterGoalkeeperSelection) {
        print("seven meter goalkeeper selection");
        emit(state.copyWith(sevenMeterGoalkeeper: event.player));
        this.add(WorkflowEvent(selectedPlayer: event.player));
      } else {
        print("no special case. Just add the action to the list of actions after the player selection");
        List<GameAction> newGameActions = state.gameActions;
        newGameActions.last.playerId = event.player.id!;
        List<Player> penalizedPlayers = state.penalizedPlayers;
        int ownScore = state.ownScore;
        // if we click on a player that is penalized remove him from the list of penalized players
        if (state.penalizedPlayers.contains(event.player)) {
          penalizedPlayers.remove(event.player);
        }

        // Switch field on goal, block & steal (=stürmerfoul), missed goal attempt and technical mistake on offensive (not trf on defense)
        String lastTag = state.gameActions.last.tag;
        if (lastTag == goalTag ||
            lastTag == blockAndStealTag ||
            lastTag == missTag ||
            (lastTag == trfTag && state.gameActions.last.context == actionContextAttack)) {
          this.add(SwitchField());
        }
        // adapt score if we scored a goal
        if (lastTag == goalTag) {
          ownScore = ownScore + 1;
        }
        emit(state.copyWith(ownScore: ownScore, penalizedPlayers: penalizedPlayers, substitutionTarget: Player(), gameActions: newGameActions));
        this.add(WorkflowEvent(selectedPlayer: event.player));
      }
    });

    on<WorkflowEvent>((event, emit) {
      switch (state.workflowStep) {
        case WorkflowStep.closed:
          if (state.attacking) {
            print("workflow closed => actionMenuOffense");
            emit(state.copyWith(workflowStep: WorkflowStep.actionMenuOffense));
          } else {
            print("workflow closed => actionMenuDefense");
            emit(state.copyWith(workflowStep: WorkflowStep.actionMenuDefense));
          }
          break;
        case WorkflowStep.actionMenuOffense:
          if (event.selectedAction!.tag == oneVOneSevenTag) {
            print("workflow actionMenuOffense => sevenMeterScorerSelection");
            emit(state.copyWith(workflowStep: WorkflowStep.sevenMeterScorerSelection));
          } else {
            print("workflow actionMenuOffense => playerSelection");
            emit(state.copyWith(workflowStep: WorkflowStep.playerSelection));
          }
          break;
        case WorkflowStep.assistSelection:
          print("workflow assistSelection => force close");
          emit(state.copyWith(workflowStep: WorkflowStep.forceClose));
          break;
        case WorkflowStep.sevenMeterScorerSelection:
          print("workflow sevenMeterScorerSelection => sevenMeterExecutorSelection");
          emit(state.copyWith(workflowStep: WorkflowStep.sevenMeterExecutorSelection));
          break;
        case WorkflowStep.sevenMeterExecutorSelection:
          print("workflow sevenMeterExecutorSelection => sevenMeterOffenseResult");
          emit(state.copyWith(workflowStep: WorkflowStep.sevenMeterOffenseResult));
          break;
        case WorkflowStep.sevenMeterOffenseResult:
          print("workflow sevenMeterOffenseResult => closed");
          emit(state.copyWith(workflowStep: WorkflowStep.forceClose));
          break;
        case WorkflowStep.actionMenuDefense:
          if (event.selectedAction!.tag == foulSevenMeterTag) {
            print("workflow actionMenuDefense => sevenMeterFoulerSelection");
            emit(state.copyWith(workflowStep: WorkflowStep.sevenMeterFoulerSelection));
          } else {
            print("workflow actionMenuDefense => playerSelection");
            emit(state.copyWith(workflowStep: WorkflowStep.playerSelection));
          }
          break;
        case WorkflowStep.sevenMeterFoulerSelection:
          print("workflow sevenMeterFoulerSelection => sevenMeterGoalkeeperSelection");
          emit(state.copyWith(workflowStep: WorkflowStep.sevenMeterGoalkeeperSelection));
          break;
        case WorkflowStep.sevenMeterGoalkeeperSelection:
          print("workflow sevenMeterGoalkeeperSelection => sevenMeterDefenseResult");
          emit(state.copyWith(workflowStep: WorkflowStep.sevenMeterDefenseResult));
          break;
        case WorkflowStep.sevenMeterOffenseResult:
          print("workflow sevenMeterOffenseResult => closed");
          emit(state.copyWith(workflowStep: WorkflowStep.forceClose));
          break;
        case WorkflowStep.sevenMeterDefenseResult:
          print("workflow sevenMeterDefenseResult => closed");
          emit(state.copyWith(workflowStep: WorkflowStep.forceClose));
          break;
        case WorkflowStep.playerSelection:
          if (state.gameActions.last.tag == goalTag) {
            print("workflow playerSelection => goalAssistSelection");
            emit(state.copyWith(workflowStep: WorkflowStep.assistSelection));
          } else {
            print("workflow playerSelection => closed");
            emit(state.copyWith(workflowStep: WorkflowStep.forceClose));
          }
          break;
        case WorkflowStep.substitutionTargetSelection:
          print("workflow substitutionTargetSelection => force close");
          emit(state.copyWith(workflowStep: WorkflowStep.forceClose));
          break;
        case WorkflowStep.actionMenuGoalKeeper:
          print("workflow actionMenuGoalKeeper => force close");
          emit(state.copyWith(workflowStep: WorkflowStep.forceClose));
          break;
        default:
          emit(state.copyWith(workflowStep: WorkflowStep.closed));
          break;
      }
    });
  }
}

// void logAction() async {
//   // we executed a 7m
//   if (actionTag == goal7mTag || actionTag == missed7mTag) {
//     logger.d("our team executed a 7m");
//     Player sevenMeterExecutor = tempController.getPreviousClickedPlayer();
//     action.playerId = sevenMeterExecutor.id!;
//     persistentController.addActionToCache(action);
//     persistentController.addActionToFirebase(action);
//     tempController.updatePlayerEfScore(action.playerId, action);
//     addFeedItem(action);
//     tempController.setPreviousClickedPlayer(Player());
//     Navigator.pop(context);
//     // opponents scored or missed their 7m
//   } else if (actionTag == goalOpponent7mTag || actionTag == parade7mTag) {
//     logger.d("opponent executed a 7m");
//     List<Player> goalKeepers = [];
//     tempController.getOnFieldPlayers().forEach((Player player) {
//       if (player.positions.contains(goalkeeperPos)) {
//         goalKeepers.add(player);
//       }
//     });
//     // if there is only one player with a goalkeeper position on field right now assign the action to him
//     if (goalKeepers.length == 1) {
//       // we know the player id so we assign it here. For all other actions it is assigned in the player menu
//       action.playerId = goalKeepers[0].id!;
//       persistentController.addActionToCache(action);
//       persistentController.addActionToFirebase(action);
//       addFeedItem(action);
//       Navigator.pop(context);
//       tempController.updatePlayerEfScore(action.playerId, action);
//       // if there is more than one player with a goalkeeper position on field right now
//     } else {
//       tempController.setPlayerMenuText(StringsGameScreen.lChooseGoalkeeper);
//       logger.d("More than one goalkeeper on field. Waiting for player selection");
//       persistentController.addActionToCache(action);
//       Navigator.pop(context);
//       callPlayerMenu(context);
//     }
//   }

//   // goal
//   if (actionTag == goal7mTag) {
//     tempController.incOwnScore();
//     offensiveFieldSwitch();
//   }
//   // missed 7m
//   if (actionTag == missed7mTag) {
//     offensiveFieldSwitch();
//   }
//   // opponent goal
//   if (actionTag == goalOpponent7mTag) {
//     tempController.incOpponentScore();
//     defensiveFieldSwitch();
//   }
//   // opponent missed
//   if (actionTag == parade7mTag) {
//     defensiveFieldSwitch();
//   }

//   // If there were player clicked which are not on field, open substitute player menu

//   // see # 400 swapping out player on bench should not be possible
//   // if (!tempController.getPlayersToChange().isEmpty) {
//   //   Navigator.pop(context);
//   //   callPlayerMenu(context, true);
//   //   return;
//   // }
// }
