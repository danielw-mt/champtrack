part of 'sidebar_bloc.dart';

enum SidebarStatus { initial, loading, success, failure, gameRunning, gameNotRunning }

class SidebarState extends Equatable {
  final SidebarStatus status;
  final Club club;

  const SidebarState._({this.status = SidebarStatus.initial, this.club = const Club()});

  const SidebarState.initial() : this._();

  SidebarState copyWith({
    SidebarStatus? status,
    Club? club,
  }) {
    return SidebarState._(
      status: status ?? this.status,
      club: club ?? this.club,
    );
  }

  @override
  String toString() {
    return '''SidebarState { status: $status, club: ${club.toString()} }''';
  }

  @override
  List<Object> get props => [status, club];
}
