import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/controllers/globalController.dart';
import './../screens/mainScreen.dart';
import './../screens/helperScreen.dart';
import './../screens/settingsScreen.dart';
import 'package:get/get.dart';

class NavDrawer extends StatelessWidget {
  // Navigation widget for Material app. Can be opend from the sidebar
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              child: Text(
                'Side menu',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
              decoration: BoxDecoration(
                color: Colors.green,
              )),
          ListTile(
            leading: Icon(Icons.input),
            title: Text('Settings'),
            onTap: () => {Get.to(SettingsScreen())},
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Main Screen'),
            onTap: () => {
              if (Get.currentRoute.toString() != "/") {Get.to(MainScreen())}
            },
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Helper Screen'),
            onTap: () => {Get.to(HelperScreen())},
          ),
        ],
      ),
    );
  }
}
