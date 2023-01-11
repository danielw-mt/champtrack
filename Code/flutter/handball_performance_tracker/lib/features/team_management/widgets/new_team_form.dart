import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/data/models/team_model.dart';
import 'package:handball_performance_tracker/features/team_management/team_management.dart';
import 'package:handball_performance_tracker/core/core.dart';

class NewTeamForm extends StatefulWidget {
  @override
  NewTeamFormState createState() {
    return NewTeamFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class NewTeamFormState extends State<NewTeamForm> {
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
                            Team newTeam = Team(
                              name: teamNameController.text,
                              type: TEAM_TYPE_MAPPING[selectedTeamType],
                            );
                            context.read<GlobalBloc>().add(CreateTeam(team: newTeam));
                            Navigator.pop(context);
                            // if the added team is the first team to be added select this team right away
                            if (context.read<GlobalBloc>().state.allTeams.length == 1) {
                              context.read<TeamManagementBloc>().add(SelectTeam(index: 0));
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
            )
          ],
        ),
      )
    ]);
  }
}
