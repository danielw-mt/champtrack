import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/constants/colors.dart';
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
                  onPressed: () async {
                    int currentTime = stopWatchTimer.rawTime.value;
                    stopWatchTimer.clearPresetTime();
                    if (stopWatchTimer.isRunning) {
                      stopWatchTimer.onExecute.add(StopWatchExecute.reset);
                      persistentController
                          .getCurrentGame()
                          .stopWatch
                          .setPresetTime(mSec: currentTime + 1000);
                      stopWatchTimer.onExecute.add(StopWatchExecute.start);
                    } else {
                      stopWatchTimer.onExecute.add(StopWatchExecute.reset);
                      persistentController
                          .getCurrentGame()
                          .stopWatch
                          .setPresetTime(mSec: currentTime + 1000);
                    }
                  },
                  child: Icon(
                    Icons.add,
                    color: Colors.black,
                  )),
            ),

            // Display stop watch time
            Container(
                decoration: BoxDecoration(
                    color: buttonGreyColor,
                    borderRadius:
                        BorderRadius.all(Radius.circular(menuRadius))),
                padding: const EdgeInsets.only(right: 4),
                margin: const EdgeInsets.only(
                    top: 4, left: 4, right: 4, bottom: 10),
                height: buttonHeight * 0.8,
                child: StreamBuilder<int>(
                    stream: stopWatchTimer.rawTime,
                    initialData: stopWatchTimer.rawTime.value,
                    builder: (context, snap) {
                      final value = snap.data!;
                      String displayTime = StopWatchTimer.getDisplayTime(value,
                          hours: false,
                          minute: true,
                          second: true,
                          milliSecond: false);
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                          Container(
                              padding: const EdgeInsets.only(bottom: 1),
                              child: StartStopIcon()),
                            Text(
                              snap.hasData ? displayTime : "",
                              style: const TextStyle(
                                fontSize: 25),
                            ),
                        ],
                      );
                    })),
            Container(
              decoration: BoxDecoration(
                  color: buttonGreyColor,
                  borderRadius: BorderRadius.all(Radius.circular(menuRadius))),
              height: buttonHeight * 0.8,
              width: buttonHeight * 0.8,
              alignment: Alignment.center,
              margin: const EdgeInsets.only(bottom: 10, top: 4),
              child: TextButton(
                  onPressed: () async {
                    int currentTime = stopWatchTimer.rawTime.value;
                    // make sure the timer can't go negative
                    if (currentTime <= 1000) return;
                    stopWatchTimer.clearPresetTime();
                    if (stopWatchTimer.isRunning) {
                      stopWatchTimer.onExecute.add(StopWatchExecute.reset);
                      persistentController
                          .getCurrentGame()
                          .stopWatch
                          .setPresetTime(mSec: currentTime - 1000);
                      stopWatchTimer.onExecute.add(StopWatchExecute.start);
                    } else {
                      stopWatchTimer.onExecute.add(StopWatchExecute.reset);
                      persistentController
                          .getCurrentGame()
                          .stopWatch
                          .setPresetTime(mSec: currentTime - 1000);
                    }
                  },
                  child: const Icon(
                    Icons.remove,
                    color: Colors.black,
                  )),
            ),

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
                ? Icon(
                    Icons.pause,
                    size: 40, color: buttonDarkBlueColor
                  )
                : Icon(
                    Icons.play_arrow,
                    size: 40, color: buttonDarkBlueColor
                  ),
          );
        });
  }
}
