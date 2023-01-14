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
        RepositoryProvider<AuthRepository>(
            create: (context) => AuthRepository()),
        RepositoryProvider<ClubRepository>(
            create: (context) => ClubFirebaseRepository()),
        RepositoryProvider<GameFirebaseRepository>(
            create: (context) => GameFirebaseRepository()),
        RepositoryProvider<TeamFirebaseRepository>(
            create: (context) => TeamFirebaseRepository()),
        RepositoryProvider<PlayerFirebaseRepository>(
            create: (context) => PlayerFirebaseRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
              create: (context) => AuthBloc(
                  authRepository:
                      RepositoryProvider.of<AuthRepository>(context))
                ..add(StartApp())),
          BlocProvider<GlobalBloc>(
              create: (context) => GlobalBloc(
                  gameRepository:
                      RepositoryProvider.of<GameFirebaseRepository>(context),
                  playerRepository:
                      RepositoryProvider.of<PlayerFirebaseRepository>(context),
                  teamRepository:
                      RepositoryProvider.of<TeamFirebaseRepository>(context))
                ..add(LoadGlobalState())),
          BlocProvider<StatisticsBloc>(
              create: (context) => StatisticsBloc(
                  gameRepository:
                      RepositoryProvider.of<GameFirebaseRepository>(context),
                  playerRepository:
                      RepositoryProvider.of<PlayerFirebaseRepository>(context),
                  teamRepository:
                      RepositoryProvider.of<TeamFirebaseRepository>(context))
                ..add(InitStatistics())),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          scrollBehavior: AppScrollBehavior(),
          home: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                final AuthBloc authBloc = context.watch<AuthBloc>();
                // If the snapshot has user data, then they're already signed in. So Navigating to the Dashboard.
                if (authBloc.state.authStatus == AuthStatus.Authenticated) {
                  return DashboardView();
                } else if (authBloc.state.authStatus == AuthStatus.Loading) {
                  print("loading");
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (authBloc.state.authStatus == AuthStatus.UnAuthenticated) {
                  print("UnAuthenticated");
                  // Otherwise, they're not signed in. Show the sign in page.
                  return SignIn();
                } else if (authBloc.state.authStatus == AuthStatus.AuthError) {
                  print("Authentication Error");
                  return SignIn();
                } else {
                  return Text("Something went wrong");
                }
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
