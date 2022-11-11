part of 'global_bloc.dart';

abstract class GlobalEvent extends Equatable {
  const GlobalEvent();

  @override
  List<Object> get props => [];
}

class LoadGlobalState extends GlobalEvent {}

class CreateTeam extends GlobalEvent {
  final Team team;

  CreateTeam({required this.team});

  @override
  List<Object> get props => [team];
}
class UpdateTeam extends GlobalEvent {
  final Team team;

  UpdateTeam({required this.team});

  @override
  List<Object> get props => [team];
}
class DeleteTeam extends GlobalEvent {
  final Team team;

  DeleteTeam({required this.team});

  @override
  List<Object> get props => [team];
}

class CreateGame extends GlobalEvent {
  final Game game;

  CreateGame({required this.game});

  @override
  List<Object> get props => [game];
}
class UpdateGame extends GlobalEvent {
  final Game game;

  UpdateGame({required this.game});

  @override
  List<Object> get props => [game];
}
class DeleteGame extends GlobalEvent {
  final Game game;

  DeleteGame({required this.game});

  @override
  List<Object> get props => [game];
}

class CreatePlayer extends GlobalEvent {
  final Player player;

  CreatePlayer({required this.player});

  @override
  List<Object> get props => [player];
}
class UpdatePlayer extends GlobalEvent {
  final Player player;

  UpdatePlayer({required this.player});

  @override
  List<Object> get props => [player];
}
class DeletePlayer extends GlobalEvent {
  final Player player;

  DeletePlayer({required this.player});

  @override
  List<Object> get props => [player];
}
