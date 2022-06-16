import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/globalController.dart';

// Create a Form widget.
class TeamDetailsForm extends StatefulWidget {
  const TeamDetailsForm({super.key});

  @override
  TeamDetailsFormState createState() {
    return TeamDetailsFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class TeamDetailsFormState extends State<TeamDetailsForm> {
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
              Text("Team Name"),
              TextFormField(
                initialValue: globalController.selectedTeam.value.name,
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              Text("Team Type"),
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
                        const SnackBar(content: Text('Processing Data')),
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
 
 