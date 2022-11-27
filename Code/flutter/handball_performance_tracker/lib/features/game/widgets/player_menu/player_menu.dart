import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/core/constants/strings_general.dart';
import 'package:handball_performance_tracker/core/constants/strings_game_screen.dart';
import 'package:handball_performance_tracker/data/models/player_model.dart';
import 'package:handball_performance_tracker/core/constants/design_constants.dart';
import 'package:handball_performance_tracker/features/game/game.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'player_grid.dart';

/// A dialog for a player menu that gets opened after an action was selected in the action menu
/// On the first page there are the current active onFieldPlayer. On the second page of the dialog there are all the player not currently active on the field.
void callPlayerMenu(BuildContext context) {
  final GameBloc gameBloc = context.read<GameBloc>();
  PageController pageController = PageController();
  bool notOnFieldMenuOpen = false;

  // builds the grid with the players on field and the one with players not on field
  List<PlayersGrid> buildPages() {
    List<PlayersGrid> pages = [];
    pages.add(PlayersGrid(
      players: gameBloc.state.onFieldPlayers,
      isSubstitution: false,
    ));
    // if we have more players in the team than the ones that are on the field we need to add a page
    if (gameBloc.state.selectedTeam.players.length > gameBloc.state.onFieldPlayers.length) {
      List<Player> playersNotOnField = [];
      for (Player player in gameBloc.state.selectedTeam.players) {
        if (!gameBloc.state.onFieldPlayers.contains(player)) {
          playersNotOnField.add(player);
        }
      }
      pages.add(PlayersGrid(
        players: playersNotOnField,
        isSubstitution: true,
      ));
    }
    return pages;
  }

  showDialog(
          context: context,
          builder: (BuildContext bcontext) {
            return BlocProvider.value(
              value: gameBloc,
              child: AlertDialog(
                scrollable: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(MENU_RADIUS),
                ),
                // alert contains a list of DialogButton objects
                content:
                    // Column of "Player", horizontal line and Button-Row
                    Column(
                  children: [
                    // upper row: "Player" Text on left and "Assist" will pop up on right after a goal.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            StringsGeneral.lPlayer,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          // Change from "" to "Assist" after a goal.
                          child: Text(
                            notOnFieldMenuOpen ? StringsGameScreen.lSubstitute : gameBloc.state.playerMenuHintText,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              color: Colors.purple,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // horizontal line
                    const Divider(
                      thickness: 2,
                      color: Colors.black,
                      height: 6,
                    ),

                    // Button-Row: one Row with four Columns of one or two buttons
                    Scrollbar(
                      controller: pageController,
                      thumbVisibility: true,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.65,
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: Expanded(
                          child: PageView(
                            onPageChanged: (value) {
                              if (value == 1) {
                                notOnFieldMenuOpen = true;
                              } else {
                                notOnFieldMenuOpen = false;
                              }
                            },
                            controller: pageController,
                            children: buildPages(),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          })
      // When closing set player menu text to ""
      // if just pressed anywhere in screen)
      .then((_) {
    gameBloc.add(ChangeMenuStatus(menuStatus: MenuStatus.closed));
  });
}