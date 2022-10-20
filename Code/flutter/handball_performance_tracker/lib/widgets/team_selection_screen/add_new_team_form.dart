import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/constants/positions.dart';
import 'package:handball_performance_tracker/constants/team_constants.dart';
import '../../constants/colors.dart';
import '../../constants/stringsGeneral.dart';
import 'package:handball_performance_tracker/controllers/persistent_controller.dart';
import 'package:handball_performance_tracker/data/team.dart';
import '../../data/player.dart';
import '../../data/club.dart';
import '../../data/database_repository.dart';
import '../../controllers/temp_controller.dart';
import 'package:get/get.dart';

class NewTeamForm extends StatefulWidget {
  @override
  NewTeamFormState createState() {
    return NewTeamFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class NewTeamFormState extends State<NewTeamForm> {
  TempController tempController = Get.find<TempController>();
  PersistentController persistentController = Get.find<PersistentController>();
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  TextEditingController teamNameController = TextEditingController();
  List<String> teamTypes = [StringsGeneral.lMenTeams, StringsGeneral.lWomenTeams, StringsGeneral.lYouthTeams];
  int selectedTeamType = 0;

  bool isTeamTypeSelected(String teamType) {
    if (teamTypes[selectedTeamType] == teamType) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
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

    // Build a Form widget using the _formKey created above.
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(children: [
      //Text(StringsGeneral.lAddTeam),
      Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: width * 0.25,
              child: TextFormField(
                style: TextStyle(fontSize: 18),
                decoration: getDecoration(StringsGeneral.lTeam),
                controller: teamNameController,
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return StringsGeneral.lTextFieldEmpty;
                  }
                  return null;
                },
              ),
            ),
            FormField(
              builder: (state) => Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(StringsGeneral.lTeamTypes),
                  SizedBox(
                      width: width * 0.25,
                      height: 100,
                      child: ListView.builder(
                          controller: ScrollController(),
                          itemCount: teamTypes.length,
                          itemBuilder: (context, index) {
                            String relevantTeamType = teamTypes[index];
                            return Row(
                              children: [
                                Checkbox(
                                    fillColor: MaterialStateProperty.all<Color>(buttonDarkBlueColor),
                                    value: isTeamTypeSelected(relevantTeamType),
                                    onChanged: (value) {
                                      setState(() {
                                        if (value == true) {
                                          selectedTeamType = index;
                                        }
                                      });
                                    }),
                                Text(relevantTeamType)
                              ],
                            );
                          })),
                  Text(
                    state.errorText ?? '',
                    style: TextStyle(
                      color: Theme.of(context).errorColor,
                    ),
                  )
                ],
              ),
            ),

            // Submit button
            Container(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      child: ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(buttonGreyColor)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          StringsGeneral.lBack,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                    ),
                    Flexible(
                      child: ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(buttonLightBlueColor)),
                        onPressed: () {
                          // Validate returns true if the form is valid, or false otherwise.
                          if (_formKey.currentState!.validate()) {
                            persistentController.addTeam(teamNameController.text, TEAM_TYPE_MAPPING[selectedTeamType]);
                            Navigator.pop(context);
                            if (persistentController.getAvailableTeams().length == 1) {
                              tempController.setSelectedTeam(persistentController.getAvailableTeams()[0]);
                            }
                          }
                        },
                        child: const Text(
                          StringsGeneral.lSubmitButton,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
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
