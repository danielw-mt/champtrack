import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/features/team_management/team_management.dart';
import 'package:handball_performance_tracker/data/models/team_model.dart';
import 'package:handball_performance_tracker/core/core.dart';

// Create a corresponding State class.
// This class holds data related to the form.
class TeamSettings extends StatelessWidget {
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
    final TeamManagementState state = context.watch<TeamManagementCubit>().state;
    final globalState = context.watch<GlobalBloc>().state;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
          // Text(StringsTeamManagement.lTeamType),
          // FormField(
          //   builder: (state) => Column(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       SizedBox(
          //           width: width * 0.25,
          //           height: 200,
          //           child: ListView.builder(
          //               controller: ScrollController(),
          //               itemCount: teamTypes.length,
          //               itemBuilder: (context, index) {
          //                 String relevantTeamType = teamTypes[index];
          //                 return Row(
          //                   children: [
          //                     Checkbox(
          //                         fillColor: MaterialStateProperty.all<Color>(buttonDarkBlueColor),
          //                         value: isTeamTypeSelected(relevantTeamType),
          //                         onChanged: (value) {
          //                           if (value == true) {
          //                             selectedTeamType = index;
          //                           }
          //                         }),
          //                     Text(relevantTeamType)
          //                   ],
          //                 );
          //               })),
          //       Text(
          //         state.errorText ?? '',
          //         style: TextStyle(
          //           color: Theme.of(context).errorColor,
          //         ),
          //       )
          //     ],
          //   ),
          // ),
          // TODO implement a textfield that allows to set the league
          // Container(
          //   height: 20,
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // submit button
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 16.0),
              //   child: ElevatedButton(
              //     onPressed: () {
              //       // Validate returns true if the form is valid, or false otherwise.
              //       if (_formKey.currentState!.validate()) {
              //         Team newTeam = globalState.allTeams[state.selectedTeamIndex];
              //         newTeam.name = teamNameController.text;
              //         newTeam.type = TEAM_TYPE_MAPPING[selectedTeamType];
              //         context.read<GlobalBloc>().add(UpdateTeam(team: newTeam));
              //       }
              //     },
              //     child: const Text(StringsGeneral.lSubmitButton),
              //   ),
              // ),
              // delete button
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 16.0),
              //   child: ElevatedButton(
              //     onPressed: () {
              //       // TODO implement this dialog
              //       // Get.defaultDialog(
              //       //     title: StringsTeamManagement.lDeleteTeam,
              //       //     middleText: StringsTeamManagement.lConfirmDeleteTeam,
              //       //     textConfirm: StringsTeamManagement.lYes,
              //       //     textCancel: StringsTeamManagement.lNo,
              //       //     onConfirm: () {
              //       //       tempController.deleteSelectedTeam();
              //       //       Get.back();
              //       //       Get.back();
              //       //     },
              //       //     onCancel: () {
              //       //       Get.back();
              //       //     });
              //     },
              //     child: const Text(StringsTeamManagement.lDeleteTeam),
              //   ),
              // ),
              // submit button
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      Team newTeam = globalState.allTeams[state.selectedTeamIndex];
                      newTeam.name = teamNameController.text;
                      newTeam.type = TEAM_TYPE_MAPPING[selectedTeamType];
                      context.read<GlobalBloc>().add(UpdateTeam(team: newTeam));
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
  }
}
