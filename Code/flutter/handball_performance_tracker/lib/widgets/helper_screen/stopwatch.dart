import 'package:flutter/material.dart';
import '../../controllers/appController.dart';
import 'package:get/get.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import '../../controllers/gameController.dart';

class StopWatch extends GetView<GameController> {
  // stop watch widget that allows to the time to be started, stopped, resetted and in-/decremented by 1 sec
  AppController appController = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    StopWatchTimer stopWatchTimer = appController.getCurrentGame().stopWatch;

    return Scrollbar(
        child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 32,
                  horizontal: 16,
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      /// Display stop watch time
                      StreamBuilder<int>(
                        stream: stopWatchTimer.rawTime,
                        initialData: stopWatchTimer.rawTime.value,
                        builder: (context, snap) {
                          final value = snap.data!;
                          final displayTime =
                              StopWatchTimer.getDisplayTime(value, hours: true);
                          return Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  displayTime,
                                  style: const TextStyle(
                                      fontSize: 40,
                                      fontFamily: 'Helvetica',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  value.toString(),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Helvetica',
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.lightBlue,
                                  onPrimary: Colors.white,
                                  shape: const StadiumBorder(),
                                ),
                                onPressed: () async {
                                  stopWatchTimer.onExecute
                                      .add(StopWatchExecute.start);
                                },
                                child: const Text(
                                  'Start',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.green,
                                  onPrimary: Colors.white,
                                  shape: const StadiumBorder(),
                                ),
                                onPressed: () async {
                                  appController
                                      .getCurrentGame()
                                      .stopWatch
                                      .onExecute
                                      .add(StopWatchExecute.stop);
                                },
                                child: const Text(
                                  'Stop',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red,
                                  onPrimary: Colors.white,
                                  shape: const StadiumBorder(),
                                ),
                                onPressed: () async {
                                  stopWatchTimer.onExecute
                                      .add(StopWatchExecute.stop);
                                  stopWatchTimer.onExecute
                                      .add(StopWatchExecute.reset);
                                  stopWatchTimer.clearPresetTime();
                                  stopWatchTimer.setPresetTime(mSec: 0);
                                },
                                child: const Text(
                                  'Reset',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red,
                                  onPrimary: Colors.white,
                                  shape: const StadiumBorder(),
                                ),
                                onPressed: () async {
                                  int currentTime =
                                      stopWatchTimer.rawTime.value;
                                  stopWatchTimer.clearPresetTime();
                                  if (stopWatchTimer.isRunning) {
                                    stopWatchTimer.onExecute
                                        .add(StopWatchExecute.reset);
                                    appController
                                        .getCurrentGame()
                                        .stopWatch
                                        .setPresetTime(
                                            mSec: currentTime + 1000);
                                    stopWatchTimer.onExecute
                                        .add(StopWatchExecute.start);
                                  } else {
                                    stopWatchTimer.onExecute
                                        .add(StopWatchExecute.reset);
                                    appController
                                        .getCurrentGame()
                                        .stopWatch
                                        .setPresetTime(
                                            mSec: currentTime + 1000);
                                  }
                                  appController.refresh();
                                },
                                child: const Text(
                                  '+1 sec',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red,
                                  onPrimary: Colors.white,
                                  shape: const StadiumBorder(),
                                ),
                                onPressed: () async {
                                  int currentTime =
                                      stopWatchTimer.rawTime.value;
                                  // make sure the timer can't go negative
                                  if (currentTime <= 1000) return;
                                  stopWatchTimer.clearPresetTime();
                                  if (stopWatchTimer.isRunning) {
                                    stopWatchTimer.onExecute
                                        .add(StopWatchExecute.reset);
                                    appController
                                        .getCurrentGame()
                                        .stopWatch
                                        .setPresetTime(
                                            mSec: currentTime - 1000);
                                    stopWatchTimer.onExecute
                                        .add(StopWatchExecute.start);
                                  } else {
                                    stopWatchTimer.onExecute
                                        .add(StopWatchExecute.reset);
                                    appController
                                        .getCurrentGame()
                                        .stopWatch
                                        .setPresetTime(
                                            mSec: currentTime - 1000);
                                  }
                                  appController.refresh();
                                },
                                child: const Text(
                                  '-1 sec',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]))));
  }
}
