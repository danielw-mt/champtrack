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

    on<ChangeMenuStatus>((event, emit) {
      emit(state.copyWith(menuStatus: event.menuStatus));
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

    on<UpdateActionMenuHintText>((event, emit) {
      emit(state.copyWith(actionMenuHintText: event.hintText));
    });

    on<UpdatePlayerMenuHintText>((event, emit) {
      emit(state.copyWith(playerMenuHintText: event.hintText));
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

      // for an action from opponent we can switch directly
      if (event.actionTag == emptyGoalTag || event.actionTag == goalOpponentTag) {
        // trigger switch field event
        emit(state.copyWith(menuStatus: MenuStatus.forceClose));
        this.add(SwitchField());
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
          // TODO add action to FB here
          emit(state.copyWith(menuStatus: MenuStatus.forceClose));
          this.add(SwitchField());
          // if there is more than one player with a goalkeeper position on field right now open the player menu
        } else {
          state.playerMenuHintText = StringsGameScreen.lChooseGoalkeeper;
          emit(state.copyWith(menuStatus: MenuStatus.forceClose));
          emit(state.copyWith(menuStatus: MenuStatus.playerMenu));
        }
      }
      if (event.actionTag == oneVOneSevenTag) {
        state.playerMenuHintText = StringsGameScreen.lChoose7mReceiver;
      }
      if (event.actionTag == foulSevenMeterTag) {
        state.playerMenuHintText = StringsGameScreen.lChoose7mCause;
      }
      if (event.actionTag == goalOpponentTag || event.actionTag == emptyGoalTag) {
        emit(state.copyWith(opponentScore: state.opponentScore + 1));
        action.playerId = "opponent";
        // we can add a gameaction here to DB because the player does not need to be selected in the player menu later
        // TODO add action to firebase here
        emit(state.copyWith(menuStatus: MenuStatus.forceClose));
      }
      // add the action to the list of actions
      emit(state.copyWith(gameActions: state.gameActions..add(action)));
      // don't show player menu if a goalkeeper action or opponent action was logged
      // for all other actions show player menu
      if (event.actionContext != actionContextGoalkeeper && event.actionTag != goalOpponentTag) {
        emit(state.copyWith(menuStatus: MenuStatus.loadPlayerMenu));
      }
    });

    on<RegisterPlayerSelection>((event, emit) {
      GameAction lastAction = state.gameActions.last;
      // if the last action was a goal and assist wasn't selected yet enable the option for an assist
      if (lastAction.tag == goalTag && state.assistAvailable == false) {
        List<GameAction> newGameActions = state.gameActions;
        newGameActions.last.playerId = event.player.id!;
        emit(state.copyWith(assistAvailable: true, menuStatus: MenuStatus.loadPlayerMenu, gameActions: newGameActions));
      } else if (lastAction.tag == goalTag && state.assistAvailable == true) {
        // TODO assist action
        emit(state.copyWith(assistAvailable: false, menuStatus: MenuStatus.forceClose));
      } else {
        emit(state.copyWith(menuStatus: MenuStatus.forceClose));
      }
    });
  }
}

/// @return "" if action wasn't a goal, "solo" when player scored without
/// assist and "assist" when player click was assist
// bool _wasAssist() {
//   // check if action was a goal
//   // if it was a goal allow the player to be pressed twice or select and assist player
//   // if the player is clicked again it is a solo action
//   if (gameBloc.state.previousClickedPlayer.id == playerFromButton.id) {
//     return false;
//   }
//   if (gameBloc.state.previousClickedPlayer.id != playerFromButton.id) {
//     return true;
//   }
//   return false;
// }

