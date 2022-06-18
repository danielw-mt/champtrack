import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/../controllers/globalController.dart';
import '../../data/player.dart';
import '../../data/team.dart';
import '../../data/database_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'on_field_checkbox.dart';
import '../../strings.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'player_edit_form.dart';

class PlayersList extends GetView<GlobalController> {
  DatabaseRepository repository = DatabaseRepository();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<GlobalController>(
      builder: (globalController) {
        int numberOfPlayers =
            globalController.selectedTeam.value.players.length;
        List<Player> playersList = globalController.selectedTeam.value.players;
        return SizedBox(
            width: double.infinity,
            child: DataTable(
              columns: const <DataColumn>[
                DataColumn(
                  label: Text(Strings.lName),
                ),
                DataColumn(
                  label: Text(Strings.lNumber),
                ),
                DataColumn(label: Text(Strings.lPosition)),
                DataColumn(label: Text(Strings.lPlayerStartingOnField)),
                DataColumn(label: Text(Strings.lEdit))
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
                                        Text(Strings.lEditPlayer),
                                        ElevatedButton(
                                            onPressed: () {
                                              // TODO implement delete player
                                            },
                                            child: Text(Strings.lDeletePlayer)),
                                      ]),
                                  PlayerForm(
                                    playerId: playerId
                                  )
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
    // need to get fresh globalController here every time the method is called
    final GlobalController globalController = Get.find<GlobalController>();
    // in order to update the team in the teams list of the local state
    Team selectedCacheTeam = globalController.cachedTeamsList
        .where((cachedTeamItem) =>
            (cachedTeamItem.id == globalController.selectedTeam.value.id))
        .toList()[0];
    selectedCacheTeam.players.remove(player);
    // update selected team with the player list as well
    globalController.selectedTeam.value = selectedCacheTeam;
    // remove the player from onFieldPlayers if necessary
    if (globalController.selectedTeam.value.onFieldPlayers.contains(player)) {
      globalController.selectedTeam.value.onFieldPlayers.remove(player);
    }
    globalController.refresh();
  }
}


