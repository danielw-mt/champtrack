import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/core/constants/stringsTeamManagement.dart';
import 'package:handball_performance_tracker/controllers/persistent_controller.dart';
import '../../core/constants/stringsGeneral.dart';
import '../../controllers/temp_controller.dart';
import '../../core/constants/colors.dart';
import '../../data/models/team_model.dart';
import '../../core/constants/team_constants.dart';

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
  List<String> teamTypes = [StringsGeneral.lMenTeams, StringsGeneral.lWomenTeams, StringsGeneral.lYouthTeams];
  int selectedTeamType = 0;
  TextEditingController teamNameController = TextEditingController();

  bool isTeamTypeSelected(String teamType) {
    if (teamTypes[selectedTeamType] == teamType) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // Build a Form widget using the _formKey created above.
    return GetBuilder<TempController>(
      id: "team-details-form-state",
      builder: (TempController tempController) {
        teamNameController.text = tempController.getSelectedTeam().name;
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(StringsTeamManagement.lTeamName),
              TextFormField(
                controller: teamNameController,
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return StringsTeamManagement.lEmptyFieldWarning;
                  }
                  return null;
                },
              ),
              Container(
                height: 20,
              ),
              Text(StringsTeamManagement.lTeamType),
              FormField(
                builder: (state) => Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: width * 0.25,
                        height: 200,
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
              // TODO implement a textfield that allows to set the league
              Container(
                height: 20,
              ),
              Row(
                children: [
                  // submit button
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text(StringsGeneral.lProcessingData)),
                          );
                          Team newTeam = tempController.getSelectedTeam();
                          newTeam.name = teamNameController.text;
                          newTeam.type = TEAM_TYPE_MAPPING[selectedTeamType];
                          tempController.setSelectedTeam(newTeam);
                        }
                      },
                      child: const Text(StringsGeneral.lSubmitButton),
                    ),
                  ),
                  Container(
                    height: 20,
                    width: 20,
                  ),
                  // delete button
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Get.defaultDialog(
                            title: StringsTeamManagement.lDeleteTeam,
                            middleText: StringsTeamManagement.lConfirmDeleteTeam,
                            textConfirm: StringsTeamManagement.lYes,
                            textCancel: StringsTeamManagement.lNo,
                            onConfirm: () {
                              tempController.deleteSelectedTeam();
                              Get.back();
                              Get.back();
                            },
                            onCancel: () {
                              Get.back();
                            });
                      },
                      child: const Text(StringsTeamManagement.lDeleteTeam),
                    ),
                  ),
                  Container(
                    height: 20,
                    width: 20,
                  ),
                  // submit button
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text(StringsGeneral.lProcessingData)),
                          );
                          Team newTeam = tempController.getSelectedTeam();
                          newTeam.name = teamNameController.text;
                          newTeam.type = teamTypes[selectedTeamType];
                          tempController.setSelectedTeam(newTeam);
                        }
                      },
                      child: const Text(StringsGeneral.lSubmitButton),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
