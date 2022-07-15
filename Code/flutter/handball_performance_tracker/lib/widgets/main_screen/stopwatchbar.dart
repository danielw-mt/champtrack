import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/constants/colors.dart';
import 'package:handball_performance_tracker/constants/stringsGeneral.dart';
import 'package:handball_performance_tracker/widgets/main_screen/ef_score_bar.dart';
import '../../controllers/persistentController.dart';
import '../../controllers/tempController.dart';
import 'package:get/get.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import '../../utils/gameControl.dart';

class StopWatchBar extends StatelessWidget {
  // stop watch widget that allows to the time to be started, stopped, resetted and in-/decremented by 1 sec

  @override
  Widget build(BuildContext context) {
    TempController tempController = Get.find<TempController>();

    return GetBuilder<PersistentController>(
      id: "stopwatch-bar",
      builder: (PersistentController persistentController) {
        StopWatchTimer stopWatchTimer =
            persistentController.getCurrentGame().stopWatch;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: buttonGreyColor,
                  borderRadius: BorderRadius.all(Radius.circular(menuRadius))),
              height: buttonHeight * 0.8,
              width: buttonHeight * 0.8,
              alignment: Alignment.center,
              margin: const EdgeInsets.only(bottom: 10, top: 4),
              child: TextButton(
                  onPressed: () => changeTime(context, 1000),
                  child: Icon(
                    Icons.add,
                    color: Colors.black,
                  )),
            ),

            // Display stop watch time
            TimePopoupButton(),
            Container(
              decoration: BoxDecoration(
                  color: buttonGreyColor,
                  borderRadius: BorderRadius.all(Radius.circular(menuRadius))),
              height: buttonHeight * 0.8,
              width: buttonHeight * 0.8,
              alignment: Alignment.center,
              margin: const EdgeInsets.only(bottom: 10, top: 4),
              child: TextButton(
                  onPressed: () => changeTime(context, -1000),
                  child: const Icon(
                    Icons.remove,
                    color: Colors.black,
                  )),
            ),
            // reset button
            Container(
              decoration: BoxDecoration(
                  color: buttonGreyColor,
                  borderRadius: BorderRadius.all(Radius.circular(menuRadius))),
              height: buttonHeight * 0.8,
              width: buttonHeight * 0.8,
              alignment: Alignment.center,
              margin: const EdgeInsets.only(bottom: 10, top: 4, left: 20),
              child: TextButton(
                  onPressed: () async {
                    stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                    tempController.setGameIsRunning(false);
                    stopWatchTimer.onExecute.add(StopWatchExecute.reset);
                    stopWatchTimer.clearPresetTime();
                    stopWatchTimer.setPresetTime(mSec: 0);
                  },
                  child: Icon(
                    Icons.history,
                    color: Colors.black,
                  )),
            ),
          ],
        );
      },
    );
  }
}

class StartStopIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TempController>(
        id: "start-stop-icon",
        builder: (TempController tempController) {
          bool gameRunning = tempController.getGameIsRunning();
          return GestureDetector(
            onTap: () {
              if (gameRunning) {
                pauseGame();
              } else {
                unpauseGame();
              }
            },
            child: gameRunning
                ? Icon(Icons.pause, size: 40, color: buttonDarkBlueColor)
                : Icon(Icons.play_arrow, size: 40, color: buttonDarkBlueColor),
          );
        });
  }
}

// Button which displays the time and opens a popup on pressing to adapt the time
class TimePopoupButton extends StatelessWidget {
  const TimePopoupButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PersistentController persistentController =
        Get.find<PersistentController>();
    StopWatchTimer stopWatchTimer =
        persistentController.getCurrentGame().stopWatch;
    return Container(
        decoration: BoxDecoration(
            color: buttonGreyColor,
            borderRadius: BorderRadius.all(Radius.circular(menuRadius))),
        padding: const EdgeInsets.only(right: 4),
        margin: const EdgeInsets.only(top: 4, left: 4, right: 4, bottom: 10),
        height: buttonHeight * 0.8,
        child: StreamBuilder<int>(
            stream: stopWatchTimer.rawTime,
            initialData: stopWatchTimer.rawTime.value,
            builder: (context, snap) {
              final value = snap.data!;
              String displayTime = StopWatchTimer.getDisplayTime(value,
                  hours: false, minute: true, second: true, milliSecond: false);
              return TextButton(
                onPressed: () => callStopWatch(context),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        padding: const EdgeInsets.only(bottom: 1),
                        child: StartStopIcon()),
                    Text(
                      snap.hasData ? displayTime : "",
                      style: const TextStyle(fontSize: 25, color: Colors.black),
                    ),
                  ],
                ),
              );
            }));
  }
}

