import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/constants/colors.dart';
import 'package:handball_performance_tracker/controllers/persistentController.dart';
import 'package:handball_performance_tracker/controllers/tempController.dart';
import 'package:handball_performance_tracker/data/team.dart';
import 'package:handball_performance_tracker/screens/dashboard.dart';
import 'package:handball_performance_tracker/widgets/main_screen/ef_score_bar.dart';
import './../screens/mainScreen.dart';
import '../screens/debugScreen.dart';
import '../screens/teamSelectionScreen.dart';
import 'package:get/get.dart';
import '../strings.dart';

class NavDrawer extends StatelessWidget {
  // Navigation widget for Material app. Can be opend from the sidebar
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: buttonDarkBlueColor,
        child: Stack(
          children: [
            // show game is running button only if game is running.
            GetBuilder<TempController>(
                id: "game-is-running-button",
                builder: (tempController) {
                  return ListView(
                    padding: EdgeInsets.zero,
                    children: buildMenuList(
                        context, tempController.getGameIsRunning()),
                  );
                }),
            // Sign out button at the bottom
            Positioned(
              bottom: 0,
              child: Container(
                  child: Column(
                children: [
                  Text(
                      "Signed in as ${FirebaseAuth.instance.currentUser?.email.toString()}"),
                  ElevatedButton.icon(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                      },
                      icon: Icon(Icons.logout),
                      label: Text(Strings.lSignOutButton))
                ],
              )
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Build List of Menu entries to show. If gameIsRunning, add the button which takes you back to the game.
List<Widget> buildMenuList(BuildContext context, bool gameIsRunning) {
  List<Widget> menuList = <Widget>[
    // Header with Icon and Clubname
    Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Icon
        Container(
            decoration: BoxDecoration(
                color: buttonGreyColor,
                // set border so corners can be made round
                border: Border.all(
                  color: buttonGreyColor,
                ),
                // make round edges
                borderRadius: BorderRadius.all(Radius.circular(menuRadius))),
            margin: EdgeInsets.only(right: 20, left: 10),
            padding: EdgeInsets.all(5),
            child: Text(
              "HC",
            )),

        // Use FittedBox to dynamically resize text
        Expanded(
          child: FittedBox(
            fit: BoxFit.cover,
            child: Text(
              "Clubname",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        // Arrow Icon
        Container(
            margin: EdgeInsets.only(left: 20),
            child: Icon(Icons.keyboard_double_arrow_left,
                color: Colors.white, size: 40))
      ],
    ),

    Divider(
      color: Colors.white,
    ),
    // Dashboard
    ListTile(
      textColor: Colors.white,
      title: Text(
        " " * 2 + Strings.lDashboard,
        style: TextStyle(fontSize: 20),
      ),
      onTap: () => {Get.to(Dashboard())},
      minVerticalPadding: 0,
    ),
    Divider(
      color: Colors.white,
    ),
    // Mannschaften
    ExpansionTile(
      iconColor: Colors.white,
      collapsedIconColor: Colors.white,
      title: TextButton(
          onPressed: () => {
                if (Get.currentRoute.toString() != "/")
                  {Get.to(TeamSelectionScreen())}
              },
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              Strings.lTeams,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          )),
      children: buildTeamChildren(context),
    ),
    Divider(
      color: Colors.white,
    ),
    // Statistics
    ExpansionTile(
      iconColor: Colors.white,
      collapsedIconColor: Colors.white,
      title: TextButton(
          onPressed: () => {Get.to(DebugScreen())},
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              Strings.lStatistics,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          )),
      children: [Text("")],
    ),

    Divider(
      color: Colors.white,
    ),
    // Glossary
    ExpansionTile(
      iconColor: Colors.white,
      collapsedIconColor: Colors.white,
      title: TextButton(
          onPressed: () => {Get.to(DebugScreen())},
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              Strings.lGlossary,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          )),
      children: [Text("")],
    ),
  ];
  if (gameIsRunning) {
    menuList.add(GameIsRunningButton());
  }
  return menuList;
}

//Button which takes you back to the game
class GameIsRunningButton extends StatelessWidget {
  const GameIsRunningButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Back to Game Button
    return Container(
      decoration: BoxDecoration(
          color: buttonDarkBlueColor,
          // set border so corners can be made round
          border: Border.all(
            color: buttonDarkBlueColor,
          ),
          // make round edges
          borderRadius: BorderRadius.all(Radius.circular(menuRadius))),
      margin: EdgeInsets.only(left: 20, right: 20, top: 100),
      padding: EdgeInsets.all(10),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: buttonGreyColor,
          padding: EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(buttonRadius),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sports_handball, color: buttonDarkBlueColor, size: 50),
            Expanded(
              child: Text(
                Strings.lBackToGameButton,
                style: TextStyle(color: buttonDarkBlueColor, fontSize: 20),
              ),
            )
          ],
        ),
        onPressed: () => {Get.to(MainScreen())},
      ),
    );
  }
}

// Build List of ListTiles with all alvailable teams.
List<Widget> buildTeamChildren(BuildContext context) {
  final PersistentController persController = Get.find<PersistentController>();
  List<Team> allTeams = persController.getAvailableTeams();
  List<Widget> teamChildren = [];
  Divider divider = Divider(
    color: Colors.white,
  );
  for (Team team in allTeams) {
    teamChildren.add(divider);
    ListTile nextTile = ListTile(
      textColor: Colors.white,
      title: Text(" " * 5 + team.name),
      onTap: () => {Get.to(DebugScreen())},
    );
    teamChildren.add(nextTile);
  }
  return teamChildren;
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
