import 'package:flutter/material.dart';
import '../../strings.dart';
import '../../data/player.dart';
import '../../controllers/tempController.dart';
import 'package:get/get.dart';

class PlayerForm extends StatefulWidget {
  String playerId;

  PlayerForm([this.playerId = ""]);

  @override
  PlayerFormState createState() {
    return PlayerFormState(playerId);
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class PlayerFormState extends State<PlayerForm> {
  TempController tempController = Get.find<TempController>();

  String playerId;
  PlayerFormState(this.playerId);
  late Player player;
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
  bool editModeEnabled = false;

  @override
  void initState() {
    // if Player form gets passed an empty ID it is new player mode
    if (this.playerId != "") {
      editModeEnabled = true;
      this.player = tempController.getPlayerFromSelectedTeam(this.playerId);
      this.firstNameController.text = player.firstName;
      this.lastNameController.text = player.lastName;
      this.nickNameController.text = player.nickName;
      this.shirtNumberController.text = player.number.toString();
      // otherwise if get a playerID it is edit mode for that specified player
    } else {
      this.player = Player();
      editModeEnabled = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    double width = MediaQuery.of(context).size.width;
    return Column(children: [
      Center(
          child: editModeEnabled
              ? Text(Strings.lPlayerEditMode)
              : Text(Strings.lPlayerCreateMode)),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(Strings.lEditPlayer),
        ElevatedButton(
            onPressed: () {
              // TODO implement delete player
            },
            child: Text(Strings.lDeletePlayer)),
      ]),
      Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: width * 0.25,
                  child: TextFormField(
                    controller: firstNameController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: Strings.lFirstName),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  width: width * 0.25,
                  child: TextFormField(
                    controller: lastNameController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: Strings.lLastName),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            Container(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: width * 0.25,
                  child: TextFormField(
                    controller: nickNameController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: Strings.lNickName),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      // if (value == null || value.isEmpty) {
                      //   return 'Please enter some text';
                      // }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  width: width * 0.25,
                  child: TextFormField(
                    controller: shirtNumberController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: Strings.lShirtNumber),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            Container(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(Strings.lTeams),
                    SizedBox(
                      width: width * 0.25,
                      height: 50,
                      child: ListView(
                        children: [
                          Text("TODO"),
                          Text("Mannschaft"),
                          Text("Mannschaft"),
                          Text("Mannschaft")
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(Strings.lPosition),
                    SizedBox(
                      width: width * 0.25,
                      height: 50,
                      child: ListView.builder(
                        itemCount: 7,
                        shrinkWrap: true,
                        itemBuilder: (context, item) {
                          List<String> positionNames = [
                            Strings.lGoalkeeper,
                            Strings.lLeftBack,
                            Strings.lCenterBack,
                            Strings.lRightBack,
                            Strings.lLeftWinger,
                            Strings.lCenterForward,
                            Strings.lRightWinger
                          ];
                          return Row(
                            children: [
                              Text(positionNames[item]),
                              // TODO implement checkbox
                              Checkbox(value: false, onChanged: (value) {})
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
            Container(
              height: 20,
            ),
            // Submit button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    player.firstName = firstNameController.text;
                    player.lastName = lastNameController.text;
                    player.nickName = nickNameController.text;
                    player.number = int.parse(shirtNumberController.text);
                    // pop alert
                    Navigator.pop(context);
                    // display snackbar while data is stored in db
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text(Strings.lProcessingData)),
                    );
                    // Edit mode
                    if (editModeEnabled) {
                      tempController.setPlayer(player);
                    } else {
                      tempController.addPlayer(player);
                    }
                  }
                },
                child: const Text(Strings.lSubmitButton),
              ),
            ),
          ],
        ),
      )
    ]);
  }
}
