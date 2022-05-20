import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/controllers/globalController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handball_performance_tracker/widgets/main_screen/field.dart';
import './../widgets/nav_drawer.dart';
import 'package:handball_performance_tracker/controllers/fieldSizeParameter.dart'
    as fieldSizeParameter;

class MainScreen extends StatelessWidget {
  // screen where the game takes place
  final GlobalController globalController = Get.put(GlobalController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(title: const Text("Title")),
      body: Column(
        children: [
          SizedBox(
              // FieldSwitch to swipe between right and left field side. SizedBox around it so there is no rendering error.
              width: fieldSizeParameter.fieldWidth,
              height: fieldSizeParameter.fieldHeight,
              child: const FieldSwitch()),
          TextButton(
              onPressed: () {},
              child: const Text(
                  "Testbutton")) // just a testbutton to see that it doesn't vanish when swiping from left to right field side
        ],
      ),
    );
  }
}

//Button class not needed yet, but leave it here for later
class Button extends StatelessWidget {
  FirebaseFirestore db = FirebaseFirestore.instance;
  Button({required this.text, Key? key}) : super(key: key);
  final text;

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
