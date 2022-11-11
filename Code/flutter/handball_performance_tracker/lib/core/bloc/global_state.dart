part of 'global_bloc.dart';

enum GlobalStatus { loading, success, failure }

class GlobalState extends Equatable {
  final GlobalStatus status;
  List<Team> allTeams;
  List<Player> allPlayers;
  List<Game> allGames;


  GlobalState({
    this.status = GlobalStatus.loading,
    this.allTeams = const [],
    this.allPlayers = const [],
    this.allGames = const [],
  });

  GlobalState copyWith({
    GlobalStatus? status,
    List<Team>? allTeams,
    List<Player>? allPlayers,
    List<Game>? allGames,
  }) {
    return GlobalState(
      status: status ?? this.status,
      allTeams: allTeams ?? this.allTeams,
      allPlayers: allPlayers ?? this.allPlayers,
      allGames: allGames ?? this.allGames,
    );
  }

  @override
  String toString() {
    return ''' Globalstate {
      status: $status,
      allTeams: $allTeams,
      allPlayers: $allPlayers,
      allGames: $allGames,
    }''';
  }

  @override
  List<Object> get props => [status, allTeams, allPlayers, allGames];
}
