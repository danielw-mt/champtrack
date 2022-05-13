import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class MainScreenController extends GetxController {
  final selectedPlayer = "".obs;

  var playerNameControllers = [].obs;

  // void editName(int playerIndex, String newName){
  //   playerNames[playerIndex] = newName;
  // }

  void performAction(String actionButtonText) {
    print("test");
  }
}
