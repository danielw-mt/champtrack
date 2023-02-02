import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/features/sidebar/view/sidebar_view.dart';
import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/features/statistics/statistics.dart';

// TODO move these to the constant strings
const String page1 = "Team";
const String page2 = "Player";
const String page3 = "Vergleich";

class StatisticsView extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final statisticsBloc = context.watch<StatisticsBloc>();
    print("statistics view: ${statisticsBloc.state.status}");
    if (statisticsBloc.state.status == StatisticsStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue, //TODO colour
          title: Text("Statistiken"),
        ),
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        drawer: SidebarView(),
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
              // BottomNavigationBarItem(
              //   label: page3,
              //   icon: Icon(Icons.person_add_sharp),
              // ),
            ]),
      ),
    );
  }
}

Widget _buildStatisticsBody(BuildContext context) {
  final state = context.watch<StatisticsBloc>().state;
  if (state.status != StatisticsStatus.loaded) {
    return const Center(child: CircularProgressIndicator());
  }
  if (state.selectedStatScreenIndex == 0) {
    return TeamStatistics();
  }
  if (state.selectedStatScreenIndex == 1) {
    return PlayerStatistics();
  }
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
