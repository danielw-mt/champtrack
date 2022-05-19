import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class GlobalController extends GetxController {
  // settingsscreen
  var selectedPlayer = "".obs;
  var availablePlayers = [].obs;
  var chosenPlayers = [].obs;
  // boolean list of chosen players i.e. true, true, false would mean the first two players start
  RxList<dynamic> startingPlayers = [].obs;

  bool getStartingPlayerValue(int index) {
    startingPlayers.refresh();
    return startingPlayers[index];
  }
}
