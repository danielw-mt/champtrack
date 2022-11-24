import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/gestures.dart';
import 'package:handball_performance_tracker/data/models/models.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(GameState()) {

    // TODO implement check that selectedTeam works properly otherwise game cannot be started

    on<GameEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
