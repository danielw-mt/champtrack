import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/old-utils/game_control.dart';
import 'package:handball_performance_tracker/core/constants/stringsGeneral.dart';
import 'package:handball_performance_tracker/core/constants/stringsGameSettings.dart';
import 'package:handball_performance_tracker/features/game_setup/game_setup.dart';
import 'package:handball_performance_tracker/core/constants/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Screen that is displayed after gamesettings and allows to select, add, and remove players before starting the game
class PlayerSelection extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int startGameFlowStep = 0;

  @override
  Widget build(BuildContext context) {
    final gameSetupState = context.watch<GameSetupCubit>().state;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Container for menu button on top left corner
        Center(child: SizedBox(height: MediaQuery.of(context).size.height * 0.6, child: PlayersList())),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: SizedBox(
                width: 0.15 * width,
                height: 0.08 * height,
                child: ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(buttonGreyColor)),
                    onPressed: () {
                      context.read<GameSetupCubit>().goToSettings();
                    },
                    child: Text(StringsGeneral.lBack, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black))),
              ),
            ),
            Flexible(
              child: SizedBox(
                width: 0.15 * width,
                height: 0.08 * height,
                child: ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(buttonLightBlueColor)),
                  onPressed: () async {
                    // validate whether 7 players were selected in the playerslist
                    // display alert if less than 7 have been selected
                    // if (tempController.getOnFieldPlayers().length != 7) {
                    //   showDialog(
                    //       context: context,
                    //       builder: (BuildContext bcontext) {
                    //         return AlertDialog(
                    //             scrollable: true,
                    //             shape: RoundedRectangleBorder(
                    //               borderRadius: BorderRadius.circular(menuRadius),
                    //             ),
                    //             content: CustomAlertMessageWidget(
                    //                 StringsGameSettings.lStartGameAlertHeader + "!\n" + StringsGameSettings.lStartGameAlert));
                    //       });
                    // } else {
                    //   tempController.updateOnFieldPlayers();
                    //   tempController.setPlayerBarPlayersOrder();
                    //   startGame(context, preconfigured: true);
                    //   Get.to(() => MainScreen());
                    //   return;
                    // }
                  },
                  child: Text(StringsGeneral.lStartGameButton, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  
}
