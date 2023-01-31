import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/features/sidebar/sidebar.dart';
import 'package:handball_performance_tracker/core/core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:handball_performance_tracker/features/dashboard/dashboard.dart';
import 'package:handball_performance_tracker/features/authentication/authentication.dart';
import 'package:handball_performance_tracker/features/team_management/team_management.dart';
import 'package:handball_performance_tracker/features/game/game.dart';

class SidebarView extends StatelessWidget {
  const SidebarView({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final gameState = context.watch<GameBloc>().state;
    String clubName = "";
    bool gameStarted = gameState.stopWatchTimer.rawTime.value > 0;
    // TODO implement block for gameRunning here
    if (authState.authStatus == AuthStatus.Authenticated &&
        authState.club != null) {
      clubName = authState.club!.name;
    }

    return Drawer(
      backgroundColor: Colors.blue,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: Colors.blue),
                  accountName: Text(
                    clubName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  accountEmail: Text(
                    FirebaseAuth.instance.currentUser?.email ?? "",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text(
                      clubName.substring(0, 1),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // DrawerHeader(child: Text(clubName)),
                SimpleListEntry(
                    text: "Dashboard",
                    icon: Icons.dashboard,
                    screen: DashboardView()),
                SidebarStatisticsButton(
                    text: "Statistiken", icon: Icons.bar_chart),
                SimpleListEntry(
                    text: "Team Management",
                    icon: Icons.person,
                    screen: TeamManagementPage()),
                    if (gameStarted)
                      SimpleListEntry(
                          text: "Laufendes Spiel", icon: Icons.gamepad, screen: GameView())
                    else
                      Text(""),
              ],
            ),
          ),
          Container(
              // This align moves the children to the bottom
              child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  // This container holds all the children that will be aligned
                  // on the bottom and should not scroll with the above ListView
                  child: Container(
                      child: Column(
                    children: <Widget>[
                      Divider(),
                      ListTile(
                        leading: Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
                        textColor: Colors.white,
                        title: Text(StringsAuth.lSignOutButton),
                        onTap: () {
                          context.read<AuthBloc>().add(SignOutRequested());
                          GameBloc gameBloc = context.read<GameBloc>();
                          gameBloc.add(ResetGame());
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignIn()));
                        },
                      ),
                    ],
                  )))),
        ],
      ),
    );


    // TODO will be removed before merge once approved

    // return Drawer(
    //   backgroundColor: Colors.blue,
    //   child: Stack(
    //     children: [
    //       ListView(
    //           padding: EdgeInsets.zero,
    //           children: ListTile.divideTiles(
    //               context: context,
    //               color: popupDarkBlueColor,
    //               tiles: [
    //                 MenuHeader(
    //                   clubName: clubName,
    //                 ),

    //                 // Dashboard
    //                 SimpleListEntry(text: "Dashboard", screen: DashboardView()),
    //                 // show game is running button only if game is running.
    //                 SimpleListEntry(
    //                   text: StringsGeneral.lTeamManagement,
    //                   screen: TeamManagementPage(),
    //                   //children: buildTeamChildren(context),
    //                 ),
    //                 SidebarStatisticsButton(
    //                   text: "Statistiken",
    //                 ),
    //                 if (gameStarted)
    //                   SimpleListEntry(
    //                       text: "Laufendes Spiel", screen: GameView())
    //                 else
    //                   Text(""),
    //               ]).toList()),
    //       // Sign out button at the bottom
    //       Center(
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           mainAxisSize: MainAxisSize.max,
    //           mainAxisAlignment: MainAxisAlignment.end,
    //           children: [
    //             RichText(
    //               text: TextSpan(
    //                 text: StringsAuth.lSignedInAs,
    //                 style: TextStyle(
    //                   color: Colors.white,
    //                 ),
    //                 children: <TextSpan>[
    //                   TextSpan(
    //                       text: FirebaseAuth.instance.currentUser?.email
    //                           .toString(),
    //                       style: TextStyle(fontWeight: FontWeight.bold))
    //                 ],
    //               ),
    //             ),
    //             Container(
    //               margin: EdgeInsets.all(5),
    //               child: ElevatedButton.icon(
    //                 style: ElevatedButton.styleFrom(
    //                   primary: buttonGreyColor,
    //                 ),
    //                 onPressed: () {
    //                   context.read<AuthBloc>().add(SignOutRequested());
    //                   GameBloc gameBloc = context.read<GameBloc>();
    //                   gameBloc.add(ResetGame());
    //                   Navigator.pushReplacement(context,
    //                       MaterialPageRoute(builder: (context) => SignIn()));
    //                 },
    //                 icon: Icon(
    //                   Icons.logout,
    //                   color: buttonDarkBlueColor,
    //                 ),
    //                 label: Text(
    //                   StringsAuth.lSignOutButton,
    //                   style: TextStyle(color: buttonDarkBlueColor),
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
