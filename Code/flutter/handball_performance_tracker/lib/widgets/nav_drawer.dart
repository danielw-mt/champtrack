import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/constants/colors.dart';
import 'package:handball_performance_tracker/constants/stringsTeamManagement.dart';
import 'package:handball_performance_tracker/controllers/persistentController.dart';
import 'package:handball_performance_tracker/controllers/tempController.dart';
import 'package:handball_performance_tracker/data/team.dart';
import 'package:handball_performance_tracker/main.dart';
import 'package:handball_performance_tracker/screens/dashboard.dart';
import 'package:handball_performance_tracker/screens/glossaryScreen.dart';
import 'package:handball_performance_tracker/screens/statisticsScreen.dart';
import 'package:handball_performance_tracker/screens/teamSettingsScreen.dart';
import 'package:handball_performance_tracker/widgets/main_screen/ef_score_bar.dart';
import 'package:handball_performance_tracker/constants/stringsAuthentication.dart';
import './../screens/mainScreen.dart';
import '../screens/debugScreen.dart';
import '../screens/teamSelectionScreen.dart';
import 'package:get/get.dart';
import '../constants/stringsGeneral.dart';

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
                    children: ListTile.divideTiles(
                      context: context,
                      color: popupDarkBlueColor,
                      tiles: buildMenuList(
                          context,
                          tempController.getGameIsRunning(),
                          tempController.getGameIsPaused(),
                          tempController.getMenuIsEllapsed()),
                    ).toList(),
                  );
                }),
            // Sign out button at the bottom
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RichText(
                    text: TextSpan(
                      text: StringsAuth.lSignedInAs,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text: FirebaseAuth.instance.currentUser?.email
                                .toString(),
                            style: TextStyle(fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(5),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: buttonGreyColor,
                      ),
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Get.to(Home());
                      },
                      icon: Icon(
                        Icons.logout,
                        color: buttonDarkBlueColor,
                      ),
                      label: Text(
                        StringsAuth.lSignOutButton,
                        style: TextStyle(color: buttonDarkBlueColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Build List of Menu entries to show. If gameIsRunning, add the button which takes you back to the game.
List<Widget> buildMenuList(BuildContext context, bool gameIsRunning,
    bool gameIsPaused, bool menuIsEllapsed) {
  List<Widget> menuList = <Widget>[
    MenuHeader(),
    // Dashboard
    SimpleListEntry(text: StringsGeneral.lDashboard, screen: Dashboard()),
    // Mannschaften
    CollabsibleListEntry(
      text: StringsTeamManagement.lTeams,
      screen: TeamSelectionScreen(),
      children: buildTeamChildren(context),
    ),
    // Statistics
    CollabsibleListEntry(
        text: StringsGeneral.lStatistics,
        screen: StatisticsScreen(),
        children: [Text("")]),
    // Glossary
    CollabsibleListEntry(
        text: StringsGeneral.lGlossary,
        screen: GlossaryScreen(),
        children: [Text("")]),
  ];
  if ((gameIsRunning || gameIsPaused) && !menuIsEllapsed) {
    menuList.add(GameIsRunningButton());
  } else {
    // Add empty text so we have a divider after last list item
    menuList.add(Text(""));
  }
  return menuList;
}

// Returns a simple, non-collapsible Entry for the menu.
// Params: - text: Text that will be displayed in the entry
//         - screen: Screen that it will send you
//         - teamId: Given if Screen is Team settings screen to know which teams settings should be shown
class SimpleListEntry extends StatelessWidget {
  final String text;
  final Widget screen;
  String? teamId;
  SimpleListEntry({required this.text, required this.screen, String? teamId}) {
    this.teamId = teamId;
  }

  // Called if teamId is given, calls team selection screen for that team.
  void showSelectedTeam(teamId) {
    final TempController tempController = Get.find<TempController>();
    final PersistentController persController =
        Get.find<PersistentController>();
    tempController.setSelectedTeam(persController.getSpecificTeam(teamId));
    Get.to(screen);
  }

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
        (teamId == null) ? Get.to(screen) : showSelectedTeam(teamId);
      },
      minVerticalPadding: 0,
    );
  }
}

// Returns a collapsible Entry for the menu.
// Params: - text: Text that will be displayed in the entry
//         - screen: Screen that it will send you
//         - children: List of ListTiles that will open
class CollabsibleListEntry extends StatelessWidget {
  final String text;
  final Widget screen;
  final List<Widget> children;
  const CollabsibleListEntry(
      {Key? key,
      required this.text,
      required this.screen,
      required this.children})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TempController tempController = Get.find<TempController>();
    return ExpansionTile(
      iconColor: Colors.white,
      collapsedIconColor: Colors.white,
      // If Menu is ellapsed, running game button should disappear to avoid overlapping
      onExpansionChanged: (value) {
        tempController.setMenuIsEllapsed(value);
      },
      title: TextButton(
          onPressed: () {
            Navigator.pop(context);
            Get.to(screen);
          },
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          )),
      children: ListTile.divideTiles(
        context: context,
        color: popupDarkBlueColor,
        tiles: children,
      ).toList(),
    );
  }
}

// returns the first line of the menu which is
// - the grey container
// - name of the Club
// - Arrows
class MenuHeader extends StatelessWidget {
  const MenuHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Header with Icon and Clubname
    return Row(
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
            margin: EdgeInsets.only(right: 20, left: 10, bottom: 15, top: 15),
            padding: EdgeInsets.all(10),
            child: Text(
              "HC",
            )),

        // Use FittedBox to dynamically resize text
        Expanded(
          child: FittedBox(
              fit: BoxFit.cover,
              child: GetBuilder<PersistentController>(
                  id: "menu-club-display",
                  builder: (persController) {
                    return Text(
                      persController.getLoggedInClub().name,
                      style: TextStyle(color: Colors.white),
                    );
                  })),
        ),
        // Arrow Icon
        Container(margin: EdgeInsets.only(left: 20), child: Text(""))
      ],
    );
  }
}

// Button which takes you back to the game
class GameIsRunningButton extends StatelessWidget {
  const GameIsRunningButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TempController tempController = Get.find<TempController>();

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
                StringsGeneral.lBackToGameButton,
                style: TextStyle(color: buttonDarkBlueColor, fontSize: 18),
              ),
            )
          ],
        ),
        onPressed: () {
          tempController.setSelectedTeam(tempController.getPlayingTeam());
          Navigator.pop(context);
          Get.to(MainScreen());
        },
      ),
    );
  }
}

// Build List of ListTiles with all alvailable teams.
List<Widget> buildTeamChildren(BuildContext context) {
  final PersistentController persController = Get.find<PersistentController>();
  List<Team> allTeams = persController.getAvailableTeams();
  List<Widget> teamChildren = [Divider()];
  for (Team team in allTeams) {
    teamChildren.add(SimpleListEntry(
      text: " " * 5 + team.name,
      screen: TeamSettingsScreen(),
      teamId: team.id,
    ));
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
        color: buttonDarkBlueColor,
        onPressed: () {
          scaffoldKey.currentState!.openDrawer();
        },
      ),
    );
  }
}
