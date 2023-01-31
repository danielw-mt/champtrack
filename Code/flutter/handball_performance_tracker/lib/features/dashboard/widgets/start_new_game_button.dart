import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/core/core.dart';
import 'package:handball_performance_tracker/features/game_setup/game_setup.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StartNewGameButton extends StatelessWidget {
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width * 0.4,
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
                    child: GameSetupPage(),
                  );
                },
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.sports_handball,
                color: Colors.black,
                size: 50,
              ),
              Text("   "),
              Text(
                StringsDashboard.lTrackNewGame,
                style: TextStyle(color: Colors.black, fontSize: 30),
              )
            ],
          )),
    );
  }
}
