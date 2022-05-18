import 'package:flutter/material.dart';
import './../../controllers/globalController.dart';
import 'package:get/get.dart';

class PlayerDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> playerNames = [];
    String selectedPlayer = "";

    final GlobalController mainScreenController = Get.find<GlobalController>();

    return Obx(() => DropdownButton<String>(
          value: mainScreenController.selectedPlayer.toString(),
          icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String? newValue) {
            print(dropdownValue);
          },
          items: <String>['One', 'Two', 'Free', 'Four']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ));
  }
}
