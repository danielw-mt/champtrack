import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/data/models/models.dart';
import 'package:handball_performance_tracker/core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/features/authentication/authentication.dart';

// Create a corresponding State class.
// This class holds data related to the form.
class PlayerForm extends StatelessWidget {
  late Player player;
  bool editModeEnabled;
  PlayerForm({Key? key, this.editModeEnabled = true, Player? player}) {
    player ?? Player();
    this.player = player!;
  }
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  InputDecoration getDecoration(String labelText) {
    return InputDecoration(
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: buttonDarkBlueColor)),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: buttonDarkBlueColor)),
        disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: buttonDarkBlueColor)),
        labelText: labelText,
        labelStyle: TextStyle(color: buttonDarkBlueColor),
        filled: true,
        fillColor: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    final globalBloc = context.watch<GlobalBloc>();
    final authBloc = context.read<AuthBloc>();
    List<Team> allTeams = globalBloc.state.allTeams;
    ScrollController teamScrollController = ScrollController();
    ScrollController positionScrollController = ScrollController();

    // Build a Form widget using the _formKey created above.
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        editModeEnabled
            ? Text(StringsGeneral.lPlayerEditMode, style: TextStyle(fontWeight: FontWeight.bold))
            : Text(StringsGeneral.lPlayerCreateMode, style: TextStyle(fontWeight: FontWeight.bold)),
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
                    controller: TextEditingController(text: player.firstName),
                    onChanged: (String value) => player.firstName = value,
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
                    controller: TextEditingController(text: player.lastName),
                    style: TextStyle(fontSize: 18),
                    decoration: getDecoration(StringsGeneral.lLastName),
                    onChanged: (String value) => player.lastName = value,
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
                    controller: TextEditingController(text: player.number.toString()),
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 18),
                    decoration: getDecoration(StringsGeneral.lShirtNumber),
                    onChanged: (String value) => player.number = int.parse(value),
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
                          height: height * 0.2,
                          child: Scrollbar(
                            controller: teamScrollController,
                            thumbVisibility: true,
                            child: ListView.builder(
                                controller: teamScrollController,
                                itemCount: allTeams.length,
                                itemBuilder: (context, index) {
                                  Team relevantTeam = allTeams[index];
                                  return Row(
                                    children: [
                                      Checkbox(
                                          fillColor: MaterialStateProperty.all<Color>(buttonDarkBlueColor),
                                          value: player.teams.contains(relevantTeam.path),
                                          onChanged: (value) {
                                            String clubId = authBloc.getClubReference().id;
                                            if (value == true) {
                                              // Add team to player
                                              player.teams.add("clubs/" + clubId + "/" + relevantTeam.id.toString());
                                            } else {
                                              // Remove team from player
                                              player.teams.removeWhere((String teamString) => teamString.contains(relevantTeam.id.toString()));
                                            }
                                          }),
                                      Text(relevantTeam.name)
                                    ],
                                  );
                                }),
                          )),
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
                        height: height * 0.2,
                        child: Scrollbar(
                          controller: positionScrollController,
                          thumbVisibility: true,
                          child: ListView.builder(
                            controller: positionScrollController,
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
                                  Checkbox(
                                      fillColor: MaterialStateProperty.all<Color>(buttonDarkBlueColor),
                                      value: player.positions.contains(positionNames[item]),
                                      onChanged: (value) {
                                        if (value == true) {
                                          player.positions.add(positionNames[item]);
                                        } else {
                                          player.positions.remove(positionNames[item]);
                                        }
                                      }),
                                  Text(positionNames[item])
                                ],
                              );
                            },
                          ),
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
            Container(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      // Cancel-Button
                      child: ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(buttonGreyColor)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          StringsGeneral.lBack,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                    ),
                    // delete button
                    Flexible(
                      child: ElevatedButton(
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(buttonGreyColor)),
                          onPressed: () {
                            // remove player from players collection
                            globalBloc.add(DeletePlayer(player: player));
                            // remove player from teams collection
                            Team teamWithoutPlayer = allTeams.firstWhere((team) => team.players.contains(player));
                            teamWithoutPlayer.players.remove(player.id);
                            if (teamWithoutPlayer.onFieldPlayers.contains(player)) {
                              teamWithoutPlayer.onFieldPlayers.remove(player.id);
                            }
                            globalBloc.add(UpdateTeam(team: teamWithoutPlayer));
                            Navigator.pop(context);
                          },
                          child:
                              Text(StringsGeneral.lDeletePlayer, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black))),
                    ),
                    // Submit button
                    Flexible(
                      child: ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(buttonLightBlueColor)),
                        onPressed: () {
                          // Validate returns true if the form is valid, or false otherwise.
                          if (_formKey.currentState!.validate()) {
                            // pop alert
                            Navigator.pop(context);
                            // updating an existing player
                            if (editModeEnabled) {
                              // update player in players collection
                              globalBloc.add(UpdatePlayer(player: player));
                              // go through each team of the club and update the players property
                              for (Team team in allTeams) {
                                // if player was added to a team where they werent part of before
                                bool teamCorrespondenceUpdated = false;
                                if (player.teams.contains(team.id) && !team.players.contains(player.id)) {
                                  team.players.add(player);
                                  teamCorrespondenceUpdated = true;
                                  // if player was removed from a team where they were part of before
                                } else if (!player.teams.contains(team.id) && team.players.contains(player.id)) {
                                  team.players.remove(player);
                                  // of course also remove the player from the onFieldPlayers list
                                  if (team.onFieldPlayers.contains(player)) {
                                    team.onFieldPlayers.remove(player);
                                  }
                                  teamCorrespondenceUpdated = true;
                                }
                                // if player was added or removed from a team then update the team
                                if (teamCorrespondenceUpdated) {
                                  globalBloc.add(UpdateTeam(team: team));
                                }
                              }
                              // new player mode
                            } else {
                              // add player to players collection
                              globalBloc.add(CreatePlayer(player: player));
                              // add player to players property of each team in the teams collection
                              player.teams.forEach((String teamString) {
                                Team team = allTeams.firstWhere((Team team) => teamString.contains(team.id.toString()));
                                team.players.add(player);
                                globalBloc.add(UpdateTeam(team: team));
                              });
                            }
                          }
                        },
                        child: const Text(
                          StringsGeneral.lSubmitButton,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
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
