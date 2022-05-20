import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './../../controllers/globalController.dart';
import './../widgets/helper_screen/stopwatch.dart';
import '../widgets/helper_screen/actionmenu.dart';
import './../widgets/helper_screen/playermenu.dart';

class HelperScreen extends GetView<GlobalController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('CountDown Sample'),
        ),
        body: Column(
          children: [
            StopWatch(),
            ActionMenu(),
            PlayerMenu(),
          ],
        ));
  }
}
