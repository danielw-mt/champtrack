import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/features/dashboard/dashboard.dart';
import 'package:handball_performance_tracker/data/repositories/repositories.dart';
import 'package:handball_performance_tracker/features/authentication/authentication.dart';
import 'package:handball_performance_tracker/core/core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:ui';

import 'package:handball_performance_tracker/features/statistics/bloc/statistics_bloc.dart';

class HandballApp extends StatelessWidget {
  const HandballApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(create: (context) => AuthRepository()),
        RepositoryProvider<ClubRepository>(create: (context) => ClubFirebaseRepository()),
        RepositoryProvider<GameFirebaseRepository>(create: (context) => GameFirebaseRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(create: (context) => AuthBloc(authRepository: RepositoryProvider.of<AuthRepository>(context))..add(StartApp())),
          BlocProvider<GlobalBloc>(create: (context) => GlobalBloc(gameRepository: RepositoryProvider.of<GameFirebaseRepository>(context))..add(LoadGlobalState())),
          BlocProvider<StatisticsBloc>(create: (context) => StatisticsBloc(gameRepository: RepositoryProvider.of<GameFirebaseRepository>(context))..add(InitStatistics())),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          scrollBehavior: AppScrollBehavior(),
          home: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                // If the snapshot has user data, then they're already signed in. So Navigating to the Dashboard.
                if (snapshot.hasData) {
                  return const DashboardView();
                }
                // Otherwise, they're not signed in. Show the sign in page.
                return SignIn();
              }),
        ),
      ),
    );
  }
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}
