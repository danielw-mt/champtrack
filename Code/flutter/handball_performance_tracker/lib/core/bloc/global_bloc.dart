import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:handball_performance_tracker/data/ef_score.dart';
import 'package:handball_performance_tracker/data/repositories/repositories.dart';
import 'package:handball_performance_tracker/data/models/models.dart';
import 'package:handball_performance_tracker/data/entities/entities.dart';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'dart:convert';

part 'global_event.dart';
part 'global_state.dart';

class GlobalBloc extends Bloc<GlobalEvent, GlobalState> {
  GameFirebaseRepository gameRepository;
  TeamFirebaseRepository teamRepository;
  PlayerFirebaseRepository playerRepository;

  GlobalBloc(
      {required GameFirebaseRepository this.gameRepository,
      required TeamFirebaseRepository this.teamRepository,
      required PlayerFirebaseRepository this.playerRepository})
      : super(GlobalState().copyWith(status: GlobalStatus.loading)) {
    on<LoadGlobalState>((event, emit) async {
      print("LoadGlobalState event received");
      try {
        if (state.status == GlobalStatus.success) {
          print("already loaded");
          emit(state.copyWith(status: GlobalStatus.success));
          return;
        }
        emit(state.copyWith(status: GlobalStatus.loading));
        List<Player> fetchedPlayers = await playerRepository.fetchPlayers();
        List<Team> fetchedTeams =
            await teamRepository.fetchTeams(allPlayers: fetchedPlayers);
        // if no teams exist yet for this account create one from the template via api
        if (fetchedTeams.length == 0) {
          this.add(GetTemplateTeam());
        } else {
          List<Game> fetchedGames = await gameRepository.fetchGames();
          emit(state.copyWith(
              status: GlobalStatus.success,
              allTeams: fetchedTeams,
              allPlayers: fetchedPlayers,
              allGames: fetchedGames));
        }
      } catch (e) {
        developer.log('Failure loading teams or players ' + e.toString(),
            name: this.runtimeType.toString(), error: e);
        emit(state.copyWith(status: GlobalStatus.failure));
      }
    });

    on<CreateTeam>((event, emit) async {
      if (state.allTeams.contains(event.team)) {
        print("team already exists");
        emit(state.copyWith(status: GlobalStatus.success));
      }
      try {
        emit(state.copyWith(status: GlobalStatus.loading));
        Team newTeam = await TeamFirebaseRepository().createTeam(event.team);
        emit(state.copyWith(
            allTeams: [...state.allTeams, newTeam],
            status: GlobalStatus.success));
        print("created team");
      } catch (e) {
        developer.log('Failure creating team ' + e.toString(),
            name: this.runtimeType.toString(), error: e);
        emit(state.copyWith(status: GlobalStatus.failure));
      }
    });

    on<UpdateTeam>((event, emit) async {
      print("trying to update team");
      try {
        emit(state.copyWith(status: GlobalStatus.loading));
        print("entered update team" + event.team.toString());
        await TeamFirebaseRepository().updateTeam(event.team);
        // print("event team" + event.team.name.toString());
        // print("event team" + event.team.id.toString());
        // updated teams is where the team with the same id as the updated team is replaced with the updated team
        List<Team> updatedTeams = state.allTeams
            .map((team) => team.id == event.team.id ? event.team : team)
            .toList();
        print("updated teams" + updatedTeams.toString());
        emit(state.copyWith(
            allTeams: updatedTeams, status: GlobalStatus.success));
      } catch (e) {
        developer.log('Failure updating team ' + e.toString(),
            name: this.runtimeType.toString(), error: e);
        emit(state.copyWith(status: GlobalStatus.failure));
      }
    });

    on<DeleteTeam>((event, emit) async {
      try {
        emit(state.copyWith(status: GlobalStatus.loading));
        // first delete all player entities clean from db before deleting team entity
        event.team.players.forEach((player) async {
          // print("deleting player: " + player.firstName + "" + player.lastName + " from team: " + event.team.name + "");
          await PlayerFirebaseRepository().deletePlayer(player);
        });
        await TeamFirebaseRepository().deleteTeam(event.team);
        // updated teams are all teams where the id does not match the deleted team
        List<Team> updatedTeams =
            state.allTeams.where((team) => team.id != event.team.id).toList();
        emit(state.copyWith(
            allTeams: updatedTeams, status: GlobalStatus.success));
      } catch (e) {
        developer.log('Failure deleting team ' + e.toString(),
            name: this.runtimeType.toString(), error: e);
        emit(state.copyWith(status: GlobalStatus.failure));
      }
    });

    on<CreatePlayer>((event, emit) async {
      if (state.allPlayers.contains(event.player)) {
        emit(state.copyWith(status: GlobalStatus.success));
        print("player already exists");
      }
      try {
        emit(state.copyWith(status: GlobalStatus.loading));
        Player newPlayer =
            await PlayerFirebaseRepository().createPlayer(event.player);
        emit(state.copyWith(
            allPlayers: [...state.allPlayers, newPlayer],
            status: GlobalStatus.success));
        print("player created");
      } catch (e) {
        developer.log('Failure creating player ' + e.toString(),
            name: this.runtimeType.toString(), error: e);
        emit(state.copyWith(status: GlobalStatus.failure));
      }
    });

    on<UpdatePlayer>((event, emit) async {
      try {
        emit(state.copyWith(status: GlobalStatus.loading));
        await PlayerFirebaseRepository().updatePlayer(event.player);
        // updated players is where the player with the same id as the updated player is replaced with the updated player
        List<Player> updatedPlayers = state.allPlayers
            .map((player) =>
                player.id == event.player.id ? event.player : player)
            .toList();
        emit(state.copyWith(
            allPlayers: updatedPlayers, status: GlobalStatus.success));
      } catch (e) {
        developer.log('Failure updating player ' + e.toString(),
            name: this.runtimeType.toString(), error: e);
        emit(state.copyWith(status: GlobalStatus.failure));
      }
    });

    on<DeletePlayer>((event, emit) async {
      try {
        emit(state.copyWith(status: GlobalStatus.loading));
        await PlayerFirebaseRepository().deletePlayer(event.player);
        // updated players are all players where the id does not match the deleted player
        List<Player> updatedPlayers = state.allPlayers
            .where((player) => player.id != event.player.id)
            .toList();
        emit(state.copyWith(
            allPlayers: updatedPlayers, status: GlobalStatus.success));
      } catch (e) {
        developer.log('Failure deleting player ' + e.toString(),
            name: this.runtimeType.toString(), error: e);
        emit(state.copyWith(status: GlobalStatus.failure));
      }
    });

    on<ResetPlayerScores>((event, emit) => state.allTeams.forEach((team) =>
        team.players.forEach((player) => player.efScore = LiveEfScore())));

    on<CreateGame>((event, emit) async {
      if (state.allGames.contains(event.game)) {
        print("game already exists");
        emit(state.copyWith(status: GlobalStatus.success));
      }
      try {
        emit(state.copyWith(status: GlobalStatus.loading));
        await GameFirebaseRepository().createGame(event.game);
        emit(state.copyWith(
            allGames: [...state.allGames, event.game],
            status: GlobalStatus.success));
        print("game created");
      } catch (e) {
        developer.log('Failure creating game ' + e.toString(),
            name: this.runtimeType.toString(), error: e);
        emit(state.copyWith(status: GlobalStatus.failure));
      }
    });

    on<UpdateGame>((event, emit) async {
      try {
        emit(state.copyWith(status: GlobalStatus.loading));
        this.gameRepository.updateGame(event.game);
        // updated games is where the game with the same id as the updated game is replaced with the updated game
        List<Game> updatedGames = state.allGames
            .map((game) => game.id == event.game.id ? event.game : game)
            .toList();
        emit(state.copyWith(
            allGames: updatedGames, status: GlobalStatus.success));
      } catch (e) {
        developer.log('Failure updating game ' + e.toString(),
            name: this.runtimeType.toString(), error: e);
        emit(state.copyWith(status: GlobalStatus.failure));
      }
    });

    on<DeleteGame>((event, emit) async {
      try {
        emit(state.copyWith(status: GlobalStatus.loading));
        this.gameRepository.deleteGame(event.game);
        // updated games are all games where the id does not match the deleted game
        List<Game> updatedGames =
            state.allGames.where((game) => game.id != event.game.id).toList();
        emit(state.copyWith(
            allGames: updatedGames, status: GlobalStatus.success));
      } catch (e) {
        developer.log('Failure deleting game ' + e.toString(),
            name: this.runtimeType.toString(), error: e);
        emit(state.copyWith(status: GlobalStatus.failure));
      }
    });

    /// Create a template team from json file in firebase storage
    /// This is called only one time when a new club is created first
    on<GetTemplateTeam>((event, emit) async {
      String apiLink =
          "https://firebasestorage.googleapis.com/v0/b/handball-tracker-dev.appspot.com/o/public%2Fsetup_data.json?alt=media&token=c48e366d-3b45-4105-8f7d-2a0ba23ed054";
      try {
        var response = await http.get(Uri.parse(apiLink));
        if (response.statusCode == 200) {
          // If the server did return a 200 OK response,
          // then parse the JSON.
          final Map<String, dynamic> data = json.decode(response.body);
          // get example players
          List<Player> examplePlayers = [];
          await Future.forEach(data["example_players"], (player_json) async {
            PlayerEntity playerEntity =
                await PlayerEntity.fromJson(player_json);
            Player player = await Player.fromEntity(playerEntity);
            examplePlayers.add(player);
          });
          TeamEntity teamEntity = await TeamEntity.fromJson(data["example_team"]);
          Team templateTeam = await Team.fromEntity(teamEntity, allPlayers: examplePlayers);
          Game templateGame = await Game.fromEntity(
              await GameEntity.fromJson(data["example_game"]));
          // add template players, template team and template game to the global state
          examplePlayers.forEach((element) {
            this.add(CreatePlayer(player: element));
          });
          this.add(CreateTeam(team: templateTeam));
          this.add(CreateGame(game: templateGame));
        } else {
          // If the server did not return a 200 OK response,
          // then throw an exception.
          throw Exception('Failed to load template team');
        }
      } catch (e) {
        print("Error in GetTemplateTeam event: $e");
      }
    });
  }
}
