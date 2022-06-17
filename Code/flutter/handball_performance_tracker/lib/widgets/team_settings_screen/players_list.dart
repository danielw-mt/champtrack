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
                DataColumn(label: Text("Starts on Field (temporary)")),
                DataColumn(label: Text(Strings.lEdit))
              ],
              rows: List<DataRow>.generate(
                numberOfPlayers,
                (int index) {
                  String positionsString = playersList[index]
                      .positions
                      .reduce((value, element) => value + ", " + element);
                  String firstName = playersList[index].firstName;
                  String lastName = playersList[index].lastName;
                  String shirtNumber = playersList[index].number.toString();
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
                                    firstName: firstName,
                                    lastName: lastName,
                                    shirtNumber: shirtNumber,
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

class PlayerForm extends StatefulWidget {
  final String firstName = "";
  final String lastName = "";
  final String nickName = "";
  final String shirtNumber = "";

  const PlayerForm({super.key, firstName, lastName, nickName, shirtNumber});

  @override
  PlayerFormState createState() {
    return PlayerFormState(
        firstName: firstName,
        lastName: lastName,
        nickName: nickName,
        shirtNumber: shirtNumber);
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class PlayerFormState extends State<PlayerForm> {
  String firstName = "";
  String lastName = "";
  String nickName = "";
  String shirtNumber = "";
  PlayerFormState({required this.firstName, lastName, nickName, shirtNumber});

  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController nickNameController = TextEditingController();
  TextEditingController shirtNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    firstNameController.text = firstName;
    lastNameController.text = lastName;

    shirtNumberController.text = shirtNumber;
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(children: [
            TextFormField(
              controller: firstNameController,
              obscureText: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: Strings.lFirstName),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          ]),
          //     TextFormField(
          //       controller: lastNameController,
          //       obscureText: true,
          //       decoration: InputDecoration(
          //           border: OutlineInputBorder(), labelText: Strings.lLastName),
          //       // The validator receives the text that the user has entered.
          //       validator: (value) {
          //         if (value == null || value.isEmpty) {
          //           return 'Please enter some text';
          //         }
          //         return null;
          //       },
          //     ),
          //   ],
          // ),
          // Row(
          //   children: [
          //     TextFormField(
          //       controller: nickNameController,
          //       obscureText: true,
          //       decoration: InputDecoration(
          //           border: OutlineInputBorder(), labelText: Strings.lNickName),
          //       // The validator receives the text that the user has entered.
          //       validator: (value) {
          //         if (value == null || value.isEmpty) {
          //           return 'Please enter some text';
          //         }
          //         return null;
          //       },
          //     ),
          //     TextFormField(
          //       controller: shirtNumberController,
          //       keyboardType: TextInputType.number,
          //       obscureText: true,
          //       decoration: InputDecoration(
          //           border: OutlineInputBorder(),
          //           labelText: Strings.lShirtNumber),
          //       // The validator receives the text that the user has entered.
          //       validator: (value) {
          //         if (value == null || value.isEmpty) {
          //           return 'Please enter some text';
          //         }
          //         return null;
          //       },
          //     ),
          //   ],
          // ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 16.0),
          //   child: ElevatedButton(
          //     onPressed: () {
          //       // Validate returns true if the form is valid, or false otherwise.
          //       if (_formKey.currentState!.validate()) {
          //         // If the form is valid, display a snackbar. In the real world,
          //         // you'd often call a server or save the information in a database.
          //         ScaffoldMessenger.of(context).showSnackBar(
          //           const SnackBar(content: Text('Processing Data')),
          //         );
          //       }
          //     },
          //     child: const Text('Submit'),
          //   ),
          // ),
        ],
      ),
    );
  }
}
