import 'package:flutter/material.dart';
// import 'package:get/get.dart';

class mainScreen extends StatelessWidget {
  // final MainScreenController controller = Get.put(MainScreenController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       title: Text("Title")
      ),
      body: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: 7,
          itemBuilder: (BuildContext context, int index) {
            return TextField(
              // controller: controller.playerNameTextControllers[index],
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            );
          }
      ),
    );
  }
}
