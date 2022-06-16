import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/controllers/globalController.dart';
import './../screens/mainScreen.dart';
import '../screens/placeholderScreen.dart';
import './../screens/settingsScreen.dart';
import '../screens/teamSelectionScreen.dart';
import 'package:get/get.dart';
import '../strings.dart';

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
                Strings.lSideMenuHeader,
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
              decoration: BoxDecoration(
                color: Colors.green,
              )),
          ListTile(
            leading: Icon(Icons.input),
            title: Text(Strings.lSettings),
            onTap: () => {Get.to(SettingsScreen())},
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text(Strings.lMainScreen),
            onTap: () => {
              if (Get.currentRoute.toString() != "/") {Get.to(MainScreen())}
            },
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Placeholder Screen'),
            onTap: () => {Get.to(PlaceholderScreen())},
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text(Strings.lTeamSelectionScreen),
            onTap: () => {Get.to(TeamSelectionScreen())},
          ),
          Spacer(),
          Text("Signed in as ${FirebaseAuth.instance.currentUser?.email.toString()}"),
          ElevatedButton.icon(
              onPressed: () {FirebaseAuth.instance.signOut();},
              icon: Icon(Icons.logout),
              label: Text(Strings.lSignOutButton))
        ],
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  late GlobalKey<ScaffoldState> scaffoldKey;

  MenuButton(GlobalKey<ScaffoldState> scaffoldKey) {
    this.scaffoldKey = scaffoldKey;
  }

  @override
  Widget build(BuildContext context) {
    return // Container for menu button on top left corner
        Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          color: Colors.white),
      child: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {
          scaffoldKey.currentState!.openDrawer();
        },
      ),
    );
  }
}
