import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;

class GlobalController extends GetxController {
  // settingsscreen
  var selectedPlayer = "".obs;
  var availablePlayers = [].obs;

  var fieldWith = ui.window.physicalSize.width;
  var fieldHeight = ui.window.physicalSize.height * 0.8;

  var sixMeterRadiusFactorX = 3;
  var sixMeterRadiusFactorY = 3;
  var nineMeterRadiusFactorX = 2;
  var nineMeterRadiusFactorY = 2;
  var sector1Gradient = 1.0;
  var sector1Y = 0.0;

  void selectPlayer(String) {}
}
