import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/core/core.dart';
import 'package:handball_performance_tracker/features/game/game.dart';
import 'package:handball_performance_tracker/features/sidebar/sidebar.dart';

// TODO this is shit get rid of it
import 'package:handball_performance_tracker/core/constants/field_size_parameters.dart' as fieldSizeParameter;

class GameView extends StatelessWidget {
  GameView({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final GameBloc gameBloc = context.watch<GameBloc>();
    // postframecalback is used to execute this code after the build finished. That way the AlertDialogs from the menus don't interrupt the build
    // see: https://stackoverflow.com/questions/47592301/setstate-or-markneedsbuild-called-during-build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (gameBloc.state.menuStatus == MenuStatus.forceClose) {
        Navigator.pop(context);
      }
      // close action menu first and then open player menu to make sure that navigation stack stays clean instead of having a player menu on top of an action menu
      if (gameBloc.state.menuStatus == MenuStatus.loadPlayerMenu) {
        print("loading player menu");
        Navigator.pop(context);
        
        callPlayerMenu(context);
        gameBloc.add(ChangeMenuStatus(menuStatus: MenuStatus.playerMenu));
      }
      if (gameBloc.state.menuStatus == MenuStatus.loadSubstitutionMenu) {
        callSubstitutionPlayerMenu(context);
        gameBloc.add(ChangeMenuStatus(menuStatus: MenuStatus.actionMenu));
      }
      if (gameBloc.state.menuStatus == MenuStatus.actionMenu) {
        callActionMenu(context);
      }
      if (gameBloc.state.menuStatus == MenuStatus.playerMenu) {
        callPlayerMenu(context);
      }
      if (gameBloc.state.menuStatus == MenuStatus.sevenMeterMenu) {
        // TODO implement seven meter menu
        // callSevenMeterMenu(context);
      }
    });

    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      drawer: SidebarView(),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // TODO try to arrange menu button here for the drawer
                        // MenuButton(_scaffoldKey),
                        ScoreKeeping(),
                      ],
                    ),
                    StopWatchBar(),
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      ActionFeed(),
                      Row(
                        children: [
                          StopGameButton(),
                          SideSwitch(),
                        ],
                      ),
                      //FloatingActionButton(onPressed: () => null,)
                    ],
                  ),
                  // Player Bar
                  Container(
                      width: SCOREBAR_WIDTH + PADDING_WIDTH * 4,
                      height: fieldSizeParameter.fieldHeight + fieldSizeParameter.toolbarHeight / 4,
                      alignment: Alignment.topCenter,
                      child: Container()), //EfScoreBar()),
                  // Field
                  Flexible(
                    flex: 4,
                    child: Column(
                      children: [
                        Container(
                          width: fieldSizeParameter.fieldWidth + fieldSizeParameter.toolbarHeight / 4,
                          height: fieldSizeParameter.fieldHeight + fieldSizeParameter.toolbarHeight / 4,
                          alignment: Alignment.topCenter,
                          child: Container(
                            decoration: BoxDecoration(
                                // set border around field
                                border: Border.all(width: fieldSizeParameter.lineSize)),
                            child: SizedBox(
                              // FieldSwitch to swipe between right and left field side. SizedBox around it so there is no rendering error.
                              width: fieldSizeParameter.fieldWidth,
                              height: fieldSizeParameter.fieldHeight,
                              // Use a LayoutBuilder to get the real size of SizedBox.
                              // As it is inside Flexible Widget, the size can vary depending on screen size.
                              child: new LayoutBuilder(
                                builder: (BuildContext context, BoxConstraints constraints) {
                                  // set Field size depending on Widget size
                                  fieldSizeParameter.setFieldSize(constraints.maxWidth, constraints.maxHeight);
                                  return GameField();
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
