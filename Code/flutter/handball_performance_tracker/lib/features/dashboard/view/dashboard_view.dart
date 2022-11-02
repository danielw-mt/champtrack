import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/features/dashboard/dashboard.dart';
import 'package:handball_performance_tracker/core/constants/colors.dart';
import 'package:handball_performance_tracker/features/sidebar/sidebar.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    final dashboardState = context.watch<DashboardBloc>().state;
    String clubName = "";
    switch (dashboardState.status) {
      case DashboardStatus.initial:
        clubName = "Loading...";
        break;
      case DashboardStatus.loading:
        clubName = "Loading...";
        break;
      case DashboardStatus.success:
        clubName = dashboardState.club.name;
        break;
      case DashboardStatus.failure:
        clubName = "Error";
        break;
    }

    return SafeArea(
        child: Scaffold(
            backgroundColor: backgroundColor,
            key: _scaffoldKey,
            drawer: SidebarPage(),
            appBar: AppBar(
                backgroundColor: buttonDarkBlueColor,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /*Container(
                          padding: EdgeInsets.only(right: 10),
                          child: new Image.asset(
                            "images/launcher_icon.png",
                            height: MediaQuery.of(context).size.height * 0.1,
                            fit: BoxFit.cover,
                          ),
                        ),*/
                    Text(
                      clubName,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ],
                )),
            // if drawer is closed notify, so if game is running the back to game button appears on next opening

            // TODO implement drawer
            // onDrawerChanged: (isOpened) {
            //   if (!isOpened) {
            //     tempController.setMenuIsEllapsed(false);
            //   }
            // },
            body: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              // Upper white bar with menu button etc
              /*Container(
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Container for menu button on top left corner
                                //MenuButton(_scaffoldKey),
                                
                                Text(""), // To be substituted by saison button
                              ],
                            ),
                          ),*/

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Buttons
                  Container(
                    child: Column(
                      children: [
                        StatisticsButton(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ManageTeamsButton(),
                            StartNewGameButton(),
                            // Take game restore out for now (18.10.22)
                            //OldGameCard()
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ])));
  }
}
