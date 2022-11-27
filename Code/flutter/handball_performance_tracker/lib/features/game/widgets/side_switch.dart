import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/core/core.dart';
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
        },
        child: Row(
          children: [
            Icon(Icons.autorenew_rounded),
            Text(StringsGameScreen.lSwitch)
          ],
        ));
  }
}
