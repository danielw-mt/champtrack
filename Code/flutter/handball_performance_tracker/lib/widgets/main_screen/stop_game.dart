import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/constants/colors.dart';
import 'package:handball_performance_tracker/constants/stringsGameSettings.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/screens/dashboard.dart';
import 'package:handball_performance_tracker/utils/gameControl.dart';

class StopGameButton extends StatelessWidget {
  const StopGameButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(
          backgroundColor: buttonLightBlueColor,
          primary: Colors.black,
        ),
        onPressed: () {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text(StringsGameSettings.lStopGameButton),
              actions: <Widget>[
                TextButton(
                  onPressed: () =>
                      Navigator.pop(context, StringsGameSettings.lCancelButton),
                  child: Text(
                    StringsGameSettings.lCancelButton,
                    style: TextStyle(
                      color: buttonDarkBlueColor,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    stopGame();
                    Get.to(Dashboard());
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(
                      color: buttonDarkBlueColor,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        child: Row(
          children: [Text(StringsGameSettings.lStopGameButton)],
        ));
  }
}
