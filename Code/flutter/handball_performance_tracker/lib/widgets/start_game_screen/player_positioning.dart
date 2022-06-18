import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/../controllers/globalController.dart';
import '../../data/database_repository.dart';
import '../../strings.dart';
import '../../data/player.dart';

class PlayerPositioning extends StatefulWidget {
  const PlayerPositioning({Key? key}) : super(key: key);

  @override
  State<PlayerPositioning> createState() => _PlayerPositioningState();
}

class _PlayerPositioningState extends State<PlayerPositioning> {

  /// Map containing each player element and the List of positions corresponding to that player
  Map<Player, List<String>> playerMap = {};

  /// List of currently selected positions in the menu. Index corresponds to the row in the menu
  List<String> selectedPositions = [];
  int numberOfPlayers = 0;

  @override
  void initState() {
    GlobalController globalController = Get.find<GlobalController>();
    numberOfPlayers = globalController.selectedTeam.value.onFieldPlayers.length;
    // fill data structures in state
    List<Player> onFieldPlayers =
        globalController.selectedTeam.value.onFieldPlayers;
    onFieldPlayers.forEach((Player player) {
      playerMap[player] = player.positions;
      selectedPositions.add(player.positions[0]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: DataTable(
          columns: const <DataColumn>[
            DataColumn(label: Text(Strings.lPlayer)),
            DataColumn(label: Text(Strings.lShirtNumber)),
            DataColumn(
              label: Text(Strings.lPosition),
            ),
          ],
          rows: List<DataRow>.generate(
            numberOfPlayers,
            (int index) {
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
                  // column 1: first and last name of player
                  DataCell(Text(
                      "${playerMap.keys.elementAt(index).firstName} ${playerMap.keys.elementAt(index).firstName}")),
                  // column 2: number of player
                  DataCell(
                      Text(playerMap.keys.elementAt(index).number.toString())),
                  // column 3: position of player that can be changed
                  DataCell(SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        // button to go to last possible pos
                        GestureDetector(
                          child: Icon(Icons.arrow_left),
                          onTap: () {
                            List<String> playerPositions =
                                playerMap.values.elementAt(index);
                            String currentlySelectedPosition =
                                selectedPositions[index];
                            int indexOfSelectedPosition = playerPositions
                                .indexOf(currentlySelectedPosition);
                            // if there is a player position before the currently
                            //selected one in the positions of the player in Player
                            //Map update the selected positions
                            if (indexOfSelectedPosition > 0) {
                              setState(() {
                                selectedPositions[index] = playerMap.values
                                    .elementAt(
                                        index)[(indexOfSelectedPosition - 1)];
                              });
                              return;
                            }
                          },
                        ),
                        // text that displays selected pos
                        Text(selectedPositions[index]),
                        // button to go to next possible pos. Logic analog to other button
                        GestureDetector(
                          child: Icon(Icons.arrow_right),
                          onTap: () {
                            List<String> playerPositions =
                                playerMap.values.elementAt(index);
                            String currentlySelectedPosition =
                                selectedPositions[index];
                            int indexOfSelectedPosition = playerPositions
                                .indexOf(currentlySelectedPosition);
                            if (indexOfSelectedPosition <
                                playerMap.values.elementAt(index).length) {
                              setState(() {
                                selectedPositions[index] = playerMap.values
                                    .elementAt(
                                        index)[(indexOfSelectedPosition + 1)];
                              });
                              return;
                            }
                          },
                        )
                      ],
                    ),
                  )),
                ],
              );
            },
          ),
        ));
  }
}
