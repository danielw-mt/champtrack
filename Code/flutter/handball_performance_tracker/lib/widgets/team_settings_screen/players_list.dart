import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/constants/stringsTeamManagement.dart';
import '../../controllers/persistentController.dart';
import '../../controllers/tempController.dart';
import '../../data/player.dart';
import '../../data/team.dart';
import 'on_field_checkbox.dart';
import '../../constants/stringsGeneral.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'player_edit_form.dart';

class PlayersList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TempController>(
      id: "players-list",
      builder: (globalController) {
        int numberOfPlayers =
            globalController.getPlayersFromSelectedTeam().length;
        List<Player> playersList = globalController.getPlayersFromSelectedTeam();
        return SizedBox(
            width: double.infinity,
            child: DataTable(
              columns: const <DataColumn>[
                DataColumn(
                  label: Text(StringsGeneral.lName),
                ),
                DataColumn(
                  label: Text(StringsGeneral.lNumber),
                ),
                DataColumn(label: Text(StringsGeneral.lPosition)),
                DataColumn(label: Text(StringsTeamManagement.lPlayerStartingOnField)),
                DataColumn(label: Text(StringsTeamManagement.lEdit))
              ],
              rows: List<DataRow>.generate(
                numberOfPlayers,
                (int index) {
                  String positionsString = playersList[index]
                      .positions
                      .reduce((value, element) => value + ", " + element);
                  String playerId = playersList[index].id.toString();

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
                        return Colors.grey.withOpacity(0.3);
                      }
                      return null; // Use default value for other states and odd rows.
                    }),
                    cells: <DataCell>[
                      DataCell(Text(
                          "${playersList[index].firstName} ${playersList[index].lastName}")),
                      DataCell(Text(playersList[index].number.toString())),
                      DataCell(Text(positionsString)),
                      DataCell(OnFieldCheckbox(
                        player: playersList[index],
                      )),
                      DataCell(GestureDetector(
                        child: Icon(Icons.edit),
                        onTap: () {
                          Alert(
                            context: context,
                            content: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              height: MediaQuery.of(context).size.height * 0.8,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(StringsTeamManagement.lEditPlayer),
                                        ElevatedButton(
                                            onPressed: () {
                                              // TODO implement delete player
                                            },
                                            child: Text(StringsTeamManagement.lDeletePlayer)),
                                      ]),
                                  PlayerForm(playerId: playerId)
                                ],
                              ),
                            ),
                          ).show();
                        },
                      ))
                    ],
                  );
                },
              ),
            ));
      },
    );
  }

  void removePlayerFromTeam(Player player) {
    // need to get fresh persistentController here every time the method is called
    final PersistentController persistentController =
        Get.find<PersistentController>();
    final TempController tempController = Get.find<TempController>();
    // in order to update the team in the teams list of the local state
    Team selectedCacheTeam = persistentController
        .getAvailableTeams()
        .where((cachedTeamItem) =>
            (cachedTeamItem.id == tempController.getSelectedTeam().id))
        .toList()[0];
    selectedCacheTeam.players.remove(player);
    // update selected team with the player list as well
    tempController.setSelectedTeam(selectedCacheTeam);
    // remove the player from onFieldPlayers if necessary
    if (tempController.getOnFieldPlayers().contains(player)) {
      tempController.removeOnFieldPlayer(player);
    }
  }
}
