import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/features/sidebar/sidebar.dart';
import 'package:handball_performance_tracker/data/repositories/club_repository.dart';
import 'package:handball_performance_tracker/core/constants/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:handball_performance_tracker/core/constants/stringsAuthentication.dart';
import 'package:handball_performance_tracker/features/dashboard/dashboard.dart';

class SidebarView extends StatelessWidget {
  const SidebarView({super.key});

  @override
  Widget build(BuildContext context) {
    final sidebarState = context.watch<SidebarBloc>().state;
    String clubName = "";
    bool gameRunning = false;
    switch (sidebarState.status) {
      case SidebarStatus.initial:
        clubName = "Loading...";
        break;
      case SidebarStatus.loading:
        clubName = "Loading...";
        break;
      case SidebarStatus.success:
        clubName = sidebarState.club.name;
        break;
      case SidebarStatus.failure:
        clubName = "Error";
        break;
      case SidebarStatus.gameRunning:
        gameRunning = true;
        break;
      case SidebarStatus.gameNotRunning:
        gameRunning = false;
        break;
      default:
        break;
    }

    return Drawer(
      child: Container(
        color: buttonDarkBlueColor,
        child: Stack(
          children: [
            ListView(
                padding: EdgeInsets.zero,
                children: ListTile.divideTiles(context: context, color: popupDarkBlueColor, tiles: [
                  MenuHeader(
                    clubName: clubName,
                  ),

                  // Dashboard
                  SimpleListEntry(text: "TODO Dashboard", screen: DashboardPage()),
                  // show game is running button only if game is running.
                  SimpleListEntry(
                    text: "TODO Teams",
                    screen: DashboardPage(),
                    //children: buildTeamChildren(context),
                  ),
                  SimpleListEntry(text: "TODO Statistics", screen: DashboardPage()),
                  if (gameRunning) SimpleListEntry(text: "TODO Game is running", screen: DashboardPage()) else Text(""),
                ]).toList()),
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
                        TextSpan(text: FirebaseAuth.instance.currentUser?.email.toString(), style: TextStyle(fontWeight: FontWeight.bold))
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
                        // Get.to(Home());
                        // Get.deleteAll();
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
