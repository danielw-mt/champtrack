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
  AuthBloc({required this.authRepository})
      : super(AuthState(authStatus: AuthStatus.UnAuthenticated)) {
    on<StartApp>((event, emit) async {
      print("StartApp event received");
      try {
        emit(state.copyWith(authStatus: AuthStatus.UnAuthenticated));
        final user = await authRepository.getUser();
        if (user != null) {
          Club club = await authRepository.fetchLoggedInClub();
          emit(
              state.copyWith(authStatus: AuthStatus.Authenticated, club: club));
        } else {
          emit(state.copyWith(authStatus: AuthStatus.UnAuthenticated));
        }
      } catch (e) {
        print("Error in StartApp event: $e");
        emit(state.copyWith(
            authStatus: AuthStatus.AuthError, error: e.toString()));
      }
    });

    /// When User Presses the SignIn Button, we will send the SignInRequested Event to the AuthBloc to handle it and emit the Authenticated State if the user is authenticated
    on<SignInRequested>((event, emit) async {
      emit(state.copyWith(authStatus: AuthStatus.Loading));
      try {
        await authRepository.signIn(
            email: event.email, password: event.password);
        Club club = await authRepository.fetchLoggedInClub();
        emit(state.copyWith(authStatus: AuthStatus.Authenticated, club: club));
      } catch (e) {
        print("Error in SignInRequested event: $e");
        emit(state.copyWith(
            authStatus: AuthStatus.AuthError, error: e.toString()));
      }
    });

    /// When User Presses the SignUp Button, we will send the SignUpRequest Event to the AuthBloc to handle it and emit the Authenticated State if the user is authenticated
    on<SignUpRequested>((event, emit) async {
      emit(state.copyWith(authStatus: AuthStatus.Loading));
      try {
        await authRepository.signUp(
            clubName: event.clubName,
            email: event.email,
            password: event.password);
        Club club = await authRepository.fetchLoggedInClub();
        emit(state.copyWith(authStatus: AuthStatus.Authenticated, club: club));
      } catch (e) {
        print("Error in SignUpRequested event: $e");
        emit(state.copyWith(
            authStatus: AuthStatus.AuthError, error: e.toString()));
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
      emit(state.copyWith(authStatus: AuthStatus.Loading));
      await authRepository.signOut();
      emit(state.copyWith(authStatus: AuthStatus.UnAuthenticated, club: null));
    });

    // when error dialog is displayed this event is called
    on<DisplayError>((event, emit) async {
      emit(state.copyWith(authStatus: AuthStatus.UnAuthenticated));
    });

    
  }

  /// Returns a documentreference of the logged in club so that it can be used in later queries within that club
  DocumentReference getClubReference() {
    if (state.club != null) {
      return FirebaseFirestore.instance.collection("clubs").doc(state.club!.id);
    } else {
      throw Exception("User is not authenticated");
    }
  }

  // TODO implement reset password
  //   void sendPasswordResetEmail() async {
//     // show an indication that user is signing up
//     Alert loadingAlert = Alert(
//         context: context,
//         buttons: [],
//         content: CustomAlertWidget(StringsAuth.lLoggingIn));
//     loadingAlert.show();
//     try {
//       await FirebaseAuth.instance
//           .sendPasswordResetEmail(email: emailController.text.trim());
//       loadingAlert.dismiss();
//     } on FirebaseAuthException catch (e) {
//       loadingAlert.dismiss();
//       Alert(
//               context: context,
//               buttons: [],
//               content: Text(e.message.toString(),
//                   style: TextStyle(color: Colors.grey.shade800)),
//               style: AlertStyle(backgroundColor: buttonLightBlueColor))
//           .show();
//     }
//     onClickedReset();
//   }
// }

}
