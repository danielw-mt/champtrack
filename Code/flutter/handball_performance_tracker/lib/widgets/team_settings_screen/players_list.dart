import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/constants/colors.dart';
import 'package:handball_performance_tracker/widgets/statistic_screen/statistic_card_elements.dart';
import '../../constants/colors.dart';
import '../../controllers/persistent_controller.dart';
import '../../controllers/temp_controller.dart';
import '../../data/player.dart';
import '../../data/team.dart';
import 'on_field_checkbox.dart';
import '../../constants/stringsGeneral.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'player_edit_form.dart';

class PlayerGridList extends StatelessWidget {
  final List<Player> playersFromSelectedTeam;

  PlayerGridList(List<Player> this.playersFromSelectedTeam);
  @override
  Widget build(BuildContext context) {
    return GridView.count(
        // Create a grid with 3 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        crossAxisCount: 4,
        childAspectRatio: 1.8,
        // Generate #players widgets that display their index in the List.
        children: List.generate(playersFromSelectedTeam.length, (index) {
          return PlayerCard(playersFromSelectedTeam[index], context);
        }));
  }

  Widget PlayerCard(Player player, BuildContext context) {
    return Flexible(
      child: Card(
        margin: EdgeInsets.all(5),
        child: Center(
          child: ListTile(
              leading: CircleAvatar(child: Text(player.number.toString())),
              title: Text(player.firstName + " " + player.lastName),
              subtitle: Text(player.positions.toString()),
              trailing: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)),
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              height: MediaQuery.of(context).size.height * 0.8,
                              child: PlayerForm(player.id.toString())),
                        );
                      },
                    );
                  },
                  child: Text("Edit"))),
        ),
      ),
    );
  }
}

class PlayersList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TempController>(
        id: "players-list",
        builder: (tempController) {
          int numberOfPlayers =
              tempController.getPlayersFromSelectedTeam().length;
          List<Player> playersList =
              tempController.getPlayersFromSelectedTeam();
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
                DataColumn(label: Text(StringsGeneral.lEdit))
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
                        return buttonGreyColor;
                      }
                      return null; // Use default value for other states and odd rows.
                    }),
                    cells: <DataCell>[
                      DataCell(Text(
                          "${playersList[index].firstName} ${playersList[index].lastName}")),
                      DataCell(Text(playersList[index].number.toString())),
                      DataCell(Text(
                        positionsString,
                        softWrap: true,
                      )),
                      DataCell(OnFieldCheckbox(
                        player: playersList[index],
                      )),
                      DataCell(GestureDetector(
                        child: Icon(Icons.edit),
                        onTap: () {
                          Alert(
                            context: context,
                            buttons: [],
                            content: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              height: MediaQuery.of(context).size.height * 0.8,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  PlayerForm(playersList[index].id.toString())
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
            ),
          );
        });
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
