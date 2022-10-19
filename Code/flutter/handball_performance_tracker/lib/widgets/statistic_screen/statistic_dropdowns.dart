import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/constants/game_actions.dart';
import 'package:handball_performance_tracker/controllers/persistent_controller.dart';
import 'package:handball_performance_tracker/controllers/temp_controller.dart';
import 'statistic_card_elements.dart';
import '../../data/player.dart';
import '../../data/game.dart';
import '../../data/team.dart';
import '../../controllers/temp_controller.dart';
import 'package:get/get.dart';
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

class PlayerSelector extends StatefulWidget {
  final List<Player> players;
  final Function onPlayerSelected;
  const PlayerSelector({super.key, required this.players, required this.onPlayerSelected});

  @override
  State<PlayerSelector> createState() => _PlayerSelectorState();
}

class _PlayerSelectorState extends State<PlayerSelector> {
  Player? _selectedPlayer;

  @override
  void initState() {
    // prevent null access
    if (widget.players.length > 0) {
      _selectedPlayer = widget.players[0];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // when there are no players created yet
    if (_selectedPlayer == null) {
      logger.d("Player selector cannot be displayer because there are no players");
      return Container();
    }
    if (widget.players.length == 0){
      return Text("No players found");
    }
    // this gets triggered when we switch to a different team and the old selectedPlayer persists 
    //but cannot be found in the players list in the new team that is passed 
    //to PlayerSelector when the parent menu gets rebuilt
    if (!widget.players.contains(_selectedPlayer)){
      _selectedPlayer = widget.players[0];
    }
    return DropdownButton<Player>(
      isExpanded: true,
      hint: Text("Select player"),
      value: _selectedPlayer,
      icon: Icon(Icons.arrow_drop_down),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (Player? newPlayer) {
        // This is called when the user selects an item.
        setState(() {
          _selectedPlayer = newPlayer!;
          widget.onPlayerSelected(_selectedPlayer);
        });
      },
      items: widget.players.map<DropdownMenuItem<Player>>((Player player) {
        return DropdownMenuItem<Player>(
          value: player,
          child: Text(player.firstName + " " + player.lastName),
        );
      }).toList(),
    );
  }
}

class GameSelector extends StatefulWidget {
  final List<Game> games;
  final Function onGameSelected;
  const GameSelector({super.key, required this.games, required this.onGameSelected});

  @override
  State<GameSelector> createState() => _GameSelectorState();
}

class _GameSelectorState extends State<GameSelector> {
  Game? _selectedGame;

  @override
  void initState() {
    // prevent null access
    if (widget.games.length > 0) {
      _selectedGame = widget.games[0];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedGame == null) {
      logger.d("Game selector cannot be displayer because there are no games");
    }
    if (widget.games.length == 0){
      return Text("No games found");
    }
    if (!widget.games.contains(_selectedGame)){
      _selectedGame = widget.games[0];
    }
    return DropdownButton<Game>(
      hint: Text("Select game"),
      isExpanded: true,
      value: _selectedGame,
      icon: Icon(Icons.arrow_drop_down),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (Game? newGame) {
        widget.onGameSelected(newGame);
        // This is called when the user selects an item.
        setState(() {
          _selectedGame = newGame!;
        });
      },
      items: widget.games.map<DropdownMenuItem<Game>>((Game game) {
        return DropdownMenuItem<Game>(
          value: game,
          child: Text(game.date.toString()),
        );
      }).toList(),
    );
  }
}


class TeamSelector extends StatefulWidget {
  final List<Team> teams;
  final Function onTeamSelected;
  const TeamSelector({super.key, required this.teams, required this.onTeamSelected});

  @override
  State<TeamSelector> createState() => _TeamSelectorState();
}

class _TeamSelectorState extends State<TeamSelector> {
  Team? _selectedTeam;

  @override
  void initState() {
    TempController tempController = Get.find<TempController>();
    if (widget.teams.length > 0) {
      if (widget.teams.contains(tempController.getSelectedTeam())) {
        _selectedTeam = tempController.getSelectedTeam();
      } else {
        _selectedTeam = widget.teams[0];
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedTeam == null) {
      logger.d("Team selector cannot be displayer because there are no teams");
      return Text("No teams found");
    }
    if (widget.teams.length == 0){
      return Text("No teams found");
    }
    if (!widget.teams.contains(_selectedTeam)){
      _selectedTeam = widget.teams[0];
    }
    return DropdownButton<Team>(
      hint: Text("Select team"),
      isExpanded: true,
      value: _selectedTeam,
      icon: Icon(Icons.arrow_drop_down),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (Team? newTeam) {
        widget.onTeamSelected(newTeam);
        // This is called when the user selects an item.
        setState(() {
          _selectedTeam = newTeam!;
        });
      },
      items: widget.teams.map<DropdownMenuItem<Team>>((Team team) {
        return DropdownMenuItem<Team>(
          value: team,
          child: Text(team.name.toString()),
        );
      }).toList(),
    );
  }
}
