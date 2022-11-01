import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:handball_performance_tracker/data/repositories/club_repository.dart';
import 'package:meta/meta.dart';
import 'package:handball_performance_tracker/data/models/models.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final ClubRepository clubRepository;

  DashboardBloc({required this.clubRepository}) : super(DashboardState());

  Future<void> createDashboard() async {
   try {
    Club club = await clubRepository.fetchClub();
    emit(DashboardState().copyWith(status: DashboardStatus.success,club: club));
   } on Exception catch (e) {
     emit(DashboardState().copyWith(status: DashboardStatus.failure, club: Club(name: "Error")));
   }
  }
  
}
