import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/core/constants/colors.dart';
import 'package:handball_performance_tracker/core/constants/stringsGeneral.dart';
import 'package:handball_performance_tracker/features/team_management/team_management.dart';

// Bottom Nav Bar for team settings screen
class TeamManagementTabsBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamManagementCubit, TeamManagementState>(
      builder: (context, state) {
        return Container(
          color: Color(0xFF3F5AA6),
          child: TabBar(
            controller: DefaultTabController.of(context),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding: EdgeInsets.all(5.0),
            indicatorColor: buttonDarkBlueColor,
            onTap: (int tabNumber) {
              if (state is TeamManagementLoaded) {
                context.read<TeamManagementCubit>().changeTab(TeamManagementTab.values[tabNumber]);
              }
            },
            tabs: [
              Tab(
                text: StringsGeneral.lPlayer,
                icon: Icon(Icons.sports_handball),
              ),
              Tab(
                text: StringsGeneral.lGames,
                icon: Icon(Icons.list_alt),
              ),
              Tab(
                text: StringsGeneral.lTeamDetails,
                icon: Icon(Icons.settings),
              ),
            ],
          ),
        );
      },
    );
  }
}
