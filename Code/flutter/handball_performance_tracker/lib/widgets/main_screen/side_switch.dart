import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/constants/colors.dart';
import 'package:handball_performance_tracker/controllers/tempController.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/screens/mainScreen.dart';

class SideSwitch extends StatelessWidget {
  const SideSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TempController tempController = Get.find<TempController>();

    return TextButton(
        style: TextButton.styleFrom(
          backgroundColor: buttonLightBlueColor,
          primary: Colors.black,
        ),
        onPressed: () {
          tempController.setAttackIsLeft(!tempController.getAttackIsLeft());
          // Reload Mainscreen so field colors are adapted
          Get.to(MainScreen(), preventDuplicates: false);
        },
        child: Row(
          children: [Icon(Icons.autorenew_rounded), Text("Switch")],
        ));
  }
}
