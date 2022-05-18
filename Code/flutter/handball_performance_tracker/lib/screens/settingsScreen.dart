import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './../widgets/settings_screen/player_dropdown.dart';
import './../controllers/globalController.dart';

class SettingsScreen extends GetView<GlobalController> {
  //const SettingsScreen({Key? key}) : super(key: key);
  final GlobalController globalController = Get.find<GlobalController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Two'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: PlayerDropdown()),
              FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: (() {
                    globalController.chosenPlayers
                        .add(globalController.selectedPlayer.value);
                    globalController.startingPlayers.add(false);
                  })),
            ],
          ),
          Obx(() {
            if (globalController.chosenPlayers.length > 0) {
              return Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: globalController.chosenPlayers.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          FloatingActionButton(
                              child: Icon(Icons.remove),
                              onPressed: () {
                                globalController.chosenPlayers.removeAt(index);
                                globalController.startingPlayers
                                    .removeAt(index);
                              }),
                          Text(globalController.chosenPlayers[index]),
                          // TODO implement checkbox logic
                          Checkbox(
                            value: false,
                            onChanged: (value) {},
                          )
                        ],
                      );
                    }),
              );
            }
            return Container();
          })
        ],
      ),
    );
  }
}
