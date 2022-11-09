import 'package:bloc/bloc.dart';
import 'package:handball_performance_tracker/data/repositories/repositories.dart';
import 'package:handball_performance_tracker/data/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  AuthBloc({required this.authRepository}) : super(UnAuthenticated()) {
    
    /// When User Presses the SignIn Button, we will send the SignInRequested Event to the AuthBloc to handle it and emit the Authenticated State if the user is authenticated
    on<SignInRequested>((event, emit) async {
      emit(Loading());
      try {
        await authRepository.signIn(
            email: event.email, password: event.password);
        Club club = await authRepository.fetchLoggedInClub();
        emit(Authenticated(club: club));
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    });

    /// When User Presses the SignUp Button, we will send the SignUpRequest Event to the AuthBloc to handle it and emit the Authenticated State if the user is authenticated
    on<SignUpRequested>((event, emit) async {
      emit(Loading());
      try {
        await authRepository.signUp(clubName: event.clubName,
            email: event.email, password: event.password);
        Club club = await authRepository.fetchLoggedInClub();
        emit(Authenticated(club: club));
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    });
    // When User Presses the Google Login Button, we will send the GoogleSignInRequest Event to the AuthBloc to handle it and emit the Authenticated State if the user is authenticated
    // on<GoogleSignInRequested>((event, emit) async {
    //   emit(Loading());
    //   try {
    //     await authRepository.signInWithGoogle();
    //     emit(Authenticated());
    //   } catch (e) {
    //     emit(AuthError(e.toString()));
    //     emit(UnAuthenticated());
    //   }
    // });

    /// When User Presses the SignOut Button, we will send the SignOutRequested Event to the AuthBloc to handle it and emit the UnAuthenticated State
    on<SignOutRequested>((event, emit) async {
      emit(Loading());
      await authRepository.signOut();
      emit(UnAuthenticated());
    });
  }

  /// Returns a documentreference of the logged in club so that it can be used in later queries within that club
  DocumentReference getClubReference() {
    if (this.state is Authenticated){
      return FirebaseFirestore.instance.collection("clubs").doc((this.state as Authenticated).club.id);
    } else {
      throw Exception("User is not authenticated");
    }
  }
}