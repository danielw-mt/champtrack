import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/core/core.dart';
import 'package:handball_performance_tracker/features/game_setup/game_setup.dart';
import 'package:handball_performance_tracker/features/sidebar/sidebar.dart';
import 'package:handball_performance_tracker/features/dashboard/dashboard.dart';
import 'package:handball_performance_tracker/features/authentication/authentication.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/features/statistics/view/view.dart';
import 'package:handball_performance_tracker/features/team_management/team_management.dart';

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    String clubName = "";
    if (authState.authStatus == AuthStatus.Loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (authState.authStatus == AuthStatus.Authenticated &&
        authState.club != null) {
      clubName = authState.club!.name;
      final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
      return SafeArea(
          child: Scaffold(
              backgroundColor: backgroundColor,
              key: _scaffoldKey,
              drawer: SidebarView(),
              appBar: AppBar(
                  backgroundColor: Colors.blue,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        clubName,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ],
                  )),
              body: SafeArea(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: DashboardCard(
                              screen: StatisticsView(),
                              title: StringsGeneral.lStatistics,
                              icon: Icons.bar_chart)),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: DashboardCard(
                                  screen: TeamManagementPage(),
                                  title: StringsDashboard.lManageTeams,
                                  icon: Icons.person),
                            ),
                            Expanded(
                              child: DashboardCard(
                                  screen: GameSetupPage(),
                                  title: StringsDashboard.lTrackNewGame,
                                  icon: Icons.sports_handball),
                            ),

                            // Buttons
                            // Container(
                            //   child: Column(
                            //     children: [
                            //       StatisticsButton(),
                            //       Row(
                            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //         children: [
                            //           ManageTeamsButton(),
                            //           StartNewGameButton(),
                            //           // Take game restore out for now (18.10.22)
                            //           //OldGameCard()
                            //         ],
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ]),
              )));
    } else {
      print(authState);
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignIn()));
      return SignIn();
    }
  }
}
