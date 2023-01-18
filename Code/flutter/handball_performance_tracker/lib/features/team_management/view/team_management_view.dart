import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/data/models/game_model.dart';
import 'package:handball_performance_tracker/features/sidebar/sidebar.dart';
import 'package:handball_performance_tracker/features/team_management/team_management.dart';
import 'package:handball_performance_tracker/core/core.dart';

const String page1 = "Players";
const String page2 = "Spiele";
const String page3 = "Einstellungen";

// A screen where all the available teams are listed for men, women and youth teams
class TeamManagementView extends StatelessWidget {
  // screen that allows players to be selected including what players are on the field or on the bench (non selected)
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _buildTeamManangementBody(BuildContext context) {
    final state = context.watch<TeamManagementBloc>().state;
    // if (state.status != TeamManagementStatus.loaded) {
    //   return const Center(child: CircularProgressIndicator());
    // }
    if (state.selectedTabIndex == 0) {
      return TeamManagementPlayers();
    }
    if (state.selectedTabIndex == 1) {
      return TeamManagementGames();
    }
    // if (state.selectedTabIndex == 2) {
    //   return TeamManagementSettings();
    // }
    return const Center(child: Text("Error"));
  }

  @override
  Widget build(BuildContext context) {
    final teamManagementState = context.watch<TeamManagementBloc>().state;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(StringsGeneral.lTeamManagement),
        ),
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        drawer: SidebarView(),
        body: _buildTeamManangementBody(context),
        bottomNavigationBar: BottomNavigationBar(
            onTap: (index) {
              BlocProvider.of<TeamManagementBloc>(context)
                  .add(ChangeTabs(tabIndex: index));
            },
            currentIndex: teamManagementState.selectedTabIndex,
            items: const [
              BottomNavigationBarItem(
                label: page1,
                icon: Icon(Icons.person_add),
              ),
              BottomNavigationBarItem(
                label: page2,
                icon: Icon(Icons.list),
              ),
              // BottomNavigationBarItem(
              //   label: page3,
              //   icon: Icon(Icons.settings),
              // ),
            ]),
      ),
    );

    // DefaultTabController(
    //     initialIndex: 0,
    //     length: 3,
    //     child: BlocBuilder<TeamManagementBloc, TeamManagementState>(
    //         builder: (context, state) {
    //       if (globalState.status == GlobalStatus.loading) {
    //         return Center(child: CircularProgressIndicator());
    //       }
    //       if (globalState.status == GlobalStatus.success) {
    //         TeamManagementBloc teamManagementBloc =
    //             BlocProvider.of<TeamManagementBloc>(context);
    //         return Scaffold(
    //             appBar: AppBar(
    //                 backgroundColor: buttonDarkBlueColor,
    //                 title: Text(StringsGeneral.lTeamManagement)),
    //             key: _scaffoldKey,
    //             drawer: SidebarView(),
    //             bottomNavigationBar: TabsBar(),
    //             body: Column(
    //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //               children: [
    //                 Expanded(
    //                   child: Row(
    //                       mainAxisAlignment: MainAxisAlignment.center,
    //                       crossAxisAlignment: CrossAxisAlignment.stretch,
    //                       children: [
    //                         Flexible(
    //                             flex: 1,
    //                             child: Center(child: TeamDropdown())),
    //                         Flexible(
    //                           flex: 1,
    //                           child: Center(
    //                               child: ElevatedButton(
    //                             onPressed: (() => showDialog(
    //                                 context: context,
    //                                 builder: (context) => BlocProvider<
    //                                         TeamManagementBloc>.value(
    //                                       value: teamManagementBloc,
    //                                       child: AlertDialog(
    //                                         title: Text(
    //                                             StringsGeneral.lAddTeam),
    //                                         content: NewTeamForm(),
    //                                       ),
    //                                     ))),
    //                             child: Text(StringsTeamManagement.lAddTeam),
    //                           )),
    //                         )
    //                       ]),
    //                 ),
    //                 // players list or games list or team settings depending which tab is selected
    //                 if (state.currentTab == TeamManagementTab.playersTab)
    //                   Column(
    //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                     children: [
    //                       PlayersList(),
    //                       ElevatedButton(
    //                           onPressed: () {
    //                             showDialog(
    //                                 context: context,
    //                                 builder: (BuildContext context) =>
    //                                     AlertDialog(
    //                                       title: Text(StringsTeamManagement
    //                                           .lAddPlayer),
    //                                       content: SizedBox(
    //                                         width: MediaQuery.of(context)
    //                                                 .size
    //                                                 .width *
    //                                             0.7,
    //                                         height: MediaQuery.of(context)
    //                                                 .size
    //                                                 .height *
    //                                             0.8,
    //                                         child: Column(
    //                                           mainAxisAlignment:
    //                                               MainAxisAlignment.center,
    //                                           children: [
    //                                             PlayerForm(
    //                                                 editModeEnabled: false)
    //                                           ],
    //                                         ),
    //                                       ),
    //                                       actions: [
    //                                         TextButton(
    //                                           child: Text(
    //                                               StringsGeneral.lCancel),
    //                                           onPressed: () {
    //                                             Navigator.of(context).pop();
    //                                           },
    //                                         ),
    //                                         TextButton(
    //                                           child: Text(StringsGeneral
    //                                               .lSubmitButton),
    //                                           onPressed: () {
    //                                             Navigator.of(context).pop();
    //                                           },
    //                                         ),
    //                                       ],
    //                                     ));
    //                           },
    //                           child: Text("Add player"))
    //                     ],
    //                   ),
    //                 if (state.currentTab == TeamManagementTab.gamesTab)
    //                   GameList(),
    //                 if (state.currentTab == TeamManagementTab.settingsTab)
    //                   TeamSettings(),
    //               ],
    //             ));
    //       }
    //       if (globalState.status == GlobalStatus.failure) {
    //         print("team management error");
    //         return Text("Error");
    //       }
    //       // By default add this state
    //       return Text("This shouldn't happen");
    //     })
    //     )
    // );
  }
}
