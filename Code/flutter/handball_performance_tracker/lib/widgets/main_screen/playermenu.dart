import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../controllers/globalController.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void callPlayerMenu(context) {
  Alert(
          context: context,
          title: "Select a player",
          // alert contains a list of DialogButton objects
          buttons: buildDialogButtonList(context))
      .show();
}

/// builds a list of Dialog buttons
List<DialogButton> buildDialogButtonList(BuildContext context) {
  final GlobalController globalController = Get.find<GlobalController>();
  var playerNames = globalController.chosenPlayers;
  List<DialogButton> dialogButtons = [];
  playerNames.forEach((rXString) {
    DialogButton dialogButton = buildDialogButton(context, rXString.toString());
    dialogButtons.add(dialogButton);
  });
  return dialogButtons;
}

/// builds a single dialog button that logs its text (=player name) to firestore
/// and updates the game state
DialogButton buildDialogButton(BuildContext context, String buttonText) {
  final GlobalController globalController = Get.find<GlobalController>();
  FirebaseFirestore db = FirebaseFirestore.instance;

  void logPlayerSelection() async {
    DateTime dateTime = DateTime.now();

    // update the firebase document containing the action details with the player id
    String mostRecentAction = globalController.lastGameActionId.value;
    final gameDocument = db.collection("gameData").doc(mostRecentAction);
    DocumentSnapshot documentSnapshot = await gameDocument.get();
    Map<String, dynamic> documentData =
        documentSnapshot.data() as Map<String, dynamic>;
    documentData["player_id"] = buttonText;
    globalController.actions.last = documentData;
    await db.collection("gameData").doc(mostRecentAction).update(documentData);
    globalController.refresh();
    print("last action saved in database: ");
    print(globalController.actions.last.toString());
  }

  return DialogButton(
      child: Text(
        buttonText,
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      onPressed: () {
        logPlayerSelection();
        Navigator.pop(context);
      });
}
