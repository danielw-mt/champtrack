import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/gestures.dart';
import 'package:handball_performance_tracker/data/models/models.dart';
import 'package:handball_performance_tracker/data/repositories/repositories.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:handball_performance_tracker/core/core.dart';
import 'game_field_math.dart';
import 'package:handball_performance_tracker/features/game/game.dart';
import 'dart:async';
import 'package:handball_performance_tracker/core/constants/field_size_parameters.dart' as fieldSizeParameter;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math';
import 'dart:convert';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameFirebaseRepository gameRepository;
  late Timer t;

  /// Periodically checks if there is a difference between the gameState and what has been synced to the database already.
  /// If there is a difference, it will sync the gameState to the database.
  void runGameSync() {
    // check if there is a difference compared to the last sync
    List<Player> syncedOnFieldPlayers = [];
    int syncedScoreHome = 0;
    int syncedScoreOpponent = 0;
    List<GameAction> syncedGameActions = [];

    t = Timer.periodic(const Duration(seconds: 10), (timer) async {
      // only sync if the game is running
      // if (state.documentReference != null && state.status != GameStatus.initial && state.status != GameStatus.paused) {

      // for now always sync
      if (state.documentReference != null) {
        print("syncing game...");
        // if any difference is found in the metadata of the game (onFieldPlayers, scoreHome, scoreOpponent, stopWatchTime) sync the metadata
        if (!state.onFieldPlayers
                .every((Player player) => syncedOnFieldPlayers.where((Player playerElement) => playerElement.id == player.id).toList().isNotEmpty) ||
            state.ownScore != syncedScoreHome ||
            state.opponentScore != syncedScoreOpponent) {
          // sync game metadata
          List<String> onFieldPlayerIds = state.onFieldPlayers.map((Player player) => player.id.toString()).toList();
          Game newGame = Game(
            id: state.documentReference!.id,
            path: state.documentReference!.path,
            teamId: state.selectedTeam.id,
            date: state.date,
            startTime: state.date!.millisecondsSinceEpoch,
            stopTime: DateTime.now().millisecondsSinceEpoch,
            scoreHome: state.ownScore,
            scoreOpponent: state.opponentScore,
            isAtHome: state.isHomeGame,
            location: state.location,
            opponent: state.opponent,
            // TODO add season here and season to state
            lastSync: DateTime.now().millisecondsSinceEpoch.toString(),
            onFieldPlayers: onFieldPlayerIds,
            attackIsLeft: state.attackIsLeft,
            stopWatchTimer: state.stopWatchTimer,
            // Don't need gameActions here as it is just the game metadata
            // gameActions: state.gameActions,
          );
          await this.gameRepository.updateGame(newGame).then((value) {
            // on success update the variables
            syncedOnFieldPlayers = state.onFieldPlayers.toList();
            syncedScoreHome = state.ownScore;
            syncedScoreOpponent = state.opponentScore;
          }).onError((error, stackTrace) {
            print("Error syncing game metadata: $error");
          });
        }

        /// function that finds gameActions that were added to the last gameActions since the last sync or gameActions that were deleted since the last sync
        List<List<GameAction>> difference(List<GameAction> oldActions, List<GameAction> newActions) {
          List<GameAction> added = [];
          List<GameAction> removed = [];
          for (var i = 0; i < oldActions.length; i++) {
            if (!newActions.contains(oldActions[i])) {
              removed.add(oldActions[i]);
            }
          }
          for (var i = 0; i < newActions.length; i++) {
            if (!oldActions.contains(newActions[i])) {
              added.add(newActions[i]);
            }
          }
          return [added, removed];
        }

        List<List<GameAction>> gameActionsDifference = difference(syncedGameActions, state.gameActions);
        // if gameActions were added
        if (!gameActionsDifference[0].isEmpty) {
          List<GameAction> addedGameActions = gameActionsDifference[0];
          print("added gameActions: ${addedGameActions.length}");
          await Future.forEach(addedGameActions, (GameAction gameAction) async {
            // only add actions that have a player Id assigned
            if (gameAction.playerId != "") {
              try {
                DocumentReference docRef = await this.gameRepository.createAction(gameAction, state.documentReference!.id);
                syncedGameActions.add(gameAction);
                state.gameActions[state.gameActions.indexOf(gameAction)].id = docRef.id;
                state.gameActions[state.gameActions.indexOf(gameAction)].path = docRef.path;
              } catch (e) {
                print("Error syncing gameAction: $e");
              }
            }
            // on success set gameActionsWereSynced to true
          });
        }
        // if gameActions were removed
        if (!gameActionsDifference[1].isEmpty) {
          List<GameAction> removedGameActions = gameActionsDifference[1];
          print("removed gameActions: ${removedGameActions.length}");
          await Future.forEach(removedGameActions, (GameAction gameAction) {
            if (gameAction.playerId != "") {
              try {
                this.gameRepository.deleteAction(gameAction, state.documentReference!.id).then((value) => syncedGameActions.remove(gameAction));
              } catch (e) {
                print("Error syncing gameAction: $e");
              }
            }
            // on success set gameActionsWereSynced to true
          });
        }
      } else {
        print("game sync is not running");
      }
    });
  }

  GameBloc({required GameFirebaseRepository this.gameRepository}) : super(GameState()) {
    on<InitializeGame>((event, emit) async {
      try {
        Game game = Game(
            date: event.date,
            opponent: event.opponent,
            location: event.location,
            teamId: event.selectedTeam.id!,
            isAtHome: event.isHomeGame,
            attackIsLeft: event.attackIsLeft,
            startTime: DateTime.now().millisecondsSinceEpoch);
        DocumentReference gameRef = await this.gameRepository.createGame(game);

        // create the initial game state. Only overload the necessary fields that are not already defined as necessary in the constructor
        emit(GameState(
          documentReference: gameRef,
          opponent: event.opponent,
          location: event.location,
          date: event.date,
          selectedTeam: event.selectedTeam,
          isHomeGame: event.isHomeGame,
          attackIsLeft: event.attackIsLeft,
          onFieldPlayers: event.onFieldPlayers,
        ));
        runGameSync();
      } catch (error) {
        print("Error initializing game: $error");
      }
    });

    // just put the game state into an empty gamestate
    on<ResetGame>(((event, emit) {
      t.cancel();
      emit(GameState());
    }));

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

    on<FinishGame>((event, emit) async {
      StopWatchTimer stopWatchTimer = state.stopWatchTimer;
      stopWatchTimer.onExecute.add(StopWatchExecute.stop);
      emit(state.copyWith(status: GameStatus.finished, stopWatchTimer: stopWatchTimer));

      // set stop time on firebase
      List<String> onFieldPlayerIds = state.onFieldPlayers.map((Player player) => player.id.toString()).toList();
      Game newGame = Game(
        id: state.documentReference!.id,
        path: state.documentReference!.path,
        teamId: state.selectedTeam.id,
        date: state.date,
        startTime: state.date!.millisecondsSinceEpoch,
        stopTime: DateTime.now().millisecondsSinceEpoch,
        scoreHome: state.ownScore,
        scoreOpponent: state.opponentScore,
        isAtHome: state.isHomeGame,
        location: state.location,
        opponent: state.opponent,
        // TODO add season here and season to state
        lastSync: DateTime.now().millisecondsSinceEpoch.toString(),
        onFieldPlayers: onFieldPlayerIds,
        attackIsLeft: state.attackIsLeft,
        stopWatchTimer: state.stopWatchTimer,
        // gameActions: state.gameActions,
      );
      await this.gameRepository.updateGame(newGame).onError((error, stackTrace) {
        print("Error syncing game metadata: $error");
      });
    });

    on<ChangeScore>((event, emit) {
      if (event.isOwnScore) {
        emit(state.copyWith(ownScore: event.score));
      } else {
        emit(state.copyWith(opponentScore: event.score));
      }
    });

    // switch sides for example during halftime
    on<SwitchSides>((event, emit) {
      emit(state.copyWith(attackIsLeft: !state.attackIsLeft, attacking: !state.attacking));
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
      print("event position: ${event.position.toString()}");
      print("screen size: ${fieldSizeParameter.fieldWidth.toString()}");
      double relative_x_coordinate = event.position.dx / fieldSizeParameter.fieldWidth;
      double rounded_x_coordinate = (relative_x_coordinate * 100).round() / 100;
      double relative_y_coordinate = event.position.dy / fieldSizeParameter.fieldHeight;
      double rounded_y_coordinate = (relative_y_coordinate * 100).round() / 100;
      List<double> lastCoordinates = [rounded_x_coordinate, rounded_y_coordinate];
      print("last coordinates: ${lastCoordinates.toString()}");
      // if we clicked on our own goal pop up our goalkeeper menu
      if (lastLocation.contains("goal") && !state.attacking) {
        emit(state.copyWith(
            lastClickedLocation: lastLocation, lastClickedCoordinates: lastCoordinates, workflowStep: WorkflowStep.actionMenuGoalKeeper));
      } else {
        emit(state.copyWith(lastClickedLocation: lastLocation, lastClickedCoordinates: lastCoordinates));
        this.add(WorkflowEvent());
      }
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
      } else if (onFieldPlayers.contains(event.oldPlayer)) {
        onFieldPlayers[onFieldPlayers.indexOf(event.oldPlayer)] = event.newPlayer;
        emit(state.copyWith(onFieldPlayers: onFieldPlayers.toList()));
      }
    });

    on<UpdatePlayerEfScore>((event, emit) {
      if (event.action.playerId != "") {
        Player relevantPlayer = state.onFieldPlayers.where((Player player) => player.id == event.action.playerId).first;
        if (event.actionAdded) {
          print("adding action to player ef score");
          relevantPlayer.addAction(event.action);
        } else {
          print("removing action from player ef score");
          relevantPlayer.removeAction(event.action);
        }
        List<Player> newOnFieldPlayers = state.onFieldPlayers.toList();
        newOnFieldPlayers[newOnFieldPlayers.indexOf(relevantPlayer)] = relevantPlayer;
        emit(state.copyWith(onFieldPlayers: newOnFieldPlayers));
      }
    });

    on<DeleteGameAction>((event, emit) {
      print("deleting game action: " + event.action.tag.toString() + " ");

      bool decreaseOwnScore = false;
      bool decreaseOpponentScore = false;
      switch (event.action.tag) {
        case goal7mTag:
          decreaseOwnScore = true;
          break;
        case goalGoalKeeperTag:
          decreaseOwnScore = true;
          break;
        case goalTag:
          decreaseOwnScore = true;
          break;
        case goalOpponent7mTag:
          decreaseOpponentScore = true;
          break;
        case goalOpponentTag:
          decreaseOpponentScore = true;
          break;
        case emptyGoalTag:
          decreaseOpponentScore = true;
          break;
      }
      if (decreaseOwnScore && state.ownScore > 0) {
        emit(state.copyWith(ownScore: state.ownScore - 1));
      }
      if (decreaseOpponentScore && state.opponentScore > 0) {
        emit(state.copyWith(opponentScore: state.opponentScore - 1));
      }

      if (event.action.tag == timePenaltyTag) {
        this.add(RemovePenalty(player: state.selectedTeam.players.where((Player player) => player.id == event.action.playerId).first));
      }

      // update player ef score
      this.add(UpdatePlayerEfScore(action: event.action, actionAdded: false));

      List<GameAction> newGameActions = state.gameActions.toList();
      int index = newGameActions.indexWhere((element) => element.id == event.action.id);
      newGameActions.removeAt(index);
      emit(state.copyWith(gameActions: newGameActions));
    });

    on<SetPenalty>((event, emit) {
      int penaltyStartStopWatchTime = state.stopWatchTimer.rawTime.value;

      onTimerFinish() async {
        try {
          this.add(RemovePenalty(player: event.player));
        } catch (e) {
          print("error in penalty timer: $e");
        }
      }

      Timer timer;
      if (event.limited == true) {
        timer = Timer.periodic(Duration(seconds: 5), (Timer t) async {
          // in case we got rid of the penalty manually
          if (!state.penalties.containsKey(event.player)) {
            t.cancel();
            return;
          }
          int stopWatchTime = state.stopWatchTimer.rawTime.value;
          // 120000 is 2 minutes
          if (stopWatchTime - penaltyStartStopWatchTime >= 120000) {
            onTimerFinish();
          }
        });
      } else {
        // this timer is not really needed for red card penalty
        timer = Timer(Duration(seconds: 1000), () async {});
      }
      state.penalties[event.player] = timer;
      emit(state.copyWith(penalties: new Map<Player, Timer>.from(state.penalties)));
    });

    on<RemovePenalty>((event, emit) {
      if (state.penalties.containsKey(event.player)) {
        state.penalties[event.player]!.cancel();
        state.penalties.remove(event.player);
        emit(state.copyWith(penalties: new Map<Player, Timer>.from(state.penalties)));
      }
    });

    on<RegisterAction>((event, emit) {
      int unixTime = DateTime.now().toUtc().millisecondsSinceEpoch;
      GameAction action = GameAction(
        id: getRandString(20),
        context: event.actionContext,
        tag: event.actionTag,
        throwLocation: List.from(state.lastClickedLocation.cast<String>()),
        coordinates: List.from(state.lastClickedCoordinates.cast<double>()),
        timestamp: unixTime,
      );

      // stop time for penalties
      if (event.actionTag == forceTwoMinTag || event.actionTag == timePenaltyTag || event.actionTag == redCardTag) {
        this.add(PauseGame());
      }

      // for an action from opponent we can switch directly, we don't need the player menu to choose a player because these actions can be
      // directly assigned to the opponent
      if (event.actionTag == emptyGoalTag || event.actionTag == goalOpponentTag || event.actionTag == goalOpponent7mTag) {
        print("logging opponent action");
        // trigger switch field event
        this.add(SwitchField());
        if (event.actionTag == emptyGoalTag || event.actionTag == goalOpponentTag) {
          action.playerId = "opponent";
          emit(state.copyWith(opponentScore: state.opponentScore + 1, workflowStep: WorkflowStep.forceClose));
        } else {
          emit(state.copyWith(
            opponentScore: state.opponentScore + 1,
          ));
        }

        // if an action inside goalkeeper menu that does not correspond to the opponent was hit try to assign this action directly to the goalkeeper
      }
      if (event.actionContext == actionContextGoalkeeper) {
        print("our own goalkeeper action");
        if (action.tag == goalGoalKeeperTag) {
          emit(state.copyWith(ownScore: state.ownScore + 1));
        }

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
          if (action.tag == timePenaltyTag) {
            this.add(SetPenalty(player: goalKeepers[0]));
          }
          if (action.tag == redCardTag) {
            this.add(SetPenalty(player: goalKeepers[0], limited: false));
          }
          emit(state.copyWith(workflowStep: WorkflowStep.forceClose));
          // if there is more than one player with a goalkeeper position on field right now open the player menu with goalkeeper selection style
        } else {
          // TODO open player menu with goalkeeper selection style
          this.add(WorkflowEvent(selectedAction: action));
        }
      } else if (action.tag == goal7mTag) {
        emit(state.copyWith(ownScore: state.ownScore + 1));
        this.add(WorkflowEvent(selectedAction: action));
        this.add(SwitchField());

        ////////////////////////////////////
        /// Seven Meter Stuff
        ///////////////////////////////////
      } else if (state.workflowStep == WorkflowStep.sevenMeterPrompt) {
        if (action.tag == yes7mTag && state.gameActions.last.tag == timePenaltyTag) {
          print("going to defensive 7m after time penalty");
          // go to defensive 7m
          action.tag = foulSevenMeterTag;
          action.playerId = state.gameActions.last.playerId;
          print("adding WorkflowEvent: ${action.tag}");
          this.add(WorkflowEvent(selectedAction: action));
        } else if (action.tag == yes7mTag && state.gameActions.last.tag == forceTwoMinTag) {
          print("going to offensive 7m after force two minutes");
          // go to offensive 7m
          action.tag = oneVOneSevenTag;
          action.playerId = state.gameActions.last.playerId;
          print("adding WorkflowEvent: ${action.tag}");
          this.add(WorkflowEvent(selectedAction: action));
        } else if (action.tag == no7mTag) {
          print("no 7m");
          // close the menu
          emit(state.copyWith(workflowStep: WorkflowStep.forceClose));
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
        this.add(WorkflowEvent(selectedAction: action));
      }
      print("adding action: " + action.tag.toString());
      emit(state.copyWith(gameActions: state.gameActions..add(action)));
    });

    on<RegisterPlayerSelection>((event, emit) {
      GameAction lastAction = state.gameActions.last;
      if (state.workflowStep == WorkflowStep.assistSelection && event.player.id != state.gameActions.last.playerId) {
        print("player selection: adding assist");
        GameAction assistAction = GameAction(
            id: getRandString(20),
            context: state.gameActions.last.context,
            tag: assistTag,
            throwLocation: List.from(state.lastClickedLocation.cast<String>()),
            timestamp: lastAction.timestamp,
            playerId: event.player.id!);
        this.add(UpdatePlayerEfScore(action: assistAction, actionAdded: true));
        this.add(WorkflowEvent(selectedPlayer: event.player));
        emit(state.copyWith(gameActions: state.gameActions..add(assistAction)));
      } else if (lastAction.tag == timePenaltyTag) {
        print("player selection: adding time penalty");
        lastAction.playerId = event.player.id!;
        this.add(SetPenalty(player: event.player, limited: true));
        // replace last action and add it again but this time with the player id and ef score update
        emit(state.copyWith(gameActions: state.gameActions));
        this.add(UpdatePlayerEfScore(action: lastAction, actionAdded: true));
        this.add(WorkflowEvent(selectedPlayer: event.player));
      } else if (lastAction.tag == redCardTag) {
        print("red card: adding infinite penalty");
        this.add(SetPenalty(player: event.player, limited: false));
        lastAction.playerId = event.player.id!;
        emit(state.copyWith(gameActions: state.gameActions));
        this.add(UpdatePlayerEfScore(action: lastAction, actionAdded: true));
        this.add(WorkflowEvent(selectedPlayer: event.player));
      } else if (state.workflowStep == WorkflowStep.substitutionTargetSelection) {
        print("player selection: selecting substitution target");
        this.add(SubstitutePlayer(newPlayer: state.substitutionPlayer, oldPlayer: event.player));
        this.add(WorkflowEvent(selectedPlayer: event.player));
        lastAction.playerId = event.player.id!;
        emit(state.copyWith(gameActions: state.gameActions));

        this.add(UpdatePlayerEfScore(action: lastAction, actionAdded: true));
        // normal player selection => substitute player
      } else if (event.isSubstitute && state.workflowStep == WorkflowStep.playerSelection) {
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
          lastAction.playerId = event.player.id!;
          emit(state.copyWith(gameActions: state.gameActions));
          this.add(UpdatePlayerEfScore(action: lastAction, actionAdded: true));
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
        lastAction.playerId = event.player.id!;
        emit(state.copyWith(gameActions: state.gameActions));
        this.add(UpdatePlayerEfScore(action: lastAction, actionAdded: true));
        int ownScore = state.ownScore;
        // if we click on a player that is penalized remove him from the list of penalized players
        if (state.penalties.keys.contains(event.player)) {
          state.penalties.remove(event.player);
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
        if (lastTag == goalTag && state.workflowStep != WorkflowStep.assistSelection) {
          ownScore = ownScore + 1;
        }
        emit(state.copyWith(ownScore: ownScore));
        this.add(WorkflowEvent(selectedPlayer: event.player));
      }
    });

    on<WorkflowEvent>((event, emit) {
      print("workflow event: " + state.workflowStep.toString());
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
            // in the case of a time penalty open the seven meter menu
          } else if (state.gameActions.last.tag == forceTwoMinTag) {
            print("workflow playerSelection => sevenMeterExecuterSelection");
            emit(state.copyWith(workflowStep: WorkflowStep.sevenMeterPrompt));
          } else if (state.gameActions.last.tag == timePenaltyTag) {
            print("workflow playerSelection => goalKeeperSelection");
            emit(state.copyWith(workflowStep: WorkflowStep.sevenMeterPrompt));
          } else {
            print("workflow playerSelection => closed");
            emit(state.copyWith(workflowStep: WorkflowStep.forceClose));
          }
          break;
        case WorkflowStep.sevenMeterPrompt:
          print("seven meter prompt step");
          if (state.gameActions.last.tag == oneVOneSevenTag) {
            print("workflow sevenMeterPrompt => sevenMeterExecuterSelection");
            emit(state.copyWith(workflowStep: WorkflowStep.sevenMeterExecutorSelection));
          } else if (state.gameActions.last.tag == foulSevenMeterTag) {
            print("workflow sevenMeterPrompt => goalKeeperSelection");
            emit(state.copyWith(workflowStep: WorkflowStep.sevenMeterGoalkeeperSelection));
          } else {
            print("workflow sevenMeterPrompt => closed");
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

  String getRandString(int len) {
    var random = Random.secure();
    var values = List<int>.generate(len, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }
}
