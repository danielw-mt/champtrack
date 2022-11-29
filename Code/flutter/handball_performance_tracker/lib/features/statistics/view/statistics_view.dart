import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/features/sidebar/view/sidebar_view.dart';


// import '../core/constants/colors.dart';
// import '../../old-widgets/statistic_screen/player_statistics.dart';
// import '../../old-widgets/statistic_screen/team_statistics.dart';
// import '../../old-widgets/statistic_screen/comp_statistics.dart';


import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/features/statistics/statistics.dart';
// import 'package:get/get.dart';
// import 'package:handball_performance_tracker/oldcontrollers/temp_controller.dart';
// import '../../old-widgets/nav_drawer.dart';
// import '../../old-widgets/statistic_screen/charts.dart';

// TODO move these to the constant strings
const String page1 = "Team";
const String page2 = "Player";
const String page3 = "Vergleich";

// class StatisticsView extends StatefulWidget {
//   @override
//   _StatisticsScreenState createState() => _StatisticsScreenState();
// }

class StatisticsView extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  //final TempController tempController = Get.put(TempController());

  // late List<Widget> _pages;
  // late Widget _teamStatistics;
  // late Widget _playerStatistics;
  // late Widget _compStatistics;
  // late int _currentIndex;
  // late Widget _currentPage;

  // @override
  // void initState() {
  //   super.initState();
  //   _teamStatistics = const TeamStatistics();
  //   _playerStatistics = const PlayerStatistics();
  //   _compStatistics = ComparisonStatistics(changePage: _changeTab);
  // _pages = [_teamStatistics, _playerStatistics, _compStatistics];
  //   _currentIndex = 0;
  //   _currentPage = _teamStatistics;
  // }

  // void _changeTab(int index) {
  //   setState(() {
  //     _currentIndex = index;
  //     _currentPage = _pages[index];
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final statisticsBloc = context.watch<StatisticsBloc>();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue, //TODO colour
          title: Text("Statistiken"),
        ),
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        drawer: SidebarView(),
        // if drawer is closed notify, so if game is running the back to game button appears on next opening
        // onDrawerChanged: (isOpened) {
        //   if (!isOpened) {
        //     tempController.setMenuIsEllapsed(false);
        //   }
        // },
        body: _buildStatisticsBody(context),
        bottomNavigationBar: BottomNavigationBar(
            onTap: (index) {
              statisticsBloc.add(ChangeTabs(tabIndex: index));
            },
            currentIndex: statisticsBloc.state.selectedStatScreenIndex,
            items: const [
              BottomNavigationBarItem(
                label: page1,
                icon: Icon(Icons.person_add),
              ),
              BottomNavigationBarItem(
                label: page2,
                icon: Icon(Icons.person),
              ),
              BottomNavigationBarItem(
                label: page3,
                icon: Icon(Icons.person_add_sharp),
              ),
            ]),
      ),
    );
  }
}
Widget _buildStatisticsBody(BuildContext context) {
    final state = context.watch<StatisticsBloc>().state;

    // if (state.selectedStatScreenIndex == 0) {
    //   return TeamStatistics();
    // }
    // if (state.selectedStatScreenIndex == 1) {
    //   return PlayerStatistics();
    // }
    if (state.selectedStatScreenIndex == 2) {
      return ComparisonStatistics();
    } else {
      return const Center(child: Text("This should not happen [Statistics]"));
    }
  }


//   Widget _navigationItemListTitle(String title, int index) {
//     return ListTile(
//       title: Text(
//         '$title Page',
//         style: TextStyle(color: Colors.blue[400], fontSize: 22.0),
//       ),
//       onTap: () {
//         Navigator.pop(context);
//         _changeTab(index);
//       },
//     );
//   }
// }
