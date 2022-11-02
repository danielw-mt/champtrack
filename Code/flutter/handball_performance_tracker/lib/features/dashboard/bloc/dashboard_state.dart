part of 'dashboard_bloc.dart';

enum DashboardStatus { initial, loading, success, failure }

class DashboardState extends Equatable {
  final DashboardStatus status;
  final Club club;

  const DashboardState._({
    this.status = DashboardStatus.initial,
    this.club = const Club(),
  });

  const DashboardState.initial() : this._();

  DashboardState copyWith({
    DashboardStatus? status,
    Club? club,
  }) {
    return DashboardState._(
      status: status ?? this.status,
      club: club ?? this.club,
    );
  }

  @override
  String toString() {
    return '''DashboardState { status: $status, club: ${club.toString()} }''';
  }

  @override
  List<Object> get props => [status, club];
}
