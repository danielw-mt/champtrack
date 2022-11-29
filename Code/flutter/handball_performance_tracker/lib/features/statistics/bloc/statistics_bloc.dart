import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:handball_performance_tracker/data/models/models.dart';

part 'statistics_event.dart';
part 'statistics_state.dart';

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  StatisticsBloc() : super(StatisticsState()) {
    on<StatisticsEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<ChangeTabs>((event, emit) {
      emit(state.copyWith(selectedStatScreenIndex: event.tabIndex));
    });

    on<SelectTeam>((event, emit) {
      emit(state.copyWith(selectedTeam: event.team));
    });
  }
}
