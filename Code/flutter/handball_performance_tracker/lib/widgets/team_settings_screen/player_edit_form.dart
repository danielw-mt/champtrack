import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/constants/positions.dart';
import '../../constants/colors.dart';
import '../../constants/stringsGeneral.dart';
import 'package:handball_performance_tracker/controllers/persistent_controller.dart';
import 'package:handball_performance_tracker/data/team.dart';
import '../../data/player.dart';
import '../../data/club.dart';
import '../../data/database_repository.dart';
import '../../controllers/temp_controller.dart';
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
  PersistentController persistentController = Get.find<PersistentController>();
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
  List<Team> availableTeams = [];

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
      // assignPlayerClubId();
      // replace the constant lists in player (in default constructor) with dynamic ones
      this.player.teams = <String>[];
      this.player.positions = <String>[];
      this.player.games = <String>[];
      editModeEnabled = false;
    }
    print("team: " + player.teams.length.toString());
    availableTeams = persistentController.getAvailableTeams();
    super.initState();
  }

  /// checks whether one of the team reference corresponding to player i.e.
  /// "teams/ehVAJ85ILdS4tCVZcwHZ" contains the teamId "ehVAJ85ILdS4tCVZcwHZ"
  bool isPlayerPartOfTeam(String teamId) {
    bool playerIsPartOfTeam = false;
    player.teams.forEach((String teamReferenceId) {
      if (teamReferenceId.contains(teamId)) {
        playerIsPartOfTeam = true;
      }
    });
    return playerIsPartOfTeam;
  }

  // void assignPlayerClubId() async {
  //   // TODO change this once we can use different clubs
  //   Club loggedInClub = persistentController.getLoggedInClub();
  //   if (loggedInClub.id != null){
  //     this.player.clubId = loggedInClub.id!;
  //   }

  // }

  @override
  Widget build(BuildContext context) {
    InputDecoration getDecoration(String labelText) {
      return InputDecoration(
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: buttonDarkBlueColor)),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: buttonDarkBlueColor)),
          disabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: buttonDarkBlueColor)),
          labelText: labelText,
          labelStyle: TextStyle(color: buttonDarkBlueColor),
          filled: true,
          fillColor: Colors.white);
    }

    // Build a Form widget using the _formKey created above.
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        editModeEnabled
            ? Text(StringsGeneral.lPlayerEditMode,
                style: TextStyle(fontWeight: FontWeight.bold))
            : Text(StringsGeneral.lPlayerCreateMode,
                style: TextStyle(fontWeight: FontWeight.bold)),
      ]),
      Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: width * 0.25,
                  child: TextFormField(
                    style: TextStyle(fontSize: 18),
                    decoration: getDecoration(StringsGeneral.lFirstName),
                    controller: firstNameController,
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return StringsGeneral.lTextFieldEmpty;
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  width: width * 0.25,
                  child: TextFormField(
                    controller: lastNameController,
                    style: TextStyle(fontSize: 18),
                    decoration: getDecoration(StringsGeneral.lLastName),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return StringsGeneral.lTextFieldEmpty;
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
                  child: Container(),
                  /*TextFormField(
                    controller: nickNameController,
                    style: TextStyle(fontSize: 18),
                    decoration: getDecoration(StringsGeneral.lNickName),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      // if (value == null || value.isEmpty) {
                      //   return 'Please enter some text';
                      // }
                      return null;
                    },
                  ),*/
                ),
                SizedBox(
                  width: width * 0.25,
                  child: TextFormField(
                    controller: shirtNumberController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 18),
                    decoration: getDecoration(StringsGeneral.lShirtNumber),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return StringsGeneral.lTextFieldEmpty;
                      }
                      if (int.tryParse(value.toString()) == null) {
                        return StringsGeneral.lNumberFieldNotValid;
                      }
                      if (value.length > 3) {
                        return StringsGeneral.lNumberTooLong;
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            Container(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FormField(
                  // Team selection
                  builder: (state) => Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(StringsGeneral.lTeams),
                      SizedBox(
                          width: width * 0.25,
                          height: 100,
                          child: ListView.builder(
                              itemCount: availableTeams.length,
                              itemBuilder: (context, index) {
                                Team relevantTeam = availableTeams[index];
                                return Row(
                                  children: [
                                    Text(relevantTeam.name),
                                    Checkbox(
                                        fillColor:
                                            MaterialStateProperty.all<Color>(
                                                buttonDarkBlueColor),
                                        value: isPlayerPartOfTeam(
                                            relevantTeam.id.toString()),
                                        onChanged: (value) {
                                          setState(() {
                                            if (value == true) {
                                              player.teams.add("teams/" +
                                                  relevantTeam.id.toString());
                                            } else {
                                              player.teams.remove("teams/" +
                                                  relevantTeam.id.toString());
                                            }
                                          });
                                        })
                                  ],
                                );
                              })),
                      Text(
                        state.errorText ?? '',
                        style: TextStyle(
                          color: Theme.of(context).errorColor,
                        ),
                      )
                    ],
                  ),
                  validator: (value) {
                    if (player.teams.length == 0) {
                      return StringsGeneral.lTeamMissing;
                    }
                    return null;
                  },
                ),
                FormField(
                  // Position check boxes
                  builder: (state) => Column(
                    children: [
                      Text(StringsGeneral.lPosition),
                      SizedBox(
                        width: width * 0.25,
                        height: 100,
                        child: ListView.builder(
                          itemCount: 8,
                          shrinkWrap: true,
                          itemBuilder: (context, item) {
                            List<String> positionNames = [
                              StringsGeneral.lGoalkeeper,
                              StringsGeneral.lLeftBack,
                              StringsGeneral.lCenterBack,
                              StringsGeneral.lRightBack,
                              StringsGeneral.lLeftWinger,
                              StringsGeneral.lCenterForward,
                              StringsGeneral.lRightWinger,
                              defenseSpecialist
                            ];
                            return Row(
                              children: [
                                Text(positionNames[item]),
                                Checkbox(
                                    fillColor: MaterialStateProperty.all<Color>(
                                        buttonDarkBlueColor),
                                    value: player.positions
                                        .contains(positionNames[item]),
                                    onChanged: (value) {
                                      setState(() {
                                        if (value == true) {
                                          player.positions
                                              .add(positionNames[item]);
                                        } else {
                                          player.positions
                                              .remove(positionNames[item]);
                                        }
                                      });
                                    })
                              ],
                            );
                          },
                        ),
                      ),
                      Text(
                        state.errorText ?? '',
                        style: TextStyle(
                          color: Theme.of(context).errorColor,
                        ),
                      )
                    ],
                  ),
                  validator: (value) {
                    if (player.positions.length == 0) {
                      return StringsGeneral.lPositionMissing;
                    }
                    return null;
                  },
                )
              ],
            ),
            Container(
              height: 20,
            ),
            // Submit button
            Container(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    
                    Flexible(
                      // Cancel-Button
                      child:
                          //SizedBox(
                          //width: 0.15 * width,
                          //height: 0.08 * height,
                          //child:
                          ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                buttonGreyColor)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          StringsGeneral.lBack,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                    ),
                    Flexible(
                      child:
                          //SizedBox(
                          //width: 0.15 * width,
                          //height: 0.08 * height,
                          //child:
                          ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          buttonGreyColor)),
                              onPressed: () {
                                tempController.deletePlayer(player);
                                Navigator.pop(context);
                              },
                              child: Text(StringsGeneral.lDeletePlayer,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black))),
                    ),
                    Flexible(
                      child:
                          //SizedBox(
                          //width: 0.15 * width,
                          // height: 0.08 * height,
                          //child:
                          ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                buttonLightBlueColor)),
                        onPressed: () {
                          // Validate returns true if the form is valid, or false otherwise.
                          if (_formKey.currentState!.validate()) {
                            player.firstName = firstNameController.text;
                            player.lastName = lastNameController.text;
                            player.nickName = nickNameController.text;
                            player.number =
                                int.parse(shirtNumberController.text);
                            // pop alert
                            Navigator.pop(context);
                            // display snackbar while data is stored in db
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text(StringsGeneral.lProcessingData)),
                            );
                            // Edit mode
                            if (editModeEnabled) {
                              tempController.setPlayer(player);
                            } else {
                              tempController.addPlayerToSelectedTeam(player);
                            }
                          }
                        },
                        child: const Text(
                          // Safe button
                          StringsGeneral.lSubmitButton,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    ]);
  }
}
