import 'package:flutter/material.dart';

// Returns a simple, non-collapsible Entry for the menu.
// Params: - text: Text that will be displayed in the entry
//         - screen: Screen that it will send you
//         - teamId: Given if Screen is Team settings screen to know which teams settings should be shown
class SimpleListEntry extends StatelessWidget {
  final String text;
  final Widget screen;
  SimpleListEntry({required this.text, required this.screen});
  

  @override
  Widget build(BuildContext context) {
    return ListTile(
      textColor: Colors.white,
      title: Text(
        " " * 2 + text,
        style: TextStyle(fontSize: 20),
      ),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      minVerticalPadding: 0,
    );
  }
}