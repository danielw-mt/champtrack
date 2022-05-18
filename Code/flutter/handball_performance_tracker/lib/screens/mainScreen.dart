import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/controllers/globalController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handball_performance_tracker/widgets/widget.dart';
import './../widgets/nav_drawer.dart';
import './../widgets/handball_court/goal.dart';

class MainScreen extends StatelessWidget {
  List<String> playerNames = [];
  String selectedPlayer = "";
  final GlobalController globalController = Get.put(GlobalController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(title: Text("Title")),
      body: Column(
        children: [CoordinateDetector()],
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
    final GlobalController globalController = Get.find<GlobalController>();
    return TextButton(
      style: TextButton.styleFrom(
        textStyle: const TextStyle(fontSize: 20),
      ),
      onPressed: () {
        print("Player " +
            globalController.selectedPlayer.value +
            " performed action " +
            text);
        final action = <String, String>{
          globalController.selectedPlayer.value: text
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
