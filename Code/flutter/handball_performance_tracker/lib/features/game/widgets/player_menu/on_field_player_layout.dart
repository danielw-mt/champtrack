import 'package:flutter/material.dart';
import 'package:handball_performance_tracker/features/game/game.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class OnFieldPlayerLayout extends StatelessWidget {
  const OnFieldPlayerLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final gameBloc = BlocProvider.of<GameBloc>(context);
    return ElevatedButton(onPressed: () {
      gameBloc.add(WorkflowEvent());
    }, child: Text('OnFieldPlayerLayout'));
  }
}