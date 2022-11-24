import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/core/constants/colors.dart';
import 'package:handball_performance_tracker/core/constants/stringsTeamManagement.dart';
import 'package:handball_performance_tracker/core/core.dart';
import 'package:handball_performance_tracker/data/models/game_model.dart';
import 'package:handball_performance_tracker/old-screens/player_selection_screen.dart';
import 'package:handball_performance_tracker/core/constants/stringsDashboard.dart';
import 'package:handball_performance_tracker/core/constants/stringsGameSettings.dart';
import 'package:handball_performance_tracker/core/constants/stringsGeneral.dart';
import 'package:handball_performance_tracker/features/dashboard/dashboard.dart';
import 'package:handball_performance_tracker/features/sidebar/sidebar.dart';
import 'package:handball_performance_tracker/data/models/team_model.dart';
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
    // TODO implement season dropdown
    TextEditingController seasonController = TextEditingController();
    TextEditingController opponentController = TextEditingController(text: gameSetupState.opponent);
    TextEditingController locationController = TextEditingController(text: gameSetupState.location);
    locationController.text = gameSetupState.location;
    DateTime selectedDate = gameSetupState.date ?? DateTime.now();
    int selectedTeamIndex = gameSetupState.selectedTeamIndex;
    bool isAtHome = gameSetupState.isHomeGame;
    bool attackIsLeft = gameSetupState.attackIsLeft;

    // Build a Form widget using the _formKey created above.
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(StringsGeneral.lTrackNewGame),
        backgroundColor: buttonDarkBlueColor,
      ),
      body:
          // TODO implement season dropdown
          /*Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    MenuButton(scaffoldKey),
                    Icon(Icons.sports_handball, color: buttonDarkBlueColor),
                    Expanded(child: Text(StringsGeneral.lTrackNewGame, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                    //SizedBox(width: 0.2 * width, child: SeasonDropdown()),
                  ],
                ),
              ),
              Divider(),
            ],
          ),*/
          Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(
              height: 0.08 * height,
            ),
            Container(
              alignment: Alignment.topCenter,
              width: width * 0.8,
              height: height * 0.55,
              padding: EdgeInsets.all(50),
              decoration: BoxDecoration(
                  color: backgroundColor,
                  border: Border.all(
                    color: backgroundColor,
                  ),
                  // make round edges
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Textfield for opponent name
                        Flexible(
                          child: SizedBox(
                              width: width * 0.3,
                              height: height * 0.15,
                              child: TextFormField(
                                controller: opponentController,
                                style: TextStyle(fontSize: 18),
                                decoration: getDecoration(StringsGeneral.lOpponent),
                                // TODO probably don't need this
                                // onChanged: (String? input) {
                                //   if (input != null) opponentController.text = input;
                                // },
                              )),
                        ),
                        // Textfield for location
                        Flexible(
                          child: SizedBox(
                              width: width * 0.3,
                              height: height * 0.15,
                              child: TextFormField(
                                controller: locationController,
                                decoration: getDecoration(StringsGeneral.lLocation),
                                // TODO probably don't need this with statelesswidget
                                // onChanged: (String? input) {
                                //   if (input != null) location = input;
                                // },
                              )),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // team dropdown showing all available teams from teams collection
                        Flexible(
                          child: SizedBox(
                            width: width * 0.3,
                            height: height * 0.15,
                            child: TeamDropdown(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Flexible(
                                  child: Row(
                                children: [
                                  Checkbox(
                                      fillColor: MaterialStateProperty.all<Color>(buttonDarkBlueColor),
                                      value: isAtHome,
                                      onChanged: (bool? value) {
                                        isAtHome = value!;
                                      }),
                                  Text(StringsGeneral.lHomeGame),
                                ],
                              )),
                              Flexible(
                                  child: Row(
                                children: [
                                  Checkbox(
                                      fillColor: MaterialStateProperty.all<Color>(buttonDarkBlueColor),
                                      value: !isAtHome,
                                      onChanged: (bool? value) {
                                        isAtHome = !value!;
                                      }),
                                  Text(StringsGeneral.lOutwardsGame),
                                ],
                              )),
                              Flexible(
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Checkbox(
                                          fillColor: MaterialStateProperty.all<Color>(buttonDarkBlueColor),
                                          value: attackIsLeft,
                                          onChanged: (bool? value) {
                                            attackIsLeft = value ?? attackIsLeft;
                                          }),
                                    ),
                                    Flexible(child: Text(StringsGameSettings.lHomeSideIsRight))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 0.08 * height,
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      child: SizedBox(
                        width: 0.15 * width,
                        height: 0.08 * height,
                        child: ElevatedButton(
                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(buttonGreyColor)),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child:
                                Text(StringsDashboard.lDashboard, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black))),
                      ),
                    ),
                    // player selection button
                    Flexible(
                      child: SizedBox(
                        width: 0.15 * width,
                        height: 0.08 * height,
                        // if there are no teams don't show the button for player selection
                        child: globalState.allTeams.isEmpty
                            ? Container()
                            : ElevatedButton(
                                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(buttonLightBlueColor)),
                                onPressed: () {
                                  // store entered data to a new game object that will be used when the game is started at the end of the flow
                                  context.read<GameSetupCubit>().setSettings(
                                      opponent: opponentController.text,
                                      location: locationController.text,
                                      date: selectedDate,
                                      selectedTeamIndex: selectedTeamIndex,
                                      isHomeGame: isAtHome,
                                      attackIsLeft: attackIsLeft);
                                },
                                child: const Text(StringsTeamManagement.lSubmitButton,
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                              ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // configure decoration for all input fields
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

  // Daniel. Nov 11 2022. We don't really need this date selector for now. Might be useful later on.

  // Future<void> selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //       context: context,
  //       initialDate: selectedDate,
  //       firstDate: DateTime(2015, 8),
  //       lastDate: DateTime(2101),
  //       builder: (context, child) {
  //         return Theme(data: ThemeData.light().copyWith(colorScheme: ColorScheme.fromSeed(seedColor: buttonDarkBlueColor)), child: child!);
  //       });
  //   if (picked != null && picked != selectedDate) {
  //     selectedDate = picked;
  //     // dateController.text = "${selectedDate.toLocal()}".split(' ')[0];
  //   }
  // }
}
