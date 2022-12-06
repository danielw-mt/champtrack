import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/features/game/view/view.dart';
import 'package:handball_performance_tracker/features/game_setup/game_setup.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/core/core.dart';

/// Screen that is displayed after gamesettings and allows to select, add, and remove players before starting the game
class PlayerSelection extends StatelessWidget {
  int startGameFlowStep = 0;

  @override
  Widget build(BuildContext context) {
    final gameSetupState = context.watch<GameSetupCubit>().state;
    final globalState = context.watch<GlobalBloc>().state;
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
                    if (gameSetupState.onFieldPlayers.length != 7) {
                      showDialog(
                          context: context,
                          builder: (BuildContext bcontext) {
                            return AlertDialog(
                                scrollable: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(MENU_RADIUS),
                                ),
                                content: CustomAlertMessageWidget(
                                    StringsGameSettings.lStartGameAlertHeader + "!\n" + StringsGameSettings.lStartGameAlert));
                          });
                    } else {
                      // TODO update onFieldPlayers in DB from BLOC
                      // updates onFieldPlayers in the db
                      //tempController.updateOnFieldPlayers();
                      // TODO do we even need this?
                      // tempController.setPlayerBarPlayersOrder();
                      //startGame(context, preconfigured: true);
                      //Get.to(() => MainScreen());

                      // TODO use named routes

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GamePage(
                                    onFieldPlayers: gameSetupState.onFieldPlayers,
                                    selectedTeam: globalState.allTeams[gameSetupState.selectedTeamIndex],
                                    opponent: gameSetupState.opponent,
                                    location: gameSetupState.location,
                                    date: gameSetupState.date,
                                    isHomeGame: gameSetupState.isHomeGame,
                                    attackIsLeft: gameSetupState.attackIsLeft,
                                  )));
                      return;
                    }
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
