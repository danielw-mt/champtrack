import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/data/team.dart';
import 'package:handball_performance_tracker/widgets/team_selection_screen/team_dropdown.dart';
import '../../controllers/globalController.dart';
import '../../constants/team_constants.dart';
import '../../strings.dart';

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
    seasonController.text = "TODO";
    locationController.text = "TODO";
    opponentController.text = "TODO";
    // Build a Form widget using the _formKey created above.
    return GetBuilder<GlobalController>(
      builder: (GlobalController globalController) {
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
                          labelText: Strings.lSeason,
                        ),
                      )),
                  // team dropdown showing all available teams from teams collection
                  Column(
                    children: [
                      Text(Strings.lTeam),
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
                          labelText: Strings.lOpponent,
                        ),
                      )),
                  // Textfield for location
                  SizedBox(
                      width: width * 0.2,
                      child: TextFormField(
                        controller: locationController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: Strings.lLocation,
                        ),
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
                      Text(Strings.lHomeGame)
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(value: false, onChanged: (value) {}),
                      Text(Strings.lOutwardsGame)
                    ],
                  )
                ],
              ),
              Container(
                height: 20,
              ),
              Column(
                children: [
                  const Text(Strings.lHomeSideIsRight),
                  Switch(
                      value: globalController.attackIsLeft.value,
                      onChanged: (bool) {
                        globalController.attackIsLeft.value =
                            !globalController.attackIsLeft.value;
                        globalController.refresh();
                      }),
                ],
              ),
              Padding(
                // TODO create a lock in button
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // TODO save these infos in Firebase using repository

                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text(Strings.lProcessingData)),
                      );
                    }
                  },
                  child: const Text(Strings.lSubmitButton),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
