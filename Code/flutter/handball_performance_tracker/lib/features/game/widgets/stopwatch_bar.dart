import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/core/core.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:handball_performance_tracker/features/game/game.dart';

class StopWatchBar extends StatelessWidget {
  // stop watch widget that allows to the time to be started, stopped, resetted and in-/decremented by 1 second
  @override
  Widget build(BuildContext context) {
    final GameBloc gameBloc = context.watch<GameBloc>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(color: buttonGreyColor, borderRadius: BorderRadius.all(Radius.circular(MENU_RADIUS))),
          height: BUTTON_HEIGHT * 0.8,
          width: BUTTON_HEIGHT * 0.8,
          alignment: Alignment.center,
          margin: const EdgeInsets.only(bottom: 10, top: 4),
          child: TextButton(
              onPressed: () => {gameBloc.add(ChangeTime(offset: -1000))},
              child: const Icon(
                Icons.remove,
                color: Colors.black,
              )),
        ),

        // Display stop watch time
        TimePopoupButton(),
        Container(
          decoration: BoxDecoration(color: buttonGreyColor, borderRadius: BorderRadius.all(Radius.circular(MENU_RADIUS))),
          height: BUTTON_HEIGHT * 0.8,
          width: BUTTON_HEIGHT * 0.8,
          alignment: Alignment.center,
          margin: const EdgeInsets.only(bottom: 10, top: 4),
          child: TextButton(
              onPressed: () => {gameBloc.add(ChangeTime(offset: 1000))},
              child: Icon(
                Icons.add,
                color: Colors.black,
              )),
        ),
      ],
    );
  }
}

class StartStopIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GameBloc gameBloc = context.watch<GameBloc>();
    bool gameRunning = gameBloc.state.status == GameStatus.running;
    return GestureDetector(
      onTap: () {
        if (gameRunning) {
          gameBloc.add(PauseGame());
        } else {
          gameBloc.add(UnPauseGame());
        }
      },
      child: gameRunning ? Icon(Icons.pause, size: 40, color: buttonDarkBlueColor) : Icon(Icons.play_arrow, size: 40, color: buttonDarkBlueColor),
    );
  }
}

