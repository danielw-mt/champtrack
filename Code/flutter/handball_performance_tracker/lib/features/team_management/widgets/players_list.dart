import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/core/constants/stringsTeamManagement.dart';
import 'package:handball_performance_tracker/features/team_management/team_management.dart';
import 'package:handball_performance_tracker/core/constants/colors.dart';
import 'package:handball_performance_tracker/data/models/player_model.dart';
import 'package:handball_performance_tracker/data/models/team_model.dart';
import 'package:handball_performance_tracker/core/constants/stringsGeneral.dart';
import 'package:handball_performance_tracker/core/core.dart';

class PlayersList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<TeamManagementCubit>().state;
    final globalState = context.watch<GlobalBloc>().state;

    List<Player> playersList = globalState.allTeams[state.selectedTeamIndex].players;
    int numberOfPlayers = playersList.length;
    if (globalState.status == GlobalStatus.loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
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
          // Daniel 13.11.22 - Not using onFieldCheckbox in teamMangement for now
          // DataColumn(
          //     label: Text(
          //   StringsGeneral.lPlayerStartingOnField,
          //   softWrap: true,
          // )),
          DataColumn(label: Text(StringsGeneral.lEdit)),
          DataColumn(label: Text(StringsTeamManagement.lRemovePlayer))
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
                DataCell(GestureDetector(
                  child: Icon(Icons.edit),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: Text(StringsGeneral.lEditPlayer),
                              content: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                height: MediaQuery.of(context).size.height * 0.8,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [PlayerForm(editModeEnabled: true, player: playersList[index])],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: Text(StringsGeneral.lCancel),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text(StringsGeneral.lSubmitButton),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ));
                  },
                )),
                DataCell(GestureDetector(
                  child: Icon(Icons.delete),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: Text(StringsTeamManagement.lRemovePlayer),
                              content: SizedBox(
                                child: Text(StringsTeamManagement.lRemovePlayerConfirmation),
                              ),
                              actions: [
                                TextButton(
                                  child: Text(StringsGeneral.lCancel),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text(StringsTeamManagement.lConfirm),
                                  onPressed: () {
                                    // update the team
                                    Team updatedTeam = globalState.allTeams[state.selectedTeamIndex];
                                    updatedTeam.players.remove(playersList[index]);
                                    if (updatedTeam.onFieldPlayers.contains(playersList[index])) {
                                      updatedTeam.onFieldPlayers.remove(playersList[index]);
                                    }
                                    // update the player references in the rel
                                    context.read<GlobalBloc>().add(UpdateTeam(team: updatedTeam));
                                    // if the player was only part of this team then delete this player from the players collection
                                    if (playersList[index].teams.length == 1) {
                                      context.read<GlobalBloc>().add(DeletePlayer(player: playersList[index]));
                                    } else {
                                      // otherwise update the player
                                      Player updatedPlayer = playersList[index];
                                      updatedPlayer.teams.remove(updatedTeam.id);
                                      context.read<GlobalBloc>().add(UpdatePlayer(player: updatedPlayer));
                                    }
                                    playersList.removeAt(index);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ));
                  },
                )),
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
