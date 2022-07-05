import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/constants/stringsTeamManagement.dart';
import 'package:handball_performance_tracker/data/game.dart';
import 'package:handball_performance_tracker/widgets/team_selection_screen/team_dropdown.dart';
import '../../constants/stringsGameSettings.dart';
import '../../controllers/persistentController.dart';
import '../../controllers/tempController.dart';
import '../../constants/stringsGeneral.dart';

// Create a Form widget.
class StartGameForm extends StatefulWidget {
  const StartGameForm({super.key});

  @override
  StartGameFormState createState() {
    return StartGameFormState();
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

  DateTime selectedDate = DateTime.now();
  String teamId = "";
  String season = "";
  String location = "";
  String opponent = "";
  bool isAtHome = true;

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
      seasonController.text = season;
      locationController.text = location;
      opponentController.text = opponent;
    }

    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return GetBuilder<TempController>(
      id: "start-game-form",
      builder: (TempController tempController) {
        double width = MediaQuery.of(context).size.width;
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Textfield allowing to set season. Later this should not be a textfield but a value from the club settings
                  SizedBox(
                      width: width * 0.2,
                      child: TextFormField(
                        controller: seasonController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: StringsGeneral.lSeason,
                        ),
                        onChanged: (String? input) {
                          if (input != null) season = input;
                        },
                      )),
                  // team dropdown showing all available teams from teams collection
                  Column(
                    children: [
                      Text(StringsGeneral.lTeam),
                      TeamDropdown(),
                    ],
                  ),
                  // DateTime Picker
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text("${selectedDate.toLocal()}".split(' ')[0]),
                      SizedBox(
                        height: 20.0,
                      ),
                      ElevatedButton(
                        onPressed: () => selectDate(context),
                        child: Text(StringsGameSettings.lSelectDate),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Textfield for opponent name
                  SizedBox(
                      width: width * 0.2,
                      child: TextFormField(
                        controller: opponentController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: StringsGeneral.lOpponent,
                        ),
                        onChanged: (String? input) {
                          if (input != null) opponent = input;
                        },
                      )),
                  // Textfield for location
                  SizedBox(
                      width: width * 0.2,
                      child: TextFormField(
                        controller: locationController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: StringsGeneral.lLocation,
                        ),
                        onChanged: (String? input) {
                          if (input != null) location = input;
                        },
                      )),
                ],
              ),
              Container(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Checkbox(
                          value: isAtHome,
                          onChanged: (bool? value) {
                            setState(() {
                              isAtHome = value!;
                            });
                          }),
                      Text(StringsGeneral.lHomeGame)
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                          value: !isAtHome,
                          onChanged: (bool? value) {
                            setState(() {
                              isAtHome = !value!;
                            });
                          }),
                      Text(StringsGeneral.lOutwardsGame)
                    ],
                  )
                ],
              ),
              Container(
                height: 20,
              ),
              Column(
                children: [
                  const Text(StringsGameSettings.lHomeSideIsRight),
                  Switch(
                      value: tempController.getAttackIsLeft(),
                      onChanged: (bool value) {
                        tempController.setAttackIsLeft(value);
                      }),
                ],
              ),
              Padding(
                // TODO create a lock in button
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    PersistentController persistentController =
                        Get.find<PersistentController>();
                    // check if there was already a game created and information is only updated
                    Game currentGame = persistentController.getCurrentGame();
                    bool gameExists = (currentGame.id == null) ? false : true;
                    if (gameExists) {
                      // update information based on user input
                      currentGame.date = selectedDate;
                      currentGame.teamId = teamId;
                      currentGame.location = location;
                      currentGame.opponent = opponent;
                      currentGame.season = season;
                      currentGame.isAtHome = isAtHome;
                      persistentController.setCurrentGame(currentGame);
                    } else {
                      // store entered data to a new game object that will be used when the game is started at the end of the flow
                      Game preconfiguredGame = Game(
                          date: selectedDate,
                          clubId: persistentController.getLoggedInClub().id!,
                          teamId: tempController.getSelectedTeam().id!,
                          location: location,
                          opponent: opponent,
                          season: season,
                          isAtHome: isAtHome);
                      await persistentController
                          .setCurrentGame(preconfiguredGame, isNewGame: true);
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(StringsGameSettings.lGameDataSaved)),
                    );
                  },
                  child: const Text(StringsTeamManagement.lSubmitButton),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
