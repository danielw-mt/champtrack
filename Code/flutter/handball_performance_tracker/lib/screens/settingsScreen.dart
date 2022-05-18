import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './../widgets/settings_screen/player_dropdown.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Two'),
      ),
      body: Center(child: PlayerDropdown()),
    );
  }
}
