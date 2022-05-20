import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import './../../controllers/globalController.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ActionMenu extends GetView<GlobalController> {
  final GlobalController globalController = Get.find<GlobalController>();
  List<String> attackActions = [
    "Tor",
    "1v1 & 7m",
    "2min ziehen",
    "Fehlwurf",
    "TRF"
  ];
  List<String> defenseActions = [
    "Rote Karte",
    "Foul => 7m",
    "Zeitstrafe",
    "Block ohne Ballgewinn",
    "Block & Steal"
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GetBuilder<GlobalController>(
            builder: (_) => Switch(
                value: globalController.attackMode.value,
                onChanged: (bool value) {
                  globalController.attackMode.value =
                      !globalController.attackMode.value;
                  globalController.refresh();
                })),
        TextButton(
            onPressed: () {
              Alert(
                      context: context,
                      title: "Select an action",
                      buttons: globalController.attackMode.value
                          ? buildDialogButtonList(context, attackActions)
                          : buildDialogButtonList(context, defenseActions))
                  .show();
            },
            child: Text("Trigger Action")),
      ],
    );
  }

  List<DialogButton> buildDialogButtonList(
      BuildContext context, List<String> buttonTexts) {
    List<DialogButton> dialogButtons = [];
    buttonTexts.forEach((text) {
      DialogButton dialogButton = buildDialogButton(context, text);
      dialogButtons.add(dialogButton);
    });
    return dialogButtons;
  }

  DialogButton buildDialogButton(BuildContext context, String buttonText) {
    FirebaseFirestore db = FirebaseFirestore.instance;

    void logAction() async {
      DateTime dateTime = DateTime.now();
      int unixTime = dateTime.toUtc().millisecondsSinceEpoch;
      int secondsSinceGameStart =
          globalController.stopWatchTimer.value.secondTime.value;

      // TODO get most recent game id from DB gamestate or db instead of hardcoding
      String mostRecentGame = "zqKzCZB5nGPVuF7H3CGe";

      Map<String, dynamic> action = {
        "club_id": "-1",
        "game_id": mostRecentGame,
        "player_id": "",
        "type": globalController.attackMode.value ? "attack" : "defense",
        "action_type": buttonText,
        "position": "",
        "timestamp": unixTime,
        "relative_time": secondsSinceGameStart
      };
      globalController.actions.add(buttonText);

      // add action to firebase

      // store most recent action id in game state for the player menu
      // when a player was selected in that menu the action document can be
      // updated in firebase with their player_id using the action_id
      db.collection("gameData").add(action).then((DocumentReference doc) =>
          globalController.lastActionId.value = doc.id);
    }

    return DialogButton(
        child: Text(
          buttonText,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () {
          logAction();
          Navigator.pop(context);
        });
  }
}
