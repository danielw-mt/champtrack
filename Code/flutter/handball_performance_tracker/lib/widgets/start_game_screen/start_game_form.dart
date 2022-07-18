import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/constants/colors.dart';
import 'package:handball_performance_tracker/constants/stringsTeamManagement.dart';
import 'package:handball_performance_tracker/data/game.dart';
import 'package:handball_performance_tracker/screens/playerSelectionScreen.dart';
import 'package:handball_performance_tracker/widgets/start_game_screen/season_dropdown.dart';
import 'package:handball_performance_tracker/widgets/team_selection_screen/team_dropdown.dart';
import '../../constants/stringsDashboard.dart';
import '../../constants/stringsGameSettings.dart';
import '../../controllers/persistentController.dart';
import '../../controllers/tempController.dart';
import '../../constants/stringsGeneral.dart';
import '../../screens/dashboard.dart';
import '../nav_drawer.dart';

// Create a Form widget.
class StartGameForm extends StatefulWidget {
  GlobalKey<ScaffoldState> scaffoldKey;

  StartGameForm(scaffoldKey, {super.key}) : scaffoldKey = scaffoldKey;

  @override
  StartGameFormState createState() {
    return StartGameFormState(scaffoldKey);
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class StartGameFormState extends State<StartGameForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  TextEditingController seasonController = TextEditingController();
  TextEditingController opponentController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  String teamId = "";
  String season = "";
  String location = "";
  String opponent = "";
  bool isAtHome = true;

  GlobalKey<ScaffoldState> scaffoldKey;

  StartGameFormState(scaffoldKey) : scaffoldKey = scaffoldKey;

  @override
  void initState() {
    // check if there was already a game initialized (e.g. we're entering the form via the 'back-button')
    Game currentGame = Get.find<PersistentController>().getCurrentGame();
    bool gameExists = (currentGame.id == null) ? false : true;

    // if so, make sure data from current game object is used
    if (gameExists) {
      teamId = currentGame.teamId;
      season = currentGame.season!;
      location = currentGame.location!;
      opponent = currentGame.opponent!;
      isAtHome = currentGame.isAtHome!;
      selectedDate = currentGame.date;
      // display correct values
      locationController.text = location;
      opponentController.text = opponent;
    }

    dateController.text = "${selectedDate.toLocal()}".split(' ')[0];
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101),
        builder: (context, child) {
          return Theme(
              data: ThemeData.light().copyWith(
                  colorScheme:
                      ColorScheme.fromSeed(seedColor: buttonDarkBlueColor)),
              child: child!);
        });
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      dateController.text = "${selectedDate.toLocal()}".split(' ')[0];
    }
  }

  @override
  Widget build(BuildContext context) {
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

    // Build a Form widget using the _formKey created above.
    return GetBuilder<TempController>(
      id: "start-game-form",
      builder: (TempController tempController) {
        double width = MediaQuery.of(context).size.width;
        double height = MediaQuery.of(context).size.height;
        return Column(children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                MenuButton(scaffoldKey),
                Icon(Icons.sports_handball, color: buttonDarkBlueColor),
                Expanded(
                    child: Text(StringsGeneral.lTrackNewGame,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold))),
                SizedBox(width: 0.2 * width, child: SeasonDropdown()),
              ],
            ),
          ),
          Divider(),
          Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 0.1 * height,
                ),
                Container(
                  alignment: Alignment.topCenter,
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.6,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Textfield for opponent name
                          SizedBox(
                              width: width * 0.3,
                              height: height * 0.15,
                              child: TextFormField(
                                controller: opponentController,
                                style: TextStyle(fontSize: 18),
                                decoration:
                                    getDecoration(StringsGeneral.lOpponent),
                                onChanged: (String? input) {
                                  if (input != null) opponent = input;
                                },
                              )),
                          // Textfield for location
                          SizedBox(
                              width: width * 0.3,
                              height: height * 0.15,
                              child: TextFormField(
                                controller: locationController,
                                decoration:
                                    getDecoration(StringsGeneral.lLocation),
                                onChanged: (String? input) {
                                  if (input != null) location = input;
                                },
                              )),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // DateTime Picker
                          SizedBox(
                              width: width * 0.3,
                              height: height * 0.15,
                              child: TextFormField(
                                controller: dateController,
                                decoration: getDecoration(
                                    StringsGameSettings.lSelectDate),
                                onTap: () => selectDate(context),
                              )),
                          // team dropdown showing all available teams from teams collection
                          SizedBox(
                            width: width * 0.3,
                            height: height * 0.15,
                            child: TeamDropdown(),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 0.3 * width,
                            height: height * 0.15,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Checkbox(
                                    fillColor: MaterialStateProperty.all<Color>(
                                        buttonDarkBlueColor),
                                    value: isAtHome,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        isAtHome = value!;
                                      });
                                    }),
                                Text(StringsGeneral.lHomeGame),
                                Checkbox(
                                    fillColor: MaterialStateProperty.all<Color>(
                                        buttonDarkBlueColor),
                                    value: !isAtHome,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        isAtHome = !value!;
                                      });
                                    }),
                                Text(StringsGeneral.lOutwardsGame)
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 0.3 * width,
                            height: height * 0.15,
                            child: Row(
                              children: [
                                Checkbox(
                                    fillColor: MaterialStateProperty.all<Color>(
                                        buttonDarkBlueColor),
                                    value: tempController.getAttackIsLeft(),
                                    onChanged: (bool? value) {
                                      setState(() {
                                        tempController.setAttackIsLeft(value!);
                                      });
                                    }),
                                Text(StringsGameSettings.lHomeSideIsRight)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 0.1 * height,
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    // TODO create a lock in button
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 0.15 * width,
                          height: 0.08 * height,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          buttonGreyColor)),
                              onPressed: () {
                                Get.to(() => Dashboard());
                              },
                              child: Text(StringsDashboard.lDashboard,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black))),
                        ),
                        SizedBox(
                          width: 0.15 * width,
                          height: 0.08 * height,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        buttonLightBlueColor)),
                            onPressed: () async {
                              PersistentController persistentController =
                                  Get.find<PersistentController>();
                              // check if there was already a game created and information is only updated
                              Game currentGame =
                                  persistentController.getCurrentGame();
                              bool gameExists =
                                  (currentGame.id == null) ? false : true;
                              if (gameExists) {
                                // update information based on user input
                                currentGame.date = selectedDate;
                                currentGame.teamId = teamId;
                                currentGame.location = location;
                                currentGame.opponent = opponent;
                                currentGame.season = season;
                                currentGame.isAtHome = isAtHome;
                                persistentController
                                    .setCurrentGame(currentGame);
                              } else {
                                // store entered data to a new game object that will be used when the game is started at the end of the flow
                                Game preconfiguredGame = Game(
                                    date: selectedDate,
                                    clubId: persistentController
                                        .getLoggedInClub()
                                        .id!,
                                    teamId:
                                        tempController.getSelectedTeam().id!,
                                    location: location,
                                    opponent: opponent,
                                    season: tempController.getSelectedSeason(),
                                    isAtHome: isAtHome);
                                await persistentController.setCurrentGame(
                                    preconfiguredGame,
                                    isNewGame: true);
                              }
                              Get.to(() => PlayerSelectionScreen());
                            },
                            child: const Text(
                                StringsTeamManagement.lSubmitButton,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]);
      },
    );
  }
}
