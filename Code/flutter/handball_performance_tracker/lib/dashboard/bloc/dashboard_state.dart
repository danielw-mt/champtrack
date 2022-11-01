part of 'dashboard_bloc.dart';

enum DashboardStatus { initial, loading, success, failure }

class DashboardState extends Equatable {
  const DashboardState({
    this.status = DashboardStatus.initial,
    this.club = const Club(),
  });

  final DashboardStatus status;
  final Club club;

  DashboardState copyWith({
    DashboardStatus? status,
    Club? club,
  }) {
    return DashboardState(
      status: status ?? this.status,
      club: club ?? this.club,
    );
  }

  @override
  String toString() {
    return '''ClubState { status: $status, club: ${club.toString()} }''';
  }

  @override
  List<Object> get props => [status, club];
}
