import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/controllers/mainScreenController.dart';

class mainScreen extends StatefulWidget {
  //const ({Key? key}) : super(key: key);

  @override
  State<mainScreen> createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> {
  List<String> playerNames = [];
  List<TextEditingController> playerNameControllers = [];
  String selectedPlayer = "";

  @override
  Widget build(BuildContext context) {
    final mainScreenController = Get.put(MainScreenController());

    for (int i = 0; i < 7; i++) {
      playerNameControllers.add(TextEditingController());
    }
    return Scaffold(
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
                  return TextField(
                    onTap: () {
                      mainScreenController.selectedPlayer.value =
                          playerNameControllers[index].value.text;
                    },
                    controller: playerNameControllers[index],
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
  Button({required this.text, Key? key}) : super(key: key);

  final text;
  final mainScreenController = Get.find<MainScreenController>();

  //Button(String text){this.text = text;}

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => TextButton(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(fontSize: 20),
        ),
        onPressed: () {
          // //print("Player " +
          //     mainScreenController.selectedPlayer.value +
          // " performed action " +
          // text);
          mainScreenController.performAction("");
        },
        child: Text(
          text,
          softWrap: false,
        ),
      ),
    );
  }
}
