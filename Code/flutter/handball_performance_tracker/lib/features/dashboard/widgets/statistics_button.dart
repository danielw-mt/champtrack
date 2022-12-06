import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/core/constants/field_size_parameters.dart';
import 'package:handball_performance_tracker/core/core.dart';
import 'package:handball_performance_tracker/features/statistics/view/statistics_page.dart';
import 'package:handball_performance_tracker/old-screens/start_game_screen.dart';
import 'package:handball_performance_tracker/old-screens/team_selection_screen.dart';
import 'package:handball_performance_tracker/core/constants/strings_dashboard.dart';
import 'package:handball_performance_tracker/core/constants/strings_general.dart';
import 'package:handball_performance_tracker/old-screens/statistics_screen.dart';
import 'package:handball_performance_tracker/core/core.dart';

class StatisticsButton extends StatelessWidget {
  const StatisticsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width * 0.85,
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: BoxDecoration(
          color: Colors.white,
          // set border so corners can be made round
          border: Border.all(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: TextButton(
          onPressed: () {
            // TODO implement check for old game existing
            Navigator.push(
              context,
              MaterialPageRoute<GlobalBloc>(
                builder: (context) {
                  GlobalBloc globalBloc = BlocProvider.of<GlobalBloc>(context);
                  return BlocProvider.value(
                    value: globalBloc,
                    child: StatisticsPage(),
                  );
                },
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.bar_chart,
                color: Colors.black,
                size: 50,
              ),
              Text(
                StringsGeneral.lStatistics,
                style: TextStyle(color: Colors.black, fontSize: 30),
              )
            ],
          )),
    );
  }
}

class SquareDashboardButton extends StatelessWidget {
  bool startButton = false;
  SquareDashboardButton({Key? key, required this.startButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width * 0.4,
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: BoxDecoration(
          color: Colors.white,
          // set border so corners can be made round
          border: Border.all(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: TextButton(
          onPressed: () {
            // startButton
                // ? Get.to(() => StartGameScreen())
                // : Get.to(() => TeamSelectionScreen());
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                startButton ? Icons.add : Icons.edit,
                color: Colors.black,
                size: 50,
              ),
              Text("   "),
              Text(
                startButton
                    ? StringsDashboard.lTrackNewGame
                    : StringsDashboard.lManageTeams,
                style: TextStyle(color: Colors.black, fontSize: 30),
              )
            ],
          )),
    );
  }
}
