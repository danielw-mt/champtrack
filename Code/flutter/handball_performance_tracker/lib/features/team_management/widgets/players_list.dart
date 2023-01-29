import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/features/team_management/team_management.dart';
import 'package:handball_performance_tracker/data/models/player_model.dart';
import 'package:handball_performance_tracker/data/models/team_model.dart';
import 'package:handball_performance_tracker/core/core.dart';

class PlayersList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final teamManBloc = context.watch<TeamManagementBloc>();
    final globalState = context.watch<GlobalBloc>().state;

    if (globalState.allTeams.length == 0) {
      return Center(
        child: Text(StringsGeneral.lNoPlayersWarning),
      );
    }
    teamManBloc.state.playerList =
        globalState.allTeams[teamManBloc.state.selectedTeamIndex].players;
    if (teamManBloc.state.playerList.length == 0) {
      return Center(
        child: Text(StringsGeneral.lNoPlayersWarning),
      );
    }
    int numberOfPlayers = teamManBloc.state.playerList.length;
    print("Anzahl Spieler: $numberOfPlayers");
    if (globalState.status == GlobalStatus.loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return SingleChildScrollView(
      controller: ScrollController(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(globalState.allTeams[teamManBloc.state.selectedTeamIndex].name),
          DataTable(
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
                String positionsString = teamManBloc.state.playerList[index]
                    .positions
                    .reduce((value, element) => value + ", " + element);
                return DataRow(
                  color: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                    // All rows will have the same selected color.
                    if (states.contains(MaterialState.selected)) {
                      return Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.08);
                    }
                    // Even rows will have a grey color.
                    if (index.isEven) {
                      return buttonGreyColor;
                    }
                    return null; // Use default value for other states and odd rows.
                  }),
                  cells: <DataCell>[
                    DataCell(Text(
                        "${teamManBloc.state.playerList[index].firstName} ${teamManBloc.state.playerList[index].lastName}")),
                    DataCell(Text(teamManBloc.state.playerList[index].number.toString())),
                    DataCell(Text(
                      positionsString,
                      softWrap: true,
                    )),
                    DataCell(GestureDetector(
                      child: Icon(Icons.edit),
                      onTap: () {
                        teamManBloc
                            .add(SetSelectedPlayer(player: teamManBloc.state.playerList[index]));
                        teamManBloc.add(SelectViewField(
                            viewField: TeamManagementViewField.editPlayer));
                        // showDialog(
                        //     context: context,
                        //     builder: (BuildContext context) => AlertDialog(
                        //           title: Text(StringsGeneral.lEditPlayer),
                        //           content: SizedBox(
                        //             width:
                        //                 MediaQuery.of(context).size.width * 0.7,
                        //             height: MediaQuery.of(context).size.height *
                        //                 0.8,
                        //             child: Column(
                        //               mainAxisAlignment:
                        //                   MainAxisAlignment.center,
                        //               children: [
                        //                 PlayerForm(
                        //                     editModeEnabled: true,
                        //                     player: playersList[index])
                        //               ],
                        //             ),
                        //           ),
                        //           actions: [
                        //             TextButton(
                        //               child: Text(StringsGeneral.lCancel),
                        //               onPressed: () {
                        //                 Navigator.of(context).pop();
                        //               },
                        //             ),
                        //             TextButton(
                        //               child: Text(StringsGeneral.lSubmitButton),
                        //               onPressed: () {
                        //                 Navigator.of(context).pop();
                        //               },
                        //             ),
                        //           ],
                        //         ));
                      },
                    )),
                    DataCell(GestureDetector(
                      child: Icon(Icons.delete),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  title:
                                      Text(StringsTeamManagement.lRemovePlayerWarning),
                                  content: SizedBox(
                                    child: Text(StringsTeamManagement
                                        .lRemovePlayerConfirmation),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text(StringsGeneral.lCancel),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child:
                                          Text(StringsTeamManagement.lConfirm),
                                      
                                      onPressed: () {
                                        // print("index " + index.toString());
                                        // update the team
                                        Team updatedTeam = globalState.allTeams[
                                            teamManBloc
                                                .state.selectedTeamIndex];
                                        // print("Team zu updaten: " + updatedTeam.name);

                                        Player playerToDelete = teamManBloc.state.playerList[index];
                                        // print("player to delete " + playerToDelete.toString());
                                                
                                        if (updatedTeam.onFieldPlayers.contains(teamManBloc.state.playerList[index])) {
                                          // print("remove player from onFieldPlayers "+teamManBloc.state.playerList[index].lastName);
                                          updatedTeam.onFieldPlayers.remove(playerToDelete);
                                        }
                                        updatedTeam.players.remove(playerToDelete);
                                        // print("updated team nb players " + teamManBloc.state.playerList.length.toString());

                                        // print("bloc update team " + updatedTeam.toString());
                                        // update the player references in the rel
                                        context.read<GlobalBloc>().add(UpdateTeam(team: updatedTeam));
                                        
                                        context.read<GlobalBloc>().add( 
                                            DeletePlayer(player: playerToDelete));

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
          )
        ],
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
