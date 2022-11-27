import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/features/game_setup/game_setup.dart';
import 'package:handball_performance_tracker/data/models/models.dart';
import 'package:handball_performance_tracker/core/core.dart';

// dropdown that shows all available teams belonging to the selected team type
class TeamDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final globalState = context.watch<GlobalBloc>().state;
    return BlocBuilder<GameSetupCubit, GameSetupState>(builder: (context, state) {
      if (globalState.allTeams.isEmpty) {
        // don't show the dropdown if there are no available teams
        return Center(
            child: Text(
          StringsGeneral.lNoTeamsWarning,
          style: TextStyle(fontSize: 20, color: Colors.blue),
        ));
      }
      return Container(
        width: MediaQuery.of(context).size.width * 0.25,
        child: DropdownButtonFormField<Team>(
            value: globalState.allTeams[state.selectedTeamIndex],
            icon: const Icon(Icons.arrow_drop_down_circle_outlined),
            iconEnabledColor: Colors.black,
            elevation: 16,
            style: TextStyle(fontSize: 18, color: Colors.black),
            dropdownColor: Colors.white,
            decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: buttonDarkBlueColor)),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: buttonDarkBlueColor)),
                disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: buttonDarkBlueColor)),
                labelText: StringsGeneral.lTeam,
                labelStyle: TextStyle(color: buttonDarkBlueColor),
                filled: true,
                fillColor: Colors.white),
            onChanged: (Team? newTeam) {
              int selectedTeamIndex = globalState.allTeams.indexOf(newTeam!);
              context.read<GameSetupCubit>().selectTeam(selectedTeamIndex);
            },
            // build dropdown item widgets
            items: globalState.allTeams.map((Team team) {
              return DropdownMenuItem<Team>(value: team, child: Text(team.name));
            }).toList()),
      );
      // don't show the dropdown for any other states
    });
  }
}
