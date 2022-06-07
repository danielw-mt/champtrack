import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../strings.dart';
import './../../controllers/globalController.dart';
import 'package:get/get.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import '../../data/game_action.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ActionFeed extends GetView<GlobalController> {
  // stop watch widget that allows to the time to be started, stopped, resetted and in-/decremented by 1 sec
  final GlobalController globalController = Get.find<GlobalController>();
  final numFeedItems = 5;

  Map<String, String> actionMapping = {
    "goal": Strings.lGoal,
    "1v1": Strings.lOneVsOneAnd7m,
    "2min": Strings.lTwoMin,
    "Fehlwurf": "err-throw", // TODO check if the same as "err" in Strings
    "trf": Strings.lTrf,
    "red": Strings.lRedCard,
    "foul": Strings.lFoul7m,
    "penalty": Strings.lTimePenalty,
    "block": Strings.lBlockNoBall,
    "block-steal": Strings.lBlockAndSteal
  };

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GlobalController>(
      builder: (_) => Container(
        alignment: Alignment.centerLeft,
        width: MediaQuery.of(context).size.width * 0.3,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: globalController.numCurrentFeedItems.value,
            itemBuilder: (context, index) {
              var actions = globalController.actions;
              List<dynamic> lastActions = actions.sublist(
                  actions.length - globalController.numCurrentFeedItems.value,
                  actions.length);
              GameAction lastAction = lastActions[index];
              String actionType = lastAction.actionType;
              return GestureDetector(
                  onTap: () async {
                    // find the document in firebase
                    // get the most recent game

                    // TODO clean this up and move it into data repository after !27 is finished
                    final FirebaseFirestore _db = FirebaseFirestore.instance;
                    QuerySnapshot mostRecentGameQuery = await _db
                        .collection("games")
                        .orderBy("date", descending: true)
                        .limit(1)
                        .get();
                    DocumentSnapshot mostRecentGame =
                        mostRecentGameQuery.docs[0];
                    // look inside gameActions for the latest x actions for that game
                    QuerySnapshot mostRecentActionQuery = await _db
                        .collection("gameData")
                        .doc(mostRecentGame.id)
                        .collection("actions")
                        .orderBy("timestamp", descending: true)
                        .limit(globalController.numCurrentFeedItems.value)
                        .get();

                    // delete the respective action
                    DocumentSnapshot respectiveRecentAction =
                        mostRecentActionQuery.docs[0];

                    _db
                        .collection("gameData")
                        .doc(mostRecentGame.id)
                        .collection("actions")
                        .doc(respectiveRecentAction.id)
                        .delete();

                    // delete action from game state
                    globalController.actions.removeAt(actions.length -
                        globalController.numCurrentFeedItems.value);
                    globalController.numCurrentFeedItems.value--;
                    globalController.refresh();
                  },
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(100, 217, 217, 217),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    actionType,
                                  )),
                            ),
                          ),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                Strings.lPlayerID + ": " + lastAction.playerId,
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Divider()
                    ],
                  ));
            }),
      ),
    );
  }
}
