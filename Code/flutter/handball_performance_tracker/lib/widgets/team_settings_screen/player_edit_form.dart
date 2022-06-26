import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/controllers/persistentController.dart';
import 'package:handball_performance_tracker/data/team.dart';
import '../../strings.dart';
import '../../data/player.dart';
import '../../data/club.dart';
import '../../data/database_repository.dart';
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
      assignPlayerClubId();
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

  void assignPlayerClubId() async {
    // TODO change this once we can use different clubs
    Club loggedInClub = persistentController.getLoggedInClub();
    this.player.clubId =
        await DatabaseRepository().getClubReference(loggedInClub);
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
              tempController.deletePlayer(player);
              Navigator.pop(context);
              tempController.update(["players-list"]);
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
                        labelText: Strings.lFirstName,
                        hintText: "*"),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return Strings.lTextFieldEmpty;
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
                        labelText: Strings.lLastName,
                        hintText: "*"),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return Strings.lTextFieldEmpty;
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
                        labelText: Strings.lNickName,
                        hintText: Strings.lOptional),
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
                        labelText: Strings.lShirtNumber,
                        hintText: '*'),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return Strings.lTextFieldEmpty;
                      }
                      if (int.tryParse(value.toString()) == null) {
                        return Strings.lNumberFieldNotValid;
                      }
                      if (value.length > 3) {
                        return Strings.lNumberTooLong;
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
                FormField(
                  builder: (state) => Column(
                    children: [
                      Text(Strings.lTeams),
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
                      return Strings.lTeamMissing;
                    }
                    return null;
                  },
                ),
                FormField(
                  builder: (state) => Column(
                    children: [
                      Text(Strings.lPosition),
                      SizedBox(
                        width: width * 0.25,
                        height: 100,
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
                                Checkbox(
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
                      return Strings.lPositionMissing;
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
