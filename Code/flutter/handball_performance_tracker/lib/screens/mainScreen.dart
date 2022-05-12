import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/mainScreenController.dart';

class mainScreen extends StatelessWidget {
  final MainScreenController controller = Get.put(MainScreenController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       title: Text("Title")
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Obx(() =>
              Text(
                '${controller.count.value}',
                style: Theme.of(context).textTheme.headline4,
              )
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.increment,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
