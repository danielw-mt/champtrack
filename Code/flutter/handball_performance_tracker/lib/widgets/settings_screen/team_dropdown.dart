import 'package:flutter/material.dart';
import '../../data/database_repository.dart';
import '../../data/player.dart';
import '../../controllers/globalController.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/team.dart';

// dropdown that shows all available teams
class TeamDropdown extends GetView<GlobalController> {
  GlobalController globalController = Get.find<GlobalController>();

  // TODO:
  // * list all the teams
  // when team is selected updated global state

  @override
  Widget build(BuildContext context) {
    DatabaseRepository repository = DatabaseRepository();

    List<Team> availableTeams = [];

    return StreamBuilder<QuerySnapshot>(
      stream: repository.getAllTeamsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // set default selection as the first team in db
          globalController.selectedTeam.value = Team.fromDocumentSnapshot(
              snapshot.data!.docs[0] as DocumentSnapshot<Map<String, dynamic>>);
          // add all the team objects to the available teams list so they can be used later in the dropdown
          for (var element in snapshot.data!.docs) {
            Team team = Team.fromDocumentSnapshot(
                element as DocumentSnapshot<Map<String, dynamic>>);
            if (!availableTeams.contains(team)) {
              availableTeams.add(team);
            }
          }
          // build the dropdown button
          return DropdownButton<String>(
            value: globalController.selectedTeam.value.id,
            icon: const Icon(Icons.arrow_downward),
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String? newValue) {
              globalController.selectedTeam.value = availableTeams
                  .firstWhere((element) => element.id == newValue);
            },
            // build dropdown item widgets
            items: availableTeams.map<DropdownMenuItem<String>>((Team team) {
              return DropdownMenuItem<String>(
                value: team.id,
                child: Text(team.name),
              );
            }).toList(),
          );
        }
        return Container();
      },
    );
  }
}
