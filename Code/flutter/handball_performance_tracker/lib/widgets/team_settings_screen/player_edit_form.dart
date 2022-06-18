import 'package:flutter/material.dart';
import '../../strings.dart';

class PlayerForm extends StatefulWidget {
  // TODO just receive playerID as argument and build form from state

  final String playerId;

  const PlayerForm({super.key, required this.playerId});

  @override
  PlayerFormState createState() {
    return PlayerFormState(this.playerId);
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class PlayerFormState extends State<PlayerForm> {
  String playerId;
  PlayerFormState(this.playerId);

  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController nickNameController = TextEditingController();
  TextEditingController shirtNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO build test for each controller directly from AppState
    
    // firstNameController.text = firstName;
    // lastNameController.text = lastName;
    // shirtNumberController.text = shirtNumber;

    // Build a Form widget using the _formKey created above.
    double width = MediaQuery.of(context).size.width;
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: width * 0.25,
                child: TextFormField(
                  controller: firstNameController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: Strings.lFirstName),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                width: width * 0.25,
                child: TextFormField(
                  controller: lastNameController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: Strings.lLastName),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
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
                child: TextFormField(
                  controller: nickNameController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: Strings.lNickName),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                width: width * 0.25,
                child: TextFormField(
                  controller: shirtNumberController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: Strings.lShirtNumber),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
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
              Column(
                children: [
                  Text(Strings.lTeams),
                  SizedBox(
                    width: width * 0.25,
                    height: 50,
                    child: ListView(
                      children: [
                        Text("TODO"),
                        Text("Mannschaft"),
                        Text("Mannschaft"),
                        Text("Mannschaft")
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(Strings.lPosition),
                  SizedBox(
                    width: width * 0.25,
                    height: 50,
                    child: ListView.builder(
                      itemCount: 7,
                      shrinkWrap: true,
                      itemBuilder: (context, item) {
                        List<String> positionNames = [
                          Strings.lGoalkeeper,
                          Strings.lLeftBack,
                          Strings.lCenterBack,
                          Strings.lRightBack,
                          Strings.lLeftWinger,
                          Strings.lCenterForward,
                          Strings.lRightWinger
                        ];
                        return Row(
                          children: [
                            Text(positionNames[item]),
                            // TODO implement checkbox
                            Checkbox(value: false, onChanged: (value) {})
                          ],
                        );
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
          Container(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
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
  }
}
