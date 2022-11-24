import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/core/constants/design_constants.dart';
import 'package:handball_performance_tracker/core/core.dart';
import 'package:handball_performance_tracker/features/game/game.dart';
import 'package:handball_performance_tracker/features/sidebar/sidebar.dart';

// TODO this is shit get rid of it
import 'package:handball_performance_tracker/core/constants/fieldSizeParameter.dart' as fieldSizeParameter;

class GameView extends StatelessWidget {
  GameView({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
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
