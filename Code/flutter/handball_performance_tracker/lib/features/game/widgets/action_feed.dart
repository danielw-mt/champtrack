import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/core/constants/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/features/game/game.dart';
import 'package:handball_performance_tracker/core/constants/strings_game_screen.dart';
import 'package:handball_performance_tracker/core/constants/strings_general.dart';
import 'package:handball_performance_tracker/core/constants/field_size_parameters.dart' as fieldSizeParameter;
import 'package:handball_performance_tracker/data/models/models.dart';
import 'package:handball_performance_tracker/core/constants/design_constants.dart';

/// A widget that displays the newest actions. It can be tweaked in lib/const/settings_config
/// GameActions are periodically removed and can also be removed by clicking on them
class ActionFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameBloc = context.watch<GameBloc>();
    List<GameAction> feedGameActions = gameBloc.state.gameActions;
    return Container(
      margin: EdgeInsets.only(left: 10),
      padding: EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(MENU_RADIUS), bottomRight: Radius.circular(MENU_RADIUS))),
      alignment: Alignment.centerLeft,
      width: MediaQuery.of(context).size.width * 0.23,
      height: fieldSizeParameter.fieldHeight * 0.95,
      child: Column(
        children: [
          FeedHeader(),
          Expanded(
            child: ListView.builder(
                controller: ScrollController(),
                physics: ClampingScrollPhysics(),
                reverse: true,
                shrinkWrap: true,
                itemCount: feedGameActions.where((GameAction action) => action.playerId != "").toList().length,
                itemBuilder: (context, index) {
                  GameAction feedAction = feedGameActions.where((GameAction action) => action.playerId != "").toList()[index];
                  String actionTag = feedAction.tag;
                  Player relevantPlayer = Player();
                  // get the player object whose id matches the playerId in the action Object
                  if (feedAction.playerId != "opponent") {
                    relevantPlayer = gameBloc.state.selectedTeam.players.firstWhere((player) => player.id == feedAction.playerId);
                  } else {
                    relevantPlayer = Player(lastName: StringsGameScreen.lOpponent, id: "opponent");
                  }
                  if (relevantPlayer != Player) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 5),
                              width: BUTTON_HEIGHT * 0.8,
                              height: BUTTON_HEIGHT * 0.8,
                              decoration: BoxDecoration(color: buttonGreyColor, borderRadius: BorderRadius.all(Radius.circular(MENU_RADIUS))),
                              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                Flexible(
                                  child: Text(
                                    actionTag,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  relevantPlayer == Player() ? StringsGameScreen.lUnknown : relevantPlayer.lastName,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () async {
                                  gameBloc.add(DeleteGameAction(action: feedAction));
                                },
                                child: Icon(
                                  Icons.delete,
                                  size: 30,
                                ),
                              ),
                            )
                          ],
                        ),
                        if (index != feedGameActions.length) Divider()
                      ],
                    );
                  }
                  return Container();
                }),
          ),
        ],
      ),
    );
  }
}

class FeedHeader extends StatelessWidget {
  const FeedHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: buttonDarkBlueColor,
          // set border so corners can be made round
          border: Border.all(
            color: buttonDarkBlueColor,
          ),
          // make round edges
          borderRadius: BorderRadius.only(topLeft: Radius.circular(MENU_RADIUS), topRight: Radius.circular(MENU_RADIUS))),
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 5),
      child: Text(StringsGeneral.lFeedHeader, style: TextStyle(color: Colors.white)),
    );
  }
}
