import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:handball_performance_tracker/data/repositories/repositories.dart';
import 'package:handball_performance_tracker/data/models/models.dart';

part 'sidebar_event.dart';
part 'sidebar_state.dart';

class SidebarBloc extends Bloc<SidebarEvent, SidebarState> {
  final ClubRepository clubRepository;

  SidebarBloc({required this.clubRepository}) : super(const SidebarState.initial()) {
    on<SidebarCreated>((event, emit) async {
      print("sidebar created");
      try {
        Club club = await clubRepository.fetchClub();
        emit(SidebarState._().copyWith(status: SidebarStatus.success, club: club));
      } on Exception catch (e) {
        emit(SidebarState._().copyWith(status: SidebarStatus.failure, club: Club(name: "Error")));
      }
    });
    on<GameStarted>((event, emit) async {
      emit(state.copyWith(status: SidebarStatus.gameRunning));
    });
    on<GameStopped>((event, emit) async {
      emit(state.copyWith(status: SidebarStatus.gameNotRunning));
    });
  }
}