// Button which displays the time and opens a popup on pressing to adapt the time
class TimePopoupButton extends StatelessWidget {
  const TimePopoupButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GameBloc gameBloc = context.watch<GameBloc>();
    StopWatchTimer stopWatchTimer = gameBloc.state.stopWatchTimer;
    return Container(
        decoration: BoxDecoration(color: buttonGreyColor, borderRadius: BorderRadius.all(Radius.circular(MENU_RADIUS))),
        padding: const EdgeInsets.only(right: 4),
        margin: const EdgeInsets.only(top: 4, left: 4, right: 4, bottom: 10),
        height: BUTTON_HEIGHT * 0.8,
        child: StreamBuilder<int>(
            stream: stopWatchTimer.rawTime,
            initialData: stopWatchTimer.rawTime.value,
            builder: (context, snap) {
              final value = snap.data!;
              String displayTime = StopWatchTimer.getDisplayTime(value, hours: false, minute: true, second: true, milliSecond: false);
              return TextButton(
                onPressed: () => callStopWatchPopup(context),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(padding: const EdgeInsets.only(bottom: 1), child: StartStopIcon()),
                    Text(
                      snap.hasData ? displayTime : "",
                      style: const TextStyle(fontSize: 25, color: Colors.black),
                    ),
                  ],
                ),
              );
            }));
  }

  /// calls popup to adapt time manually
  void callStopWatchPopup(BuildContext context) {
    double buttonHeight = MediaQuery.of(context).size.height * 0.08;
    final GameBloc gameBloc = context.read<GameBloc>();
    StopWatchTimer stopWatchTimer = gameBloc.state.stopWatchTimer;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // inject the BLOC into this alert again
          return BlocProvider.value(
            value: gameBloc,
            child: AlertDialog(
              scrollable: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(MENU_RADIUS),
              ),
              content:
                  // Column of "Edit score", horizontal line and score
                  Column(
                children: [
                  // upper row: Text "Edit time"
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      StringsGeneral.lEditTime,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  // horizontal line
                  const Divider(
                    thickness: 2,
                    color: Colors.black,
                    height: 6,
                  ),
                  Text(""),

                  Row(
                    children: [
                      SetTimeButtons(),
                      StartStopIcon(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(children: [
                            // Plus button for minutes
                            SizedBox(
                              height: buttonHeight,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: buttonLightBlueColor,
                                ),
                                onPressed: () => {gameBloc.add(ChangeTime(offset: 1000 * 60))},
                                child: Icon(Icons.add, size: 17, color: Colors.black),
                              ),
                            ),
                            Text(
                              "   ",
                            ),
                            // Plus button of seconds
                            SizedBox(
                              height: buttonHeight,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: buttonLightBlueColor,
                                ),
                                onPressed: () => {gameBloc.add(ChangeTime(offset: 1000))},
                                child: Icon(Icons.add, size: 17, color: Colors.black),
                              ),
                            ),
                          ]),
                          Row(children: [
                            // Container with Minutes
                            StreamBuilder<int>(
                                stream: stopWatchTimer.rawTime,
                                initialData: stopWatchTimer.rawTime.value,
                                builder: (context, snap) {
                                  final value = snap.data!;
                                  String displayTime =
                                      StopWatchTimer.getDisplayTime(value, hours: false, minute: true, second: false, milliSecond: false);
                                  return Container(
                                      height: buttonHeight * 1.3,
                                      width: buttonHeight,
                                      margin: EdgeInsets.only(left: 5, right: 5),
                                      padding: const EdgeInsets.all(10.0),
                                      alignment: Alignment.center,
                                      color: Colors.white,
                                      child: TextField(
                                        onChanged: (text) => {gameBloc.add(SetMinutes(minutes: int.parse(text)))},
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: snap.hasData ? (displayTime) : "",
                                        ),
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                                      ));
                                }),
                            // : between mins and secs
                            Text(
                              ":",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                            ),

                            // Container with Seconds
                            StreamBuilder<int>(
                                stream: stopWatchTimer.rawTime,
                                initialData: stopWatchTimer.rawTime.value,
                                builder: (context, snap) {
                                  final value = snap.data!;
                                  String displayTime =
                                      StopWatchTimer.getDisplayTime(value, hours: false, minute: false, second: true, milliSecond: false);
                                  return Container(
                                      height: buttonHeight * 1.3,
                                      width: buttonHeight,
                                      margin: EdgeInsets.only(left: 5, right: 5),
                                      padding: const EdgeInsets.all(10.0),
                                      alignment: Alignment.center,
                                      color: Colors.white,
                                      child: TextField(
                                        onChanged: (text) => {gameBloc.add(SetSeconds(seconds: int.parse(text)))},
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: snap.hasData ? (displayTime) : "",
                                        ),
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                                      ));
                                }),
                          ]),
                          Row(children: [
                            // Minus buttons of Minutes
                            SizedBox(
                              height: buttonHeight,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: buttonLightBlueColor,
                                ),
                                onPressed: () => {gameBloc.add(ChangeTime(offset: -1000 * 60))},
                                child: Icon(Icons.remove, size: 17, color: Colors.black),
                              ),
                            ),
                            Text(
                              "   ",
                            ),
                            // minus button of seconds
                            SizedBox(
                              height: buttonHeight,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: buttonLightBlueColor,
                                ),
                                onPressed: () => {gameBloc.add(ChangeTime(offset: -1000))},
                                child: Icon(Icons.remove, size: 17, color: Colors.black),
                              ),
                            )
                          ]),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class SetTimeButtons extends StatelessWidget {
  const SetTimeButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GameBloc gameBloc = context.watch<GameBloc>();
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(20),
          height: BUTTON_HEIGHT * 0.8,
          width: BUTTON_HEIGHT * 1.6,
          child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: buttonGreyColor,
                primary: Colors.black,
              ),
              onPressed: () {
                gameBloc.add(SetSeconds(seconds: 0));
                gameBloc.add(SetMinutes(minutes: 0));
              },
              child: Text(
                "00:00",
                style: TextStyle(
                  fontSize: 23,
                ),
              )),
        ),
        Container(
            margin: EdgeInsets.all(20),
            height: BUTTON_HEIGHT * 0.8,
            width: BUTTON_HEIGHT * 1.6,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: buttonGreyColor,
                primary: Colors.black,
              ),
              onPressed: () {
                gameBloc.add(SetSeconds(seconds: 0));
                gameBloc.add(SetMinutes(minutes: 30));
              },
              child: Text("30:00",
                  style: TextStyle(
                    fontSize: 23,
                  )),
            ))
      ],
    );
  }
}
