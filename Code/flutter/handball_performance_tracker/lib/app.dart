import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handball_performance_tracker/dashboard/dashboard.dart';
import 'package:handball_performance_tracker/data/repositories/repositories.dart';
import 'package:handball_performance_tracker/authentication/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HandballApp extends StatelessWidget {
  const HandballApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(create: (context) => AuthRepository()),
        RepositoryProvider<ClubRepository>(create: (context) => ClubFirebaseRepository()),
      ],
      child: BlocProvider(
        create: (context) => AuthBloc(authRepository: RepositoryProvider.of<AuthRepository>(context)),
        child: MaterialApp(
          home: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                // If the snapshot has user data, then they're already signed in. So Navigating to the Dashboard.
                if (snapshot.hasData) {
                  return const DashboardPage();
                }
                // Otherwise, they're not signed in. Show the sign in page.
                return SignIn();
              }),
        ),
      ),
    );
  }
}
