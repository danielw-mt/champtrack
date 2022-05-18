import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/controllers/globalController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
        children: [
          GestureDetector(
            onTapDown: (TapDownDetails details) =>
                print(details.globalPosition),
            child: Container(
              //child: Goal(),
              // child: CustomPaint(
              //   painter: GoalPainter(),
              //   child: SizedBox(
              //     width: 100,
              //     height: 100,
              //   ),
              // ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/background.png"),
                  fit: BoxFit.cover,
                ),
                // content here */,
              ),
              child: SizedBox(
                height: 1000,
                width: 1000,
              ),
            ),
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
