import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/data/models/models.dart';
import 'package:handball_performance_tracker/core/core.dart';
import 'package:handball_performance_tracker/features/team_management/team_management.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayerEditWidget extends StatefulWidget {
  late Player player;
  bool editModeEnabled;
  PlayerEditWidget({super.key, Player? player, required this.editModeEnabled}) {
    if (player != null) {
      this.player = player;
    } else {
      this.player = Player();
    }
  }

  @override
  State<PlayerEditWidget> createState() => _PlayerEditWidgetState();
}

class _PlayerEditWidgetState extends State<PlayerEditWidget> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController nickNameController;
  late TextEditingController numberController;
  @override
  void initState() {
    firstNameController = TextEditingController(text: widget.player.firstName);
    lastNameController = TextEditingController(text: widget.player.lastName);
    nickNameController = TextEditingController(text: widget.player.nickName);
    numberController =
        TextEditingController(text: widget.player.number.toString());
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

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

  @override
  Widget build(BuildContext context) {
    final globalBloc = context.watch<GlobalBloc>();
    final teamManBloc = context.watch<TeamManagementBloc>();
    List<Team> allTeams = globalBloc.state.allTeams;
    ScrollController teamScrollController = ScrollController();
    ScrollController positionScrollController = ScrollController();

    // Build a Form widget using the _formKey created above.
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(children: [
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
                    // onFieldSubmitted: (String value) => setState(() => widget.player.firstName = value),
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
                    // onFieldSubmitted: (String value) => setState(() => widget.player.lastName = value),
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
                    controller: numberController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 18),
                    decoration: getDecoration(StringsGeneral.lShirtNumber),
                    // onFieldSubmitted: (String value) => setState(() => widget.player.number = int.parse(value)),
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
                // FormField(
                //   // Team selection
                //   builder: (state) => Column(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Text(StringsGeneral.lTeams),
                //       SizedBox(
                //           width: width * 0.25,
                //           height: height * 0.2,
                //           child: Scrollbar(
                //             controller: teamScrollController,
                //             thumbVisibility: true,
                //             child: ListView.builder(
                //                 controller: teamScrollController,
                //                 itemCount: allTeams.length,
                //                 itemBuilder: (context, index) {
                //                   Team relevantTeam = allTeams[index];
                //                   return Row(
                //                     children: [
                //                       Checkbox(
                //                           fillColor:
                //                               MaterialStateProperty.all<Color>(
                //                                   buttonDarkBlueColor),
                //                           value: playerIsPartOfRelevantTeam(
                //                               widget.player, relevantTeam),
                //                           onChanged: (value) {
                //                             if (value == true) {
                //                               // Add team to player
                //                               setState(() => widget.player.teams
                //                                   .add(relevantTeam.path));
                //                             } else {
                //                               // Remove team from player
                //                               setState(() => widget.player.teams
                //                                   .removeWhere((String
                //                                           teamString) =>
                //                                       teamString.contains(
                //                                           relevantTeam.id
                //                                               .toString())));
                //                             }
                //                           }),
                //                       Text(relevantTeam.name)
                //                     ],
                //                   );
                //                 }),
                //           )),
                //       Text(
                //         state.errorText ?? '',
                //         style: TextStyle(
                //           color: Theme.of(context).errorColor,
                //         ),
                //       )
                //     ],
                //   ),
                //   validator: (value) {
                //     if (widget.player.teams.length == 0) {
                //       return StringsGeneral.lTeamMissing;
                //     }
                //     return null;
                //   },
                // ),
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
                            shrinkWrap: false,
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
                                      fillColor:
                                          MaterialStateProperty.all<Color>(
                                              buttonDarkBlueColor),
                                      value: widget.player.positions
                                          .contains(positionNames[item]),
                                      onChanged: (value) {
                                        if (value == true) {
                                          setState(() => widget.player.positions
                                              .add(positionNames[item]));
                                        } else {
                                          setState(() => widget.player.positions
                                              .remove(positionNames[item]));
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
                    if (widget.player.positions.length == 0) {
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
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                buttonGreyColor)),
                        onPressed: () {
                          teamManBloc.add(SelectViewField(
                              viewField: TeamManagementViewField.players));
                          // Navigator.of(context).pop();
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
                    // delete button
                    // Flexible(
                    //   child: ElevatedButton(
                    //       style: ButtonStyle(
                    //           backgroundColor: MaterialStateProperty.all<Color>(
                    //               buttonGreyColor)),
                    //       onPressed: () {
                    //         // remove player from players collection
                    //         globalBloc.add(DeletePlayer(player: widget.player));
                    //         // remove player from teams collection
                    //         Team teamWithoutPlayer = allTeams.firstWhere(
                    //             (team) => team.players.contains(widget.player));
                    //         teamWithoutPlayer.players.remove(widget.player.id);
                    //         if (teamWithoutPlayer.onFieldPlayers
                    //             .contains(widget.player)) {
                    //           teamWithoutPlayer.onFieldPlayers
                    //               .remove(widget.player.id);
                    //         }
                    //         globalBloc.add(UpdateTeam(team: teamWithoutPlayer));
                    //         Navigator.pop(context);
                    //       },
                    //       child: Text(StringsGeneral.lDeletePlayer,
                    //           style: TextStyle(
                    //               fontSize: 18,
                    //               fontWeight: FontWeight.bold,
                    //               color: Colors.black))),
                    // ),
                    // Submit button
                    Flexible(
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                buttonLightBlueColor)),
                        onPressed: () {
                          // Validate returns true if the form is valid, or false otherwise.
                          if (_formKey.currentState!.validate()) {
                            widget.player.firstName = firstNameController.text;
                            widget.player.lastName = lastNameController.text;
                            widget.player.number =
                                int.parse(numberController.text);

                            // pop alert
                            // Navigator.pop(context);
                            // updating an existing player
                            if (widget.editModeEnabled) {
                              // update player in players collection
                              globalBloc
                                  .add(UpdatePlayer(player: widget.player));
                              // go through each team of the club and update the players property
                              for (Team team in allTeams) {
                                // if player was added to a team where they weren't part of before
                                bool teamCorrespondenceUpdated = false;
                                if (playerIsPartOfRelevantTeam(
                                        widget.player, team) &&
                                    !team.players.contains(widget.player.id)) {
                                  team.players.add(widget.player);
                                  teamCorrespondenceUpdated = true;
                                  // if player was removed from a team where they were part of before
                                } else if (!playerIsPartOfRelevantTeam(
                                        widget.player, team) &&
                                    team.players.contains(widget.player.id)) {
                                  team.players.remove(widget.player);
                                  // of course also remove the player from the onFieldPlayers list
                                  if (team.onFieldPlayers
                                      .contains(widget.player)) {
                                    team.onFieldPlayers.remove(widget.player);
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
                              globalBloc
                                  .add(CreatePlayer(player: widget.player));
                              print("adding player: ${widget.player}");
                              // add player to players property of each team in the teams collection
                              // widget.player.teams.forEach((String teamString) {
                              //   Team team = allTeams.firstWhere((Team team) =>
                              //       teamString.contains(team.id.toString()));
                              //   team.players.add(widget.player);
                              //   globalBloc.add(UpdateTeam(team: team));
                              globalBloc.state.allTeams[teamManBloc.state.selectedTeamIndex].players.add(widget.player);
                              globalBloc.add(UpdateTeam(team: globalBloc.state.allTeams[teamManBloc.state.selectedTeamIndex]));
                              teamManBloc.add(SelectViewField(viewField: TeamManagementViewField.players));
                              
                              // teamManBloc.add(SelectViewField(
                              //     viewField: TeamManagementViewField.players));
                            }
                          }
                        },
                        child: const Text(
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





// // need to have stateful widget to make updating the dropdowns simpler
// // set State can be used for every interaction
// class PlayerForm extends StatefulWidget {
//   late Player player;
//   bool editModeEnabled;
//   PlayerForm({super.key, Player? player, required this.editModeEnabled}) {
//     if (player != null) {
//       this.player = player;
//     } else {
//       this.player = Player();
//     }
//   }

//   @override
//   State<PlayerForm> createState() => _PlayerFormState();
// }

// // Create a corresponding State class.
// // This class holds data related to the form.
// class _PlayerFormState extends State<PlayerForm> {
//   late TextEditingController firstNameController;
//   late TextEditingController lastNameController;
//   late TextEditingController nickNameController;
//   late TextEditingController numberController;
//   @override
//   void initState() {
//     firstNameController = TextEditingController(text: widget.player.firstName);
//     lastNameController = TextEditingController(text: widget.player.lastName);
//     nickNameController = TextEditingController(text: widget.player.nickName);
//     numberController =
//         TextEditingController(text: widget.player.number.toString());
//     super.initState();
//   }

//   // Create a global key that uniquely identifies the Form widget
//   // and allows validation of the form.
//   //
//   // Note: This is a GlobalKey<FormState>,
//   // not a GlobalKey<MyCustomFormState>.
//   final _formKey = GlobalKey<FormState>();

//   InputDecoration getDecoration(String labelText) {
//     return InputDecoration(
//         focusedBorder: UnderlineInputBorder(
//             borderSide: BorderSide(color: buttonDarkBlueColor)),
//         enabledBorder: UnderlineInputBorder(
//             borderSide: BorderSide(color: buttonDarkBlueColor)),
//         disabledBorder: UnderlineInputBorder(
//             borderSide: BorderSide(color: buttonDarkBlueColor)),
//         labelText: labelText,
//         labelStyle: TextStyle(color: buttonDarkBlueColor),
//         filled: true,
//         fillColor: Colors.white);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final globalBloc = context.watch<GlobalBloc>();
//     final teamManBloc = context.watch<TeamManagementBloc>();
//     List<Team> allTeams = globalBloc.state.allTeams;
//     ScrollController teamScrollController = ScrollController();
//     ScrollController positionScrollController = ScrollController();

//     // Build a Form widget using the _formKey created above.
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;
//     return Scaffold(
//         body: SingleChildScrollView(
//             physics: const NeverScrollableScrollPhysics(),
//             child: IntrinsicHeight(
//               child: Column(children: [
//                 Form(
//                   key: _formKey,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           SizedBox(
//                             width: width * 0.25,
//                             child: TextFormField(
//                               style: TextStyle(fontSize: 18),
//                               decoration:
//                                   getDecoration(StringsGeneral.lFirstName),
//                               controller: firstNameController,
//                               // onFieldSubmitted: (String value) => setState(() => widget.player.firstName = value),
//                               // The validator receives the text that the user has entered.
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return StringsGeneral.lTextFieldEmpty;
//                                 }
//                                 return null;
//                               },
//                             ),
//                           ),
//                           SizedBox(
//                             width: width * 0.25,
//                             child: TextFormField(
//                               controller: lastNameController,
//                               style: TextStyle(fontSize: 18),
//                               decoration:
//                                   getDecoration(StringsGeneral.lLastName),
//                               // onFieldSubmitted: (String value) => setState(() => widget.player.lastName = value),
//                               // The validator receives the text that the user has entered.
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return StringsGeneral.lTextFieldEmpty;
//                                 }
//                                 return null;
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                       Container(
//                         height: 20,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           SizedBox(
//                             width: width * 0.25,
//                             child: Container(),
//                             /*TextFormField(
//                       controller: nickNameController,
//                       style: TextStyle(fontSize: 18),
//                       decoration: getDecoration(StringsGeneral.lNickName),
//                       // The validator receives the text that the user has entered.
//                       validator: (value) {
//                         // if (value == null || value.isEmpty) {
//                         //   return 'Please enter some text';
//                         // }
//                         return null;
//                       },
//                     ),*/
//                           ),
//                           SizedBox(
//                             width: width * 0.25,
//                             child: TextFormField(
//                               controller: numberController,
//                               keyboardType: TextInputType.number,
//                               style: TextStyle(fontSize: 18),
//                               decoration:
//                                   getDecoration(StringsGeneral.lShirtNumber),
//                               // onFieldSubmitted: (String value) => setState(() => widget.player.number = int.parse(value)),
//                               // The validator receives the text that the user has entered.
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return StringsGeneral.lTextFieldEmpty;
//                                 }
//                                 if (int.tryParse(value.toString()) == null) {
//                                   return StringsGeneral.lNumberFieldNotValid;
//                                 }
//                                 if (value.length > 3) {
//                                   return StringsGeneral.lNumberTooLong;
//                                 }
//                                 return null;
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                       Container(
//                         height: 40,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           // FormField(
//                           //   // Team selection
//                           //   builder: (state) => Column(
//                           //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           //     children: [
//                           //       Text(StringsGeneral.lTeams),
//                           //       SizedBox(
//                           //           width: width * 0.25,
//                           //           height: height * 0.2,
//                           //           child: Scrollbar(
//                           //             controller: teamScrollController,
//                           //             thumbVisibility: true,
//                           //             child: ListView.builder(
//                           //                 controller: teamScrollController,
//                           //                 itemCount: allTeams.length,
//                           //                 itemBuilder: (context, index) {
//                           //                   Team relevantTeam = allTeams[index];
//                           //                   return Row(
//                           //                     children: [
//                           //                       Checkbox(
//                           //                           fillColor:
//                           //                               MaterialStateProperty.all<
//                           //                                       Color>(
//                           //                                   buttonDarkBlueColor),
//                           //                           value:
//                           //                               playerIsPartOfRelevantTeam(
//                           //                                   widget.player,
//                           //                                   relevantTeam),
//                           //                           onChanged: (value) {
//                           //                             if (value == true) {
//                           //                               // Add team to player
//                           //                               setState(() => widget
//                           //                                   .player.teams
//                           //                                   .add(relevantTeam
//                           //                                       .path));
//                           //                             } else {
//                           //                               // Remove team from player
//                           //                               setState(() => widget
//                           //                                   .player.teams
//                           //                                   .removeWhere((String
//                           //                                           teamString) =>
//                           //                                       teamString.contains(
//                           //                                           relevantTeam
//                           //                                               .id
//                           //                                               .toString())));
//                           //                             }
//                           //                           }),
//                           //                       Text(relevantTeam.name)
//                           //                     ],
//                           //                   );
//                           //                 }),
//                           //           )),
//                           //       Text(
//                           //         state.errorText ?? '',
//                           //         style: TextStyle(
//                           //           color: Theme.of(context).errorColor,
//                           //         ),
//                           //       )
//                           //     ],
//                           //   ),
//                           //   validator: (value) {
//                           //     if (widget.player.teams.length == 0) {
//                           //       return StringsGeneral.lTeamMissing;
//                           //     }
//                           //     return null;
//                           //   },
//                           // ),
//                           FormField(
//                             // Position check boxes
//                             builder: (state) => Column(
//                               children: [
//                                 Text(StringsGeneral.lPosition),
//                                 SizedBox(
//                                   width: width * 0.25,
//                                   height: height * 0.2,
//                                   child: Scrollbar(
//                                     controller: positionScrollController,
//                                     thumbVisibility: true,
//                                     child: ListView.builder(
//                                       controller: positionScrollController,
//                                       itemCount: 8,
//                                       shrinkWrap: true,
//                                       itemBuilder: (context, item) {
//                                         List<String> positionNames = [
//                                           StringsGeneral.lGoalkeeper,
//                                           StringsGeneral.lLeftBack,
//                                           StringsGeneral.lCenterBack,
//                                           StringsGeneral.lRightBack,
//                                           StringsGeneral.lLeftWinger,
//                                           StringsGeneral.lCenterForward,
//                                           StringsGeneral.lRightWinger,
//                                           defenseSpecialist
//                                         ];
//                                         return Row(
//                                           children: [
//                                             Checkbox(
//                                                 fillColor: MaterialStateProperty
//                                                     .all<Color>(
//                                                         buttonDarkBlueColor),
//                                                 value: widget.player.positions
//                                                     .contains(
//                                                         positionNames[item]),
//                                                 onChanged: (value) {
//                                                   if (value == true) {
//                                                     setState(() => widget
//                                                         .player.positions
//                                                         .add(positionNames[
//                                                             item]));
//                                                   } else {
//                                                     setState(() => widget
//                                                         .player.positions
//                                                         .remove(positionNames[
//                                                             item]));
//                                                   }
//                                                 }),
//                                             Text(positionNames[item])
//                                           ],
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                 ),
//                                 Text(
//                                   state.errorText ?? '',
//                                   style: TextStyle(
//                                     color: Theme.of(context).errorColor,
//                                   ),
//                                 )
//                               ],
//                             ),
//                             validator: (value) {
//                               if (widget.player.positions.length == 0) {
//                                 return StringsGeneral.lPositionMissing;
//                               }
//                               return null;
//                             },
//                           )
//                         ],
//                       ),
//                       Container(
//                         height: 20,
//                       ),
//                       Container(
//                         alignment: Alignment.bottomCenter,
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               Flexible(
//                                 // Cancel-Button
//                                 child: ElevatedButton(
//                                   style: ButtonStyle(
//                                       backgroundColor:
//                                           MaterialStateProperty.all<Color>(
//                                               buttonGreyColor)),
//                                   onPressed: () {
//                                     Navigator.of(context).pop();
//                                   },
//                                   child: const Text(
//                                     StringsGeneral.lBack,
//                                     style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.black),
//                                   ),
//                                 ),
//                               ),
//                               // delete button
//                               Flexible(
//                                 child: ElevatedButton(
//                                     style: ButtonStyle(
//                                         backgroundColor:
//                                             MaterialStateProperty.all<Color>(
//                                                 buttonGreyColor)),
//                                     onPressed: () {
//                                       // remove player from players collection
//                                       globalBloc.add(
//                                           DeletePlayer(player: widget.player));
//                                       // remove player from teams collection
//                                       Team teamWithoutPlayer = allTeams
//                                           .firstWhere((team) => team.players
//                                               .contains(widget.player));
//                                       teamWithoutPlayer.players
//                                           .remove(widget.player.id);
//                                       if (teamWithoutPlayer.onFieldPlayers
//                                           .contains(widget.player)) {
//                                         teamWithoutPlayer.onFieldPlayers
//                                             .remove(widget.player.id);
//                                       }
//                                       globalBloc.add(
//                                           UpdateTeam(team: teamWithoutPlayer));
//                                       Navigator.pop(context);
//                                     },
//                                     child: Text(StringsGeneral.lDeletePlayer,
//                                         style: TextStyle(
//                                             fontSize: 18,
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.black))),
//                               ),
//                               // Submit button
//                               Flexible(
//                                 child: ElevatedButton(
//                                   style: ButtonStyle(
//                                       backgroundColor:
//                                           MaterialStateProperty.all<Color>(
//                                               buttonLightBlueColor)),
//                                   onPressed: () {
//                                     // Validate returns true if the form is valid, or false otherwise.
//                                     if (_formKey.currentState!.validate()) {
//                                       widget.player.firstName =
//                                           firstNameController.text;
//                                       widget.player.lastName =
//                                           lastNameController.text;
//                                       widget.player.number =
//                                           int.parse(numberController.text);

//                                       // pop alert
//                                       Navigator.pop(context);
//                                       // updating an existing player
//                                       if (widget.editModeEnabled) {
//                                         // update player in players collection
//                                         globalBloc.add(UpdatePlayer(
//                                             player: widget.player));
//                                         // go through each team of the club and update the players property
//                                         for (Team team in allTeams) {
//                                           // if player was added to a team where they weren't part of before
//                                           bool teamCorrespondenceUpdated =
//                                               false;
//                                           if (playerIsPartOfRelevantTeam(
//                                                   widget.player, team) &&
//                                               !team.players
//                                                   .contains(widget.player.id) &&
//                                               !widget.player.teams
//                                                   .contains(team.id)) {
//                                             team.players.add(widget.player);
//                                             teamCorrespondenceUpdated = true;
//                                             // if player was removed from a team where they were part of before
//                                           } else if (!playerIsPartOfRelevantTeam(
//                                                   widget.player, team) &&
//                                               team.players
//                                                   .contains(widget.player.id)) {
//                                             team.players.remove(widget.player);
//                                             // of course also remove the player from the onFieldPlayers list
//                                             if (team.onFieldPlayers
//                                                 .contains(widget.player)) {
//                                               team.onFieldPlayers
//                                                   .remove(widget.player);
//                                             }
//                                             teamCorrespondenceUpdated = true;
//                                           }
//                                           // if player was added or removed from a team then update the team
//                                           if (teamCorrespondenceUpdated) {
//                                             globalBloc
//                                                 .add(UpdateTeam(team: team));
//                                           }
//                                         }
//                                         // new player mode
//                                       } else {
//                                         // add player to players collection
//                                         globalBloc.add(CreatePlayer(
//                                             player: widget.player));
//                                         print(
//                                             "adding player: ${widget.player}");
//                                         // add player to players property of each team in the teams collection
//                                         // widget.player.teams
//                                         //     .forEach((String teamString) {
//                                         //   Team team = allTeams.firstWhere(
//                                         //       (Team team) =>
//                                         //           teamString.contains(
//                                         //               team.id.toString()));
//                                         //   team.players.add(widget.player);
//                                         //   globalBloc
//                                         //       .add(UpdateTeam(team: team));
//                                         //   // refresh player list
//                                         // });
//                                         globalBloc.state.allTeams[teamManBloc.state.selectedTeamIndex].players.add(widget.player);
//                                         globalBloc.add(UpdateTeam(team: globalBloc.state.allTeams[teamManBloc.state.selectedTeamIndex]));
//                                         teamManBloc.add(SelectViewField(
//                                             viewField: TeamManagementViewField
//                                                 .players));
//                                       }
//                                       // teamManBloc.add(SelectViewField(viewField: TeamManagementViewField.players));
//                                     }
//                                   },
//                                   child: const Text(
//                                     StringsGeneral.lSubmitButton,
//                                     style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.black),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               ]),
//             )));
//   }
// }

bool playerIsPartOfRelevantTeam(Player player, Team team) {
  bool playerIsPartOfRelevantTeam = false;
  player.teams.forEach((element) {
    if (element.contains(team.id.toString())) {
      playerIsPartOfRelevantTeam = true;
    }
  });
  return playerIsPartOfRelevantTeam;
}