// calls popup to adapt time manually
void callStopWatch(context) {
  double buttonHeight = MediaQuery.of(context).size.height * 0.1;
  PersistentController persistentController = Get.find<PersistentController>();
  StopWatchTimer stopWatchTimer =
      persistentController.getCurrentGame().stopWatch;
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(menuRadius),
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

              IntrinsicHeight(
                child: Row(
                  children: [
                    SetTimeButtons(),
                    StartStopIcon(),
                    Column(
                      children: [
                        // Plus button for minutes
                        SizedBox(
                          height: buttonHeight,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: buttonLightBlueColor,
                            ),
                            onPressed: () => changeTime(context, 1000 * 60),
                            child:
                                Icon(Icons.add, size: 15, color: Colors.black),
                          ),
                        ),
                        // Container with Minutes
                        StreamBuilder<int>(
                            stream: stopWatchTimer.rawTime,
                            initialData: stopWatchTimer.rawTime.value,
                            builder: (context, snap) {
                              final value = snap.data!;
                              String displayTime =
                                  StopWatchTimer.getDisplayTime(value,
                                      hours: false,
                                      minute: true,
                                      second: false,
                                      milliSecond: false);
                              return Container(
                                  height: buttonHeight * 1.3,
                                  width: buttonHeight,
                                  margin: EdgeInsets.only(left: 5, right: 5),
                                  padding: const EdgeInsets.all(10.0),
                                  alignment: Alignment.center,
                                  color: Colors.white,
                                  child: TextField(
                                    onChanged: (text) =>
                                        setMinutes(context, int.parse(text)),
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText:
                                          snap.hasData ? (displayTime) : "",
                                    ),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 28),
                                  ));
                            }),

                        // Minus buttons of Minutes
                        SizedBox(
                          height: buttonHeight,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: buttonLightBlueColor,
                            ),
                            onPressed: () => changeTime(context, -1000 * 60),
                            child: Icon(Icons.remove,
                                size: 15, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    // : between mins and secs
                    Container(
                      height: buttonHeight * 0.9,
                      child: Text(
                        ":",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 28),
                      ),
                    ),
                    Column(children: [
                      // Plus button of seconds
                      SizedBox(
                        height: buttonHeight,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: buttonLightBlueColor,
                          ),
                          onPressed: () => changeTime(context, 1000),
                          child: Icon(Icons.add, size: 15, color: Colors.black),
                        ),
                      ),
                      // Container with Seconds
                      StreamBuilder<int>(
                          stream: stopWatchTimer.rawTime,
                          initialData: stopWatchTimer.rawTime.value,
                          builder: (context, snap) {
                            final value = snap.data!;
                            String displayTime = StopWatchTimer.getDisplayTime(
                                value,
                                hours: false,
                                minute: false,
                                second: true,
                                milliSecond: false);
                            return Container(
                                height: buttonHeight * 1.3,
                                width: buttonHeight,
                                margin: EdgeInsets.only(left: 5, right: 5),
                                padding: const EdgeInsets.all(10.0),
                                alignment: Alignment.center,
                                color: Colors.white,
                                child: TextField(
                                  onChanged: (text) =>
                                      setSeconds(context, int.parse(text)),
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: snap.hasData ? (displayTime) : "",
                                  ),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28),
                                ));
                          }),
                      // minus button of seconds
                      SizedBox(
                        height: buttonHeight,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: buttonLightBlueColor,
                          ),
                          onPressed: () => changeTime(context, -1000),
                          child:
                              Icon(Icons.remove, size: 15, color: Colors.black),
                        ),
                      )
                    ]),
                  ],
                ),
              ),
            ],
          ),
        );
      });
}

