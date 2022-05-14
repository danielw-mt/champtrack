import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/controllers/mainScreenController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './../widgets/nav_drawer.dart';

class MainScreen extends StatelessWidget {
  List<String> playerNames = [];
  String selectedPlayer = "";
  final MainScreenController mainScreenController =
      Get.put(MainScreenController());
  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < 7; i++) {
      mainScreenController.playerNameControllers.add(TextEditingController());
    }

    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(title: Text("Title")),
      body: Column(
        children: [
          SizedBox(
            width: 1000,
            height: 400,
            child: ListView.builder(
                padding: const EdgeInsets.all(5),
                itemCount: 7,
                itemBuilder: (BuildContext context, int index) {
                  return Obx(
                    () => TextField(
                      onTap: () {
                        mainScreenController.selectedPlayer.value =
                            mainScreenController
                                .playerNameControllers[index].value.text;
                      },
                      controller:
                          mainScreenController.playerNameControllers[index],
                    ),
                  );
                }),
          ),
          SizedBox(
            width: 700,
            height: 300,
            child: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              crossAxisCount: 6,
              children: <Widget>[
                Button(text: "Tor Position"),
                Button(text: "Tor 9m"),
                Button(text: "Tor 9m+"),
                Button(text: "Assist"),
                Button(text: "Fehlwurf"),
                Button(text: "TRF"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void toggleAction(buttonText) {
    if (selectedPlayer != "") {
      print("Player " + selectedPlayer + " performed action " + buttonText);
    }
  }
}

class Button extends StatelessWidget {
  FirebaseFirestore db = FirebaseFirestore.instance;
  Button({required this.text, Key? key}) : super(key: key);

  final text;

  //Button(String text){this.text = text;}

  @override
  Widget build(BuildContext context) {
    final MainScreenController mainScreenController =
        Get.find<MainScreenController>();
    return TextButton(
      style: TextButton.styleFrom(
        textStyle: const TextStyle(fontSize: 20),
      ),
      onPressed: () {
        print("Player " +
            mainScreenController.selectedPlayer.value +
            " performed action " +
            text);
        final action = <String, String>{
          mainScreenController.selectedPlayer.value: text
        };
        db.collection("actions").add(action).then(
            (DocumentReference doc) => print("hat funktioniert. ${doc.id}"));
        db.collection("actions").get().then((event) {
          for (var doc in event.docs) {
            print("${doc.id} => ${doc.data()}");
          }
        });
      },
      child: Text(
        text,
        softWrap: false,
      ),
    );
  }
}