/// builds a single dialog button that logs its text (=player name) to firestore
/// and updates the game state
// Widget buildDialogButton(BuildContext context, Player playerFromButton, [substitute_menu, isNotOnField]) {
  // Get width and height, so the sizes can be calculated relative to those. So it should look the same on different screen sizes.
  // final double width = MediaQuery.of(context).size.width;
  // final double height = MediaQuery.of(context).size.height;

  // TODO implement this in BLOC. Maybe we can just use switch field and switch to the opposite that the field is on right now
  // void _setFieldBasedOnLastAction(GameAction lastAction) {
  //   if (lastAction.tag == goalTag || lastAction.tag == missTag || lastAction.tag == trfTag) {
  //     // offensiveFieldSwitch();
  //   } else if (lastAction.tag == blockAndStealTag) {
  //     // defensiveFieldSwitch();
  //   }
  // }

  // TODO handle this in BLOC
  // void handlePlayerSelection() async {
  //   GameAction lastAction = gameBloc.state.gameActions.last;
  //   Player previousClickedPlayer = gameBloc.state.previousClickedPlayer;
  //   // if goal was pressed but no player was selected yet
  //   //(lastClickedPlayer is default Player Object) do nothing
  //   if (lastAction.tag == goalTag && previousClickedPlayer.id! == "") {
  //     gameBloc.add(UpdatePlayerMenuHintText(hintText: "TODO Assist"));
  //     // update last Clicked player value with the Player from selected team
  //     // who was clicked
  //     gameBloc.add(RegisterClickOnPlayer(player: playerFromButton));
  //     return;
  //   }
  //   // if goal was pressed and a player was already clicked once
  //   if (lastAction.tag == goalTag) {
  //     // if it was a solo goal the action type has to be updated to "Tor Solo"
  //     persistentController.setLastActionPlayer(previousClickedPlayer);
  //     tempController.updatePlayerEfScore(previousClickedPlayer.id!, persistentController.getLastAction());
  //     addFeedItem(persistentController.getLastAction());
  //     tempController.incOwnScore();
  //     // add goal to feed
  //     // if it was a solo goal the action type has to be updated to "Tor Solo"

  //     if (!_wasAssist()) {
  //       // don't need to do anything because ID was already set above
  //     } else {
  //       // person that scored assist
  //       // deep clone a new action from the most recent action
  //       GameAction assistAction = GameAction.clone(lastAction);
  //       print("assist action: $assistAction");
  //       assistAction.tag = assistTag;
  //       persistentController.addActionToCache(assistAction);
  //       Player assistPlayer = playerFromButton;
  //       assistAction.playerId = assistPlayer.id!;
  //       persistentController.setLastActionPlayer(assistPlayer);
  //       tempController.updatePlayerEfScore(assistPlayer.id!, persistentController.getLastAction());

  //       // add assist first to the feed and then the goal
  //       addFeedItem(assistAction);
  //       tempController.setPreviousClickedPlayer(Player());
  //     }
  //   } else {
  //     // if the action was not a goal just update the player id in firebase and gamestate
  //     persistentController.setLastActionPlayer(playerFromButton);
  //     tempController.setPreviousClickedPlayer(playerFromButton);
  //     tempController.updatePlayerEfScore(playerFromButton.id!, persistentController.getLastAction());
  //     // add action to feed
  //     lastAction.playerId = playerFromButton.id!;
  //     addFeedItem(persistentController.getLastAction());
  //     persistentController.addActionToCache(lastAction);
  //   }

  //   ///
  //   // start: time penalty logic
  //   // if you click on a penalized player the time penalty is removed
  //   ///
  //   if (tempController.isPlayerPenalized(playerFromButton)) {
  //     tempController.removePenalizedPlayer(playerFromButton);
  //   }
  //   if (lastAction.tag == timePenaltyTag) {
  //     Player player = tempController.getPreviousClickedPlayer();
  //     tempController.addPenalizedPlayer(player);
  //   }

  //   ///
  //   // end: time penalty logic
  //   ///

  //   // Check if associated player or lastClickedPlayer are notOnFieldPlayer. If yes, player menu appears to change the player.
  //   // We can click on not on field players if we swipe on the player menu and all the player not on field will be shown.
  //   if (!tempController.getOnFieldPlayers().contains(playerFromButton)) {
  //     tempController.addPlayerToChange(playerFromButton);
  //   }
  //   if (!tempController.getOnFieldPlayers().contains(previousClickedPlayer) && !(previousClickedPlayer.id! == "")) {
  //     tempController.addPlayerToChange(previousClickedPlayer);
  //   }
  //   _setFieldBasedOnLastAction(lastAction);
  //   // If there are still player to change, open the player menu again but as a substitue player menu (true flag)
  //   if (!tempController.getPlayersToChange().isEmpty) {
  //     Navigator.pop(context);
  //     callPlayerMenu(context, true);
  //     return;
  //   }

  //   // if we get a 7m in our favor call the seven meter menu for us
  //   if (lastAction.tag == oneVOneSevenTag) {
  //     Navigator.pop(context);
  //     callSevenMeterPlayerMenu(context);
  //     return;
  //   }
  //   // if we perform a 7m foul call the seven meter menu for the other team
  //   else if (lastAction.tag == foulSevenMeterTag) {
  //     Navigator.pop(context);
  //     callSevenMeterMenu(context, false);
  //     return;
  //   }
  //   // reset last clicked player and player menu hint text
  //   tempController.setPreviousClickedPlayer(Player());
  //   tempController.setPlayerMenuText("");
  //   Navigator.pop(context);
  // }

  // function which is called is substitute_player param is not null
  // after a player was chosen for an action who is not on field

  // TODO move this to BLOC and adapt the button to substitute or not
  // void substitutePlayer() {
  //   playerChanged = true;
  //   // get player which was pressed in player menu in tempController.getOnFieldPlayers()
  //   Player playerToChange = tempController.getLastPlayerToChange();

  //   // Update player bar players
  //   int l = tempController.getPlayersFromSelectedTeam().indexOf(playerToChange);
  //   int k = tempController.getPlayersFromSelectedTeam().indexOf(playerFromButton);
  //   int indexToChange = tempController.getPlayerBarPlayers().indexOf(k);
  //   tempController.changePlayerBarPlayers(indexToChange, l);
  //   // Change the player which was pressed in player menu in tempController.getOnFieldPlayers()
  //   // to the player which was pressed in popup dialog.
  //   tempController.setOnFieldPlayer(
  //       tempController.getOnFieldPlayers().indexOf(playerFromButton), playerToChange, Get.find<PersistentController>().getCurrentGame());

  //   tempController.setPlayerMenuText("");
  //   Navigator.pop(context);
  // }

  // Button with shirt with buttonNumber inside and buttonText below.
  // Getbuilder so the color changes if player == goalscorer,
// }