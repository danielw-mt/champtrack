import 'package:flutter/material.dart';
// import 'package:get/get.dart';

class mainScreen extends StatefulWidget {
  @override
  State<mainScreen> createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> {
  List<String> playerNames = [];
  List<TextEditingController> playerNameControllers = [];
  String selectedPlayer = "";

  @override
  Widget build(BuildContext context) {
    for (int i = 1; i < 7; i++) {
      playerNameControllers.add(TextEditingController());
    }
    return Scaffold(
      appBar: AppBar(title: Text("Title")),
      body: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: 7,
          itemBuilder: (BuildContext context, int index) {
            return TextField(
              onTap: () {
                selectedPlayer = playerNameControllers[index].value.text;
                print("sel player: " + selectedPlayer);
              },
              controller: playerNameControllers[index],
            );
          }),
    );
  }
}
