import 'package:flutter/material.dart';
// import 'package:get/get.dart';

class mainScreen extends StatelessWidget {
  // final MainScreenController controller = Get.put(MainScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Title")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
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
                }),
          ),
          Expanded(
            child: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              children: <Widget>[
                Button(text: "Tor Position"),
                Button(text: "Tor 9m"),
                Button(text: "Tor 9m+"),
                Button(text: "Assist"),
                Button(text: "Fehlwurf"),
                Button(text: "TRF"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Button extends StatelessWidget {
  const Button({required this.text, Key? key}) : super(key: key);
  final String text;

  //Button(String text){this.text = text;}

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        textStyle: const TextStyle(fontSize: 20),
      ),
      onPressed: () {},
      child: Text(text),
    );
  }
}
