import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/core/constants/game_actions.dart';
import 'package:handball_performance_tracker/core/constants/strings_general.dart';
import 'package:handball_performance_tracker/features/statistics/bloc/statistics_bloc.dart';
import 'package:handball_performance_tracker/oldcontrollers/persistent_controller.dart';
import 'package:handball_performance_tracker/oldcontrollers/temp_controller.dart';
import 'statistic_card_elements.dart';
import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/core/constants/game_actions.dart';
import 'package:handball_performance_tracker/oldcontrollers/persistent_controller.dart';
import 'package:handball_performance_tracker/oldcontrollers/temp_controller.dart';
import 'statistic_card_elements.dart';
import 'package:handball_performance_tracker/data/models/player_model.dart';
import 'package:handball_performance_tracker/data/models/game_model.dart';
import 'package:handball_performance_tracker/data/models/team_model.dart';
import 'package:handball_performance_tracker/core/constants/game_actions.dart';


// class PlayerSelector extends StatefulWidget {
//   final List<Player> players;
//   final Function onPlayerSelected;
//   const PlayerSelector({super.key, required this.players, required this.onPlayerSelected});

//   @override
//   State<PlayerSelector> createState() => _PlayerSelectorState();
// }

class PlayerSelector extends StatelessWidget {
  //Player? _selectedPlayer;

  // @override
  // void initState() {
  //   // prevent null access
  //   if (widget.players.length > 0) {
  //     _selectedPlayer = widget.players[0];
  //   }
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final statisticsBlocState = context.watch<StatisticsBloc>().state;
    // when there are no players created yet
    // if (_selectedPlayer == null) {
    //   logger.d("Player selector cannot be displayer because there are no players");
    //   return Container();
    // }
    // if (widget.players.length == 0){
    //   return Text("No players found");
    // }
    // this gets triggered when we switch to a different team and the old selectedPlayer persists 
    //but cannot be found in the players list in the new team that is passed 
    //to PlayerSelector when the parent menu gets rebuilt
    // if (!widget.players.contains(_selectedPlayer)){
    //   _selectedPlayer = widget.players[0];
    // }
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
        // This is called when the user selects an item.
        // setState(() {
        //   _selectedPlayer = newPlayer!;
        //   widget.onPlayerSelected(_selectedPlayer);
        // });
      },
      items: statisticsBlocState.allPlayers.map<DropdownMenuItem<Player>>((Player player) {
        return DropdownMenuItem<Player>(
          value: player,
          child: Text(player.firstName + " " + player.lastName),
        );
      }).toList(),
    );
  }
}

// class GameSelector extends StatefulWidget {
//   final List<Game> games;
//   final Function onGameSelected;
//   const GameSelector({super.key, required this.games, required this.onGameSelected});

//   @override
//   State<GameSelector> createState() => _GameSelectorState();
// }

class GameSelector extends StatelessWidget {
  // Game? _selectedGame;

  // @override
  // void initState() {
  //   // prevent null access
  //   if (widget.games.length > 0) {
  //     _selectedGame = widget.games[0];
  //   }
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // get statisticsBloc state
    final statisticsBlocState = context.watch<StatisticsBloc>().state;
    // if (_selectedGame == null) {
    //   logger.d("Game selector cannot be displayer because there are no games");
    // }
    if (statisticsBlocState.selectedTeamGames.length == 0){
      return Text(StringsGeneral.lNoTeamStats);
    }
    // if (!widget.games.contains(_selectedGame)){
    //   _selectedGame = widget.games[0];
    // }
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
        // widget.onGameSelected(newGame);
        // // call selectGame event from statisticsBloc
        // context.read<StatisticsBloc>().add(selectGame(newGame));
        // // This is called when the user selects an item.
        // setState(() {
        //   _selectedGame = newGame!;
        // });
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


// class TeamSelector extends StatefulWidget {
//   final List<Team> teams;
//   final Function onTeamSelected;
//   const TeamSelector({super.key, required this.teams, required this.onTeamSelected});

//   @override
//   State<TeamSelector> createState() => _TeamSelectorState();
// }

class TeamSelector extends StatelessWidget {
  //Team? selectedTeam;
  final Function onTeamSelected;
  TeamSelector({required this.onTeamSelected});

  // @override
  // void initState() {
  //   //TempController tempController = Get.find<TempController>();
  //   if (widget.teams.length > 0) {
  //     // if (widget.teams.contains(tempController.getSelectedTeam())) {
  //     //   _selectedTeam = tempController.getSelectedTeam();
  //     // } else {
  //     selectedTeam = widget.teams[0];
  //     // }
  //   }
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final statisticsState = context.watch<StatisticsBloc>().state;
    // if statisticsState.allTeams list is empty 

    if (statisticsState.allTeams.length < 1) {
      // logger.d("Team selector cannot be displayer because there are no teams");
      return Text("No teams found");
    }
    // if (widget.teams.length == 0){
    //   return Text("No teams found");
    // }
    // if (!widget.teams.contains(selectedTeam)){
    //   selectedTeam = widget.teams[0];
    // }
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
