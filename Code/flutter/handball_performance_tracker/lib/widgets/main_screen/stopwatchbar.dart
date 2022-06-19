import 'package:flutter/material.dart';
import '../../controllers/persistentController.dart';
import '../../controllers/tempController.dart';
import 'package:get/get.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import '../../utils/gameControl.dart';

class StopWatchBar extends GetView<TempController> {
  // stop watch widget that allows to the time to be started, stopped, resetted and in-/decremented by 1 sec

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PersistentController>(
      id: "stopwatch-bar",
      builder: (PersistentController persistentController) {
        StopWatchTimer stopWatchTimer =
            persistentController.getCurrentGame().stopWatch;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    onPrimary: Colors.white,
                    shape: const StadiumBorder(),
                  ),
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
                  child: Icon(Icons.add)),
            ),

            // Display stop watch time
            ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 50, minWidth: 100),
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
                      return Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            StartStopIcon(),
                            Text(
                              snap.hasData ? displayTime : "",
                              style: const TextStyle(
                                  fontSize: 40,
                                  fontFamily: 'Helvetica',
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    })),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    onPrimary: Colors.white,
                    shape: const StadiumBorder(),
                  ),
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
                  child: const Icon(Icons.remove)),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    onPrimary: Colors.white,
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () async {
                    stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                    stopWatchTimer.onExecute.add(StopWatchExecute.reset);
                    stopWatchTimer.clearPresetTime();
                    stopWatchTimer.setPresetTime(mSec: 0);
                  },
                  child: Icon(Icons.history)),
            ),
          ],
        );
      },
    );
  }
}

class StartStopIcon extends GetView<TempController> {
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
            child: gameRunning ? Icon(Icons.pause) : Icon(Icons.play_arrow),
          );
        });
  }
}
