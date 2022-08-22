import 'dart:convert';
import '../widgets/statistic_screen/player_statistics.dart';
import '../widgets/statistic_screen/team_statistics.dart';
import '../widgets/statistic_screen/comp_statistics.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handball_performance_tracker/controllers/tempController.dart';
import 'package:handball_performance_tracker/widgets/nav_drawer.dart';
import 'package:handball_performance_tracker/widgets/statistic_screen/charts.dart';


const String page1 = "Mannschaft";
const String page2 = "Player";
const String page3 = "Vergleich";

class StatisticsScreen extends StatefulWidget {
  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TempController tempController = Get.put(TempController());

  late List<Widget> _pages;
  late Widget _teamStatistics;
  late Widget _playerStatistics;
  late Widget _compStatistics;
  late int _currentIndex;
  late Widget _currentPage;

  @override
  void initState() {
    super.initState();
    _teamStatistics = const TeamStatistics();
    _playerStatistics = const PlayerStatistics();
    _compStatistics = ComparisonStatistics(changePage: _changeTab);
    _pages = [_teamStatistics, _playerStatistics, _compStatistics];
    _currentIndex = 0;
    _currentPage = _teamStatistics;
  }

  void _changeTab(int index) {
    setState(() {
      _currentIndex = index;
      _currentPage = _pages[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Statistics"),
        ),
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        drawer: NavDrawer(),
        // if drawer is closed notify, so if game is running the back to game button appears on next opening
        onDrawerChanged: (isOpened) {
          if (!isOpened) {
            tempController.setMenuIsEllapsed(false);
          }
        },
        body: _currentPage,
        bottomNavigationBar: BottomNavigationBar(
            onTap: (index) {
              _changeTab(index);
            },
            currentIndex: _currentIndex,
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

  Widget _navigationItemListTitle(String title, int index) {
    return ListTile(
      title: Text(
        '$title Page',
        style: TextStyle(color: Colors.blue[400], fontSize: 22.0),
      ),
      onTap: () {
        Navigator.pop(context);
        _changeTab(index);
      },
    );
  }
}


// ######## old code of the statistics screen ########
// ######## PLEASE DONT DELETE THIS CODE FOR NOW ########

// a screen that holds widgets that can be useful for debugging and game control
/*class StatisticsScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TempController tempController = Get.put(TempController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        drawer: NavDrawer(),
        // if drawer is closed notify, so if game is running the back to game button appears on next opening
        onDrawerChanged: (isOpened) {
          if (!isOpened) {
            tempController.setMenuIsEllapsed(false);
          }
        },
        body: Stack(
          children: [
            // Container for menu button on top left corner
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MenuButton(_scaffoldKey),
                  ],
                ),
                Expanded(
                  child: Card(
                      child: AspectRatio(
                          aspectRatio: 0.2 / 0.2, child: LineChartWidget())),
                ),
                Expanded(
                  child: Card(
                      child: AspectRatio(
                          aspectRatio: 0.2 / 0.2, child: LineChartWidget())),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}*/
