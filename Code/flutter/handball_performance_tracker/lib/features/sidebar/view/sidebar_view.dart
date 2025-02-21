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
    if (authState.authStatus == AuthStatus.Authenticated && authState.club != null) {
      clubName = authState.club!.name;
    }

    return Drawer(
      child: Container(
        color:  Colors.blue,
        child: Stack(
          children: [
            ListView(
                padding: EdgeInsets.zero,
                children: ListTile.divideTiles(context: context, color: popupDarkBlueColor, tiles: [
                  MenuHeader(
                    clubName: clubName,
                  ),

                  // Dashboard
                  SimpleListEntry(text: "Dashboard", screen: DashboardView()),
                  // show game is running button only if game is running.
                  SimpleListEntry(
                    text: StringsGeneral.lTeamManagement,
                    screen: TeamManagementPage(),
                    //children: buildTeamChildren(context),
                  ),
                  SidebarStatisticsButton(text: "Statistiken",),
                  if (gameStarted) SimpleListEntry(text: "Game is running", screen: GameView()) else Text(""),
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
                        context.read<AuthBloc>().add(SignOutRequested());
                        GameBloc gameBloc = context.read<GameBloc>();
                        gameBloc.add(ResetGame());
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignIn()));
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