// Change time by the given offset
void changeTime(context, int offset) async {
  PersistentController persistentController = Get.find<PersistentController>();
  StopWatchTimer stopWatchTimer =
      persistentController.getCurrentGame().stopWatch;
  int currentTime = stopWatchTimer.rawTime.value;
  // make sure the timer can't go negative
  if (currentTime < -offset && offset < 0) return;
  stopWatchTimer.clearPresetTime();
  if (stopWatchTimer.isRunning) {
    stopWatchTimer.onExecute.add(StopWatchExecute.reset);
    persistentController
        .getCurrentGame()
        .stopWatch
        .setPresetTime(mSec: currentTime + offset);
    stopWatchTimer.onExecute.add(StopWatchExecute.start);
  } else {
    stopWatchTimer.onExecute.add(StopWatchExecute.reset);
    persistentController
        .getCurrentGame()
        .stopWatch
        .setPresetTime(mSec: currentTime + offset);
  }
}

// set minutes to given value
void setMinutes(context, int minutes) async {
  PersistentController persistentController = Get.find<PersistentController>();
  StopWatchTimer stopWatchTimer =
      persistentController.getCurrentGame().stopWatch;
  // get current seconds
  int currentSecs = getCurrentSecs(context);
  // make sure the timer can't go negative
  if (minutes < 0) return;
  stopWatchTimer.clearPresetTime();
  if (stopWatchTimer.isRunning) {
    stopWatchTimer.onExecute.add(StopWatchExecute.reset);
    stopWatchTimer.setPresetSecondTime(minutes * 60 + currentSecs);
    stopWatchTimer.onExecute.add(StopWatchExecute.start);
  } else {
    stopWatchTimer.onExecute.add(StopWatchExecute.reset);
    stopWatchTimer.setPresetSecondTime(minutes * 60 + currentSecs);
  }
}

// set seconds to given value
void setSeconds(context, int secs) async {
  PersistentController persistentController = Get.find<PersistentController>();
  StopWatchTimer stopWatchTimer =
      persistentController.getCurrentGame().stopWatch;
  // get current minutes
  int currentMins = getCurrentMins(context);
  // make sure the timer can't go negative
  if (secs < 0) return;
  stopWatchTimer.clearPresetTime();
  if (stopWatchTimer.isRunning) {
    stopWatchTimer.onExecute.add(StopWatchExecute.reset);
    stopWatchTimer.setPresetSecondTime(currentMins * 60 + secs);
    stopWatchTimer.onExecute.add(StopWatchExecute.start);
  } else {
    stopWatchTimer.onExecute.add(StopWatchExecute.reset);
    stopWatchTimer.setPresetSecondTime(currentMins * 60 + secs);
  }
}

int getCurrentMins(context) {
  PersistentController persistentController = Get.find<PersistentController>();
  StopWatchTimer stopWatchTimer =
      persistentController.getCurrentGame().stopWatch;
  int currentTime = stopWatchTimer.rawTime.value;
  return (currentTime / 60000).floor();
}

int getCurrentSecs(context) {
  PersistentController persistentController = Get.find<PersistentController>();
  StopWatchTimer stopWatchTimer =
      persistentController.getCurrentGame().stopWatch;
  int currentTime = stopWatchTimer.rawTime.value;
  return (currentTime % 60000 / 1000).floor();
}

class SetTimeButtons extends StatelessWidget {
  const SetTimeButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PersistentController persistentController =
        Get.find<PersistentController>();
    StopWatchTimer stopWatchTimer =
        persistentController.getCurrentGame().stopWatch;
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(20),
          height: buttonHeight,
          width: buttonHeight * 1.5,
          child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: buttonGreyColor,
                primary: Colors.black,
              ),
              onPressed: () {
                stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                pauseGame();
                stopWatchTimer.onExecute.add(StopWatchExecute.reset);
                stopWatchTimer.clearPresetTime();
                stopWatchTimer.setPresetTime(mSec: 0);
              },
              child: Text(
                "00:00",
                style: TextStyle(
                  fontSize: 25,
                ),
              )),
        ),
        Container(
            margin: EdgeInsets.all(20),
            height: buttonHeight,
            width: buttonHeight * 1.5,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: buttonGreyColor,
                primary: Colors.black,
              ),
              onPressed: () {
                stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                pauseGame();
                stopWatchTimer.onExecute.add(StopWatchExecute.reset);
                stopWatchTimer.clearPresetTime();
                stopWatchTimer.setPresetTime(mSec: 30 * 60000);
              },
              child: Text("30:00",
                  style: TextStyle(
                    fontSize: 25,
                  )),
            ))
      ],
    );
  }
}
