import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return GetBuilder<GlobalController>(
      builder: (GlobalController globalController) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(Strings.lTeamName),
              TextFormField(
                initialValue: globalController.selectedTeam.value.name,
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return Strings.lEmptyFieldWarning;
                  }
                  return null;
                },
              ),
              Text(Strings.lTeamType),
              // TODO implement a dropdown for selecting the team type based on the constants team_constants.dart
              // TODO implement a textfield that allows to set the league
              Padding(
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
 
 