import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/constants/stringsTeamManagement.dart';
import 'package:handball_performance_tracker/data/game.dart';
import 'package:handball_performance_tracker/data/team.dart';
import 'package:handball_performance_tracker/widgets/team_selection_screen/team_dropdown.dart';
import '../../constants/stringsGameSettings.dart';
import '../../controllers/persistentController.dart';
import '../../controllers/tempController.dart';
import '../../constants/team_constants.dart';
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
  String season = "";
  String location = "";
  String opponent = "";

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
                        onSaved: (String? season) {
                          if (season != null) this.season = season;
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
                        child: Text('Select date'),
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
                        onSaved: (String? opponent) {
                          if (opponent != null) this.opponent = opponent;
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
                        onSaved: (String? location) {
                          if (location != null) this.location = location;
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
                      Checkbox(value: false, onChanged: (value) {}),
                      Text(StringsGeneral.lHomeGame)
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(value: false, onChanged: (value) {}),
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
                    // TODO save these infos in Firebase using repository

                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      // save input parameters
                      _formKey.currentState!.save();
                      // store entered data to a new game object that will be used when the game is started at the end of the flow 
                      PersistentController persistentController =
                          Get.find<PersistentController>();
                      Game preconfiguredGame = Game(
                          date: selectedDate,
                          clubId: persistentController.getLoggedInClub().id!,
                          location: location,
                          opponent: opponent,
                          season: season);
                      await persistentController
                          .setCurrentGame(preconfiguredGame, isNewGame: true);
                    }
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
