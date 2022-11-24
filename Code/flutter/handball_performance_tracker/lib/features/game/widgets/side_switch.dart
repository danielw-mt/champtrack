import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/core/constants/colors.dart';
import 'package:handball_performance_tracker/core/constants/stringsGameScreen.dart';
// import 'package:handball_performance_tracker/old-screens/main_screen.dart';
import 'package:handball_performance_tracker/features/game/game.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SideSwitch extends StatelessWidget {
  const SideSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameBloc = context.watch<GameBloc>();
    return TextButton(
        style: TextButton.styleFrom(
          backgroundColor: buttonLightBlueColor,
          primary: Colors.black,
        ),
        onPressed: () {
          gameBloc.add(SwitchSides());
          
          // TODO this seems to be a hack to get the field to update. Make sure this gets updated automatically
          // Reload Mainscreen so field colors are adapted
          //Get.to(MainScreen(), preventDuplicates: false);
        },
        child: Row(
          children: [
            Icon(Icons.autorenew_rounded),
            Text(StringsGameScreen.lSwitch)
          ],
        ));
  }
}
