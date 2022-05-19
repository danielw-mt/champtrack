import 'package:flutter/material.dart';
import './../../controllers/globalController.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlayerDropdown extends StatelessWidget {
  GlobalController globalController = Get.find<GlobalController>();

  setFirstPlayerName() async {
    String playerName = "";
    FirebaseFirestore.instance
      ..collection("players").get().then((res) {
        print("Successfully completed");

        playerName = "" + res.docs.first.get("first_name") + " ";
        playerName = playerName + res.docs.first.get("last_name");
        this.globalController.selectedPlayer.value = playerName;
      });
  }

  @override
  Widget build(BuildContext context) {
    setFirstPlayerName();
    List<String> availablePlayers = [];
    //this.globalController.selectedPlayer.value = " Bialowas";
    var collection = FirebaseFirestore.instance.collection("players");
    final docRef = FirebaseFirestore.instance.collection("players").doc;

    return StreamBuilder(
      stream: collection.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          snapshot.data!.docs.forEach((element) {
            String firstName = element.get("first_name");
            String lastName = element.get("last_name");
            availablePlayers.add(firstName + " " + lastName);
          });
          return Obx(() => DropdownButton<String>(
                value: globalController.selectedPlayer.value,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String? newValue) {
                  globalController.selectedPlayer.value = newValue.toString();
                },
                items: availablePlayers
                    .map<DropdownMenuItem<String>>((String list_value) {
                  //print(list_value);
                  return DropdownMenuItem<String>(
                    value: list_value,
                    child: Text(list_value),
                  );
                }).toList(),
              ));
        }
        return Container();
      },
    );
  }
}
