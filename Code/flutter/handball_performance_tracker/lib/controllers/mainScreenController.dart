import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class MainScreenController extends GetxController {
  // final count = 0.obs;
  // increment() => count.value++;

  List playerNameTextControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];

  MainScreenController(){
    playerNameTextControllers.obs;
  }
}