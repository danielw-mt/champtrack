part of 'sidebar_bloc.dart';

abstract class SidebarEvent extends Equatable {
  const SidebarEvent();

  @override
  List<Object> get props => [];
}

class SidebarCreated extends SidebarEvent {
  const SidebarCreated();
}

class GameStarted extends SidebarEvent {
  const GameStarted();
}

class GameStopped extends SidebarEvent {
  const GameStopped();
}