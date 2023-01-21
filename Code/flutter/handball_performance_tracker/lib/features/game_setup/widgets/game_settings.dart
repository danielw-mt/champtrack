import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/core/core.dart';
import 'package:handball_performance_tracker/features/game_setup/game_setup.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameSettings extends StatelessWidget {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final globalState = context.watch<GlobalBloc>().state;
    final gameSetupState = context.watch<GameSetupCubit>().state;
    final gameSetupCubit = context.watch<GameSetupCubit>();
    // TODO implement season dropdown
    TextEditingController seasonController = TextEditingController();
    TextEditingController opponentController =
        TextEditingController(text: gameSetupState.opponent);
    TextEditingController locationController =
        TextEditingController(text: gameSetupState.location);
    TextEditingController dateController = TextEditingController(
        text: "${gameSetupState.date.toLocal()}".split(' ')[0]);
    locationController.text = gameSetupState.location;
    DateTime selectedDate = gameSetupState.date;
    int selectedTeamIndex = gameSetupState.selectedTeamIndex;
    bool isAtHome = gameSetupState.isHomeGame;
    bool attackIsLeft = gameSetupState.attackIsLeft;
    bool isTestGame = gameSetupState.isTestGame;

    // Build a Form widget using the _formKey created above.
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return
        // Container(
        //   height: height * 0.9,
        //   width: width,
        //   // place Container central
        //   alignment: Alignment.center,
        //   color: Colors.red,
        //   child:
        Scaffold(
      body: SingleChildScrollView(
        controller: ScrollController(),
        scrollDirection: Axis.vertical,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: height,
            maxWidth: width,
          ),
          child: IntrinsicHeight(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Textfield for opponent name
                      MouseRegion(
                        onExit: (event) =>
                            gameSetupCubit.setOpponent(opponentController.text),
                        child: SizedBox(
                            width: width * 0.3,
                            height: height * 0.15,
                            // make sure that the text gets saved to state when the user leaves the textfield
                            child: Focus(
                              onFocusChange: (value) => value == false
                                  ? gameSetupCubit
                                      .setOpponent(opponentController.text)
                                  : {},
                              child: TextFormField(
                                controller: opponentController,
                                style: TextStyle(fontSize: 18),
                                decoration:
                                    getDecoration(StringsGeneral.lOpponent),
                                onEditingComplete: () => gameSetupCubit
                                    .setOpponent(opponentController.text),
                                onFieldSubmitted: (value) => gameSetupCubit
                                    .setOpponent(opponentController.text),
                                onSaved: (newValue) => gameSetupCubit
                                    .setOpponent(opponentController.text),
                              ),
                            )),
                      ),
                      // Textfield for location
                      SizedBox(
                          width: width * 0.3,
                          height: height * 0.15,
                          // make sure that the text gets saved to state when the user leaves the textfield
                          child: Focus(
                            onFocusChange: (value) => value == false
                                ? gameSetupCubit
                                    .setLocation(locationController.text)
                                : {},
                            child: TextFormField(
                              controller: locationController,
                              decoration:
                                  getDecoration(StringsGeneral.lLocation),
                              onEditingComplete: () => gameSetupCubit
                                  .setLocation(locationController.text),
                              onFieldSubmitted: (value) => gameSetupCubit
                                  .setLocation(locationController.text),
                              onSaved: (newValue) => gameSetupCubit
                                  .setLocation(locationController.text),
                            ),
                          )),
                    ],
                  ),
                ),
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Textfield for date
                      SizedBox(
                        width: width * 0.3,
                        height: height * 0.15,
                        child: TextFormField(
                            controller: dateController,
                            decoration:
                                getDecoration(StringsGameSettings.lSelectDate),
                            onTap: () async {
                              DateTime? selectedDate = await selectDate(
                                  context, gameSetupState.date);
                              gameSetupCubit
                                  .setDate(selectedDate ?? gameSetupState.date);
                            }),
                      ),
                      // team dropdown showing all available teams from teams collection
                      TeamDropdown(),
                    ],
                  ),
                ),
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: CheckboxListTile(
                                  dense: true,
                                  title: Text(StringsGeneral.lHomeGame),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  value: gameSetupState.isHomeGame,
                                  onChanged: (bool? value) {
                                    if (value == true) {
                                      gameSetupCubit.setAtHome(true);
                                    } else {
                                      gameSetupCubit.setAtHome(false);
                                    }
                                  }),
                            ),
                            Flexible(
                              child: CheckboxListTile(
                                  dense: true,
                                  title: Text(StringsGeneral.lOutwardsGame),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  value: !gameSetupState.isHomeGame,
                                  onChanged: (bool? value) {
                                    if (value == true) {
                                      gameSetupCubit.setAtHome(false);
                                    } else {
                                      gameSetupCubit.setAtHome(true);
                                    }
                                  }),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: CheckboxListTile(
                            contentPadding: EdgeInsets.all(0),
                            title: Text(StringsGameSettings.lHomeSideIsRight),
                            controlAffinity: ListTileControlAffinity.leading,
                            value: gameSetupState.attackIsLeft,
                            onChanged: (bool? value) {
                              gameSetupCubit.setAttackIsLeft(value ?? false);
                            }),
                      ),
                      Flexible(
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Checkbox(
                                          fillColor: MaterialStateProperty.all<Color>(buttonDarkBlueColor),
                                          value: gameSetupState.isTestGame,
                                          onChanged: (bool? value) {
                                            gameSetupCubit.setTestGame(value ?? false);
                                          }),
                                    ),
                                    Flexible(child: Text(StringsGameSettings.lTestGame))
                                  ],
                                ),
                              ),
                    ],
                  ),
                ),
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: ElevatedButton(
                            style: ButtonStyle(
                                //padd button on every side
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    EdgeInsets.all(20)),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        buttonGreyColor)),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(StringsDashboard.lDashboard,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black))),
                      ),

                      // player selection button
                      Flexible(
                        // if there are no teams don't show the button for player selection
                        child: globalState.allTeams.isEmpty
                            ? Container()
                            : ElevatedButton(
                                style: ButtonStyle(
                                    padding:
                                        MaterialStateProperty.all<EdgeInsets>(
                                            EdgeInsets.all(20)),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            buttonLightBlueColor)),
                                onPressed: () {
                                  // store entered data to a new game object that will be used when the game is started at the end of the flow
                                  context.read<GameSetupCubit>().setSettings(
                                      opponent: opponentController.text,
                                      location: locationController.text,
                                      date: selectedDate,
                                      selectedTeamIndex: selectedTeamIndex,
                                      isHomeGame: isAtHome,
                                      attackIsLeft: attackIsLeft,
                                      isTestGame: isTestGame);
                                },
                                child: const Text(
                                    StringsTeamManagement.lSubmitButton,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                              ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );

    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text(StringsGeneral.lTrackNewGame),
    //     backgroundColor: buttonDarkBlueColor,
    //   ),
    //   body:
    //       // TODO implement season dropdown
    //       /*Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    //       Column(
    //         mainAxisAlignment: MainAxisAlignment.start,
    //         children: [
    //           Padding(
    //             padding: const EdgeInsets.all(5.0),
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.start,
    //               children: [
    //                 MenuButton(scaffoldKey),
    //                 Icon(Icons.sports_handball, color: buttonDarkBlueColor),
    //                 Expanded(child: Text(StringsGeneral.lTrackNewGame, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
    //                 //SizedBox(width: 0.2 * width, child: SeasonDropdown()),
    //               ],
    //             ),
    //           ),
    //           Divider(),
    //         ],
    //       ),*/
    //       Column(
    //     children: [
    //       // SizedBox(
    //       //   height: 0.08 * height,
    //       // ),
    //       Container(
    //         alignment: Alignment.center,
    //         width: width * 0.8,
    //         height: height * 0.55,
    //         padding: EdgeInsets.all(50),
    //         decoration: BoxDecoration(
    //             color: backgroundColor,
    //             border: Border.all(
    //               color: backgroundColor,
    //             ),
    //             // make round edges
    //             borderRadius: BorderRadius.all(Radius.circular(20))),
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           children: [
    //             Flexible(
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                 children: [
    //                   // Textfield for opponent name
    //                   MouseRegion(
    //                     onExit: (event) =>
    //                         gameSetupCubit.setOpponent(opponentController.text),
    //                     child: Flexible(
    //                       child: SizedBox(
    //                           width: width * 0.3,
    //                           height: height * 0.15,
    //                           // make sure that the text gets saved to state when the user leaves the textfield
    //                           child: Focus(
    //                             onFocusChange: (value) => value == false
    //                                 ? gameSetupCubit
    //                                     .setOpponent(opponentController.text)
    //                                 : {},
    //                             child: TextFormField(
    //                               controller: opponentController,
    //                               style: TextStyle(fontSize: 18),
    //                               decoration:
    //                                   getDecoration(StringsGeneral.lOpponent),
    //                               onEditingComplete: () => gameSetupCubit
    //                                   .setOpponent(opponentController.text),
    //                               onFieldSubmitted: (value) => gameSetupCubit
    //                                   .setOpponent(opponentController.text),
    //                               onSaved: (newValue) => gameSetupCubit
    //                                   .setOpponent(opponentController.text),
    //                             ),
    //                           )),
    //                     ),
    //                   ),
    //                   // Textfield for location
    //                   Flexible(
    //                     child: SizedBox(
    //                         width: width * 0.3,
    //                         height: height * 0.15,
    //                         // make sure that the text gets saved to state when the user leaves the textfield
    //                         child: Focus(
    //                           onFocusChange: (value) => value == false
    //                               ? gameSetupCubit
    //                                   .setLocation(locationController.text)
    //                               : {},
    //                           child: TextFormField(
    //                             controller: locationController,
    //                             decoration:
    //                                 getDecoration(StringsGeneral.lLocation),
    //                             onEditingComplete: () => gameSetupCubit
    //                                 .setLocation(locationController.text),
    //                             onFieldSubmitted: (value) => gameSetupCubit
    //                                 .setLocation(locationController.text),
    //                             onSaved: (newValue) => gameSetupCubit
    //                                 .setLocation(locationController.text),
    //                           ),
    //                         )),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //             Flexible(
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                 children: [
    //                   // Textfield for date
    //                   Flexible(
    //                     child: SizedBox(
    //                         width: width * 0.3,
    //                         height: height * 0.15,
    //                         child: TextFormField(
    //                             controller: dateController,
    //                             decoration: getDecoration(
    //                                 StringsGameSettings.lSelectDate),
    //                             onTap: () async {
    //                               DateTime? selectedDate = await selectDate(
    //                                   context, gameSetupState.date);
    //                               gameSetupCubit.setDate(
    //                                   selectedDate ?? gameSetupState.date);
    //                             })),
    //                   ),
    //                   // team dropdown showing all available teams from teams collection
    //                   Flexible(
    //                     child: SizedBox(
    //                       width: width * 0.3,
    //                       height: height * 0.15,
    //                       child: TeamDropdown(),
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //             Flexible(
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: [
    //                   Flexible(
    //                     child: Row(
    //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                       children: [
    //                         Flexible(
    //                             child: Row(
    //                           children: [
    //                             Checkbox(
    //                                 fillColor: MaterialStateProperty.all<Color>(
    //                                     buttonDarkBlueColor),
    //                                 value: gameSetupState.isHomeGame,
    //                                 onChanged: (bool? value) {
    //                                   if (value == true) {
    //                                     gameSetupCubit.setAtHome(true);
    //                                   } else {
    //                                     gameSetupCubit.setAtHome(false);
    //                                   }
    //                                 }),
    //                             Text(StringsGeneral.lHomeGame),
    //                           ],
    //                         )),
    //                         Flexible(
    //                             child: Row(
    //                           children: [
    //                             Checkbox(
    //                                 fillColor: MaterialStateProperty.all<Color>(
    //                                     buttonDarkBlueColor),
    //                                 value: !gameSetupState.isHomeGame,
    //                                 onChanged: (bool? value) {
    //                                   if (value == true) {
    //                                     gameSetupCubit.setAtHome(false);
    //                                   } else {
    //                                     gameSetupCubit.setAtHome(true);
    //                                   }
    //                                 }),
    //                             Text(StringsGeneral.lOutwardsGame),
    //                           ],
    //                         )),
    //                         Flexible(
    //                           child: Row(
    //                             children: [
    //                               Flexible(
    //                                 child: Checkbox(
    //                                     fillColor:
    //                                         MaterialStateProperty.all<Color>(
    //                                             buttonDarkBlueColor),
    //                                     value: gameSetupState.attackIsLeft,
    //                                     onChanged: (bool? value) {
    //                                       gameSetupCubit
    //                                           .setAttackIsLeft(value ?? false);
    //                                     }),
    //                               ),
    //                               Flexible(
    //                                   child: Text(
    //                                       StringsGameSettings.lHomeSideIsRight))
    //                             ],
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //       // SizedBox(
    //       //   height: 0.08 * height,
    //       // ),
    //       Container(
    //         alignment: Alignment.bottomCenter,
    //         child: Padding(
    //           padding:
    //               const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             crossAxisAlignment: CrossAxisAlignment.end,
    //             children: [
    //               Flexible(
    //                 child: SizedBox(
    //                   width: 0.15 * width,
    //                   height: 0.08 * height,
    //                   child: ElevatedButton(
    //                       style: ButtonStyle(
    //                           backgroundColor: MaterialStateProperty.all<Color>(
    //                               buttonGreyColor)),
    //                       onPressed: () {
    //                         Navigator.pop(context);
    //                       },
    //                       child: Text(StringsDashboard.lDashboard,
    //                           style: TextStyle(
    //                               fontSize: 18,
    //                               fontWeight: FontWeight.bold,
    //                               color: Colors.black))),
    //                 ),
    //               ),
    //               // player selection button
    //               Flexible(
    //                 child: SizedBox(
    //                   width: 0.15 * width,
    //                   height: 0.08 * height,
    //                   // if there are no teams don't show the button for player selection
    //                   child: globalState.allTeams.isEmpty
    //                       ? Container()
    //                       : ElevatedButton(
    //                           style: ButtonStyle(
    //                               backgroundColor:
    //                                   MaterialStateProperty.all<Color>(
    //                                       buttonLightBlueColor)),
    //                           onPressed: () {
    //                             // store entered data to a new game object that will be used when the game is started at the end of the flow
    //                             context.read<GameSetupCubit>().setSettings(
    //                                 opponent: opponentController.text,
    //                                 location: locationController.text,
    //                                 date: selectedDate,
    //                                 selectedTeamIndex: selectedTeamIndex,
    //                                 isHomeGame: isAtHome,
    //                                 attackIsLeft: attackIsLeft);
    //                           },
    //                           child: const Text(
    //                               StringsTeamManagement.lSubmitButton,
    //                               style: TextStyle(
    //                                   fontSize: 18,
    //                                   fontWeight: FontWeight.bold,
    //                                   color: Colors.black)),
    //                         ),
    //                 ),
    //               )
    //             ],
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }

  Future<DateTime?> selectDate(BuildContext context, initialDate) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101),
        builder: (context, child) {
          return Theme(
              data: ThemeData.light().copyWith(
                  colorScheme:
                      ColorScheme.fromSeed(seedColor: buttonDarkBlueColor)),
              child: child!);
        });
    if (picked != null && picked != initialDate) {
      return picked;
    }
    return null;
  }

  // configure decoration for all input fields
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

  // Daniel. Nov 11 2022. We don't really need this date selector for now. Might be useful later on.

}
