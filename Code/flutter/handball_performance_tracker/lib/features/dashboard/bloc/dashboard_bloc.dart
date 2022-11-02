import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:handball_performance_tracker/data/repositories/repositories.dart';
import 'package:handball_performance_tracker/data/models/models.dart';
import 'dart:developer' as developer;
part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final ClubRepository clubRepository;

  DashboardBloc({required this.clubRepository}) : super(const DashboardState.initial()) {
    on<DashboardCreated>((event, emit) async {
      try {
        Club club = await clubRepository.fetchClub();
        emit(DashboardState._().copyWith(status: DashboardStatus.success, club: club));
      } on Exception catch (e) {
        emit(DashboardState._().copyWith(status: DashboardStatus.failure, club: Club(name: "Error")));
        developer.log('Failure loading dashboard', name: 'DashboardBloc', error: e);
      }
    });
  }
}
