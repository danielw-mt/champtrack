import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/features/game_setup/game_setup.dart';
import 'package:handball_performance_tracker/data/models/models.dart';
import 'package:handball_performance_tracker/core/core.dart';

class PlayersList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<GameSetupCubit>().state;
    final globalState = context.watch<GlobalBloc>().state;
    List<Player> playersList = globalState.allTeams[state.selectedTeamIndex].players;
    int numberOfPlayers = playersList.length;
    return SingleChildScrollView(
      controller: ScrollController(),
      child: DataTable(
        columns: const <DataColumn>[
          DataColumn(
            label: Text(StringsGeneral.lName),
          ),
          DataColumn(
            label: Text(StringsGeneral.lNumber),
          ),
          DataColumn(label: Text(StringsGeneral.lPosition)),
          DataColumn(
              label: Text(
            StringsGeneral.lPlayerStartingOnField,
            softWrap: true,
          )),
          // DataColumn(label: Text(StringsGeneral.lEdit))
        ],
        rows: List<DataRow>.generate(
          numberOfPlayers,
          (int index) {
            String positionsString = playersList[index].positions.reduce((value, element) => value + ", " + element);
            return DataRow(
              color: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
                // All rows will have the same selected color.
                if (states.contains(MaterialState.selected)) {
                  return Theme.of(context).colorScheme.primary.withOpacity(0.08);
                }
                // Even rows will have a grey color.
                if (index.isEven) {
                  return buttonGreyColor;
                }
                return null; // Use default value for other states and odd rows.
              }),
              cells: <DataCell>[
                DataCell(Text("${playersList[index].firstName} ${playersList[index].lastName}")),
                DataCell(Text(playersList[index].number.toString())),
                DataCell(Text(
                  positionsString,
                  softWrap: true,
                )),
                DataCell(Checkbox(
                    value: state.onFieldPlayers.contains(playersList[index]),
                    onChanged: (bool? value) {
                      List<Player> newOnFieldPlayers = List.from(state.onFieldPlayers);
                      // if the value was changed from false to true
                      if (value == true) {
                        // if the player is not already in the list and there are not already 7 players on the field add the player to the list
                        if (!newOnFieldPlayers.contains(playersList[index]) && newOnFieldPlayers.length < 7) {
                          print("adding player to onFieldPlayers");
                          newOnFieldPlayers.add(playersList[index]);
                        }
                        // if the value changed from true to false
                      } else {
                        if (newOnFieldPlayers.contains(playersList[index])) {
                          print("removing player from onFieldPlayers");
                          newOnFieldPlayers.remove(playersList[index]);
                        }
                      }
                      context.read<GameSetupCubit>().setOnFieldPlayers(newOnFieldPlayers);
                    })),
                // DataCell(GestureDetector(
                //   child: Icon(Icons.edit),
                //   onTap: () {
                //     // TODO replace this alert
                //     // Alert(
                //     //   context: context,
                //     //   buttons: [],
                //     //   content: SizedBox(
                //     //     width: MediaQuery.of(context).size.width * 0.7,
                //     //     height: MediaQuery.of(context).size.height * 0.8,
                //     //     child: Column(
                //     //       mainAxisAlignment: MainAxisAlignment.center,
                //     //       children: [PlayerForm(playersList[index].id.toString())],
                //     //     ),
                //     //   ),
                //     // ).show();
                //   },
                // ))
              ],
            );
          },
        ),
      ),
    );
  }

  // TODO this is not really needed right?!
  // void removePlayerFromTeam(Player player) {
  //   // in order to update the team in the teams list of the local state
  //   Team selectedCacheTeam =
  //       persistentController.getAvailableTeams().where((cachedTeamItem) => (cachedTeamItem.id == tempController.getSelectedTeam().id)).toList()[0];
  //   selectedCacheTeam.players.remove(player);
  //   // update selected team with the player list as well
  //   tempController.setSelectedTeam(selectedCacheTeam);
  //   // remove the player from onFieldPlayers if necessary
  //   if (tempController.getOnFieldPlayers().contains(player)) {
  //     tempController.removeOnFieldPlayer(player);
  //   }
  // }
}
