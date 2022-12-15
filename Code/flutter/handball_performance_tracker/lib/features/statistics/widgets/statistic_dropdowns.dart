
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/core/constants/strings_general.dart';
import 'package:handball_performance_tracker/features/statistics/bloc/statistics_bloc.dart';
import 'package:handball_performance_tracker/data/models/player_model.dart';
import 'package:handball_performance_tracker/data/models/game_model.dart';
import 'package:handball_performance_tracker/data/models/team_model.dart';
import 'package:logger/logger.dart';

var logger = Logger(
  printer: PrettyPrinter(
      methodCount: 2, // number of method calls to be displayed
      errorMethodCount: 8, // number of method calls if stacktrace is provided
      lineLength: 120, // width of the output
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
      printTime: true // Should each log print contain a timestamp
      ),
);


class PlayerSelector extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final statisticsBlocState = context.watch<StatisticsBloc>().state;

    return DropdownButton<Player>(
      isExpanded: true,
      hint: Text("Select player"),
      value: statisticsBlocState.selectedPlayer,
      icon: Icon(Icons.arrow_drop_down),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (Player? newPlayer) {
        // call event SelectPlayer from StatisticsBloc
        context.read<StatisticsBloc>().add(SelectPlayer(player: newPlayer!));
      },
      items: statisticsBlocState.selectedTeamGamePlayers.map<DropdownMenuItem<Player>>((Player player) {
        return DropdownMenuItem<Player>(
          value: player,
          child: Text(player.firstName + " " + player.lastName),
        );
      }).toList(),
    );
  }
}

class GameSelector extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // get statisticsBloc state
    final statisticsBlocState = context.watch<StatisticsBloc>().state;

    if (statisticsBlocState.selectedTeamGames.length == 0){
      return Text(StringsGeneral.lNoTeamStats);
    }

    return DropdownButton<Game>(
      hint: Text("Select game"),
      isExpanded: true,
      value: statisticsBlocState.selectedGame,
      icon: Icon(Icons.arrow_drop_down),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (Game? newGame) {
        // call SelectGame event from statisticsBloc
        context.read<StatisticsBloc>().add(SelectGame(game: newGame!));
      },
      items: statisticsBlocState.selectedTeamGames.map<DropdownMenuItem<Game>>((Game game) {
        return DropdownMenuItem<Game>(
          value: game,
          // if there is opponent available show opponent. Otherwise show date only
          child: game.opponent != "" ? Text(game.opponent! + " - "+game.date.toString().substring(0, 10)): Text(game.date.toString().substring(0, 10)),
        );
      }).toList(),
    );
  }
}

class TeamSelector extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final statisticsState = context.watch<StatisticsBloc>().state;
    // if statisticsState.allTeams list is empty 

    if (statisticsState.allTeams.length < 1) {
      // logger.d("Team selector cannot be displayer because there are no teams");
      return Text("No teams found");
    }

    return DropdownButton<Team>(
      hint: Text("Select team"),
      isExpanded: true,
      value: statisticsState.selectedTeam,
      icon: Icon(Icons.arrow_drop_down),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (Team? newTeam) {
        // call event SelectTeam
        context.read<StatisticsBloc>().add(SelectTeam(team: newTeam!));
        
      },
      items: statisticsState.allTeams.map<DropdownMenuItem<Team>>((Team team) {
        return DropdownMenuItem<Team>(
          value: team,
          child: Text(team.name.toString()),
        );
      }).toList(),
    );
  }
}
