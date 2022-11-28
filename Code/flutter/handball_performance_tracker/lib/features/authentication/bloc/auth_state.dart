part of 'auth_bloc.dart';

enum AuthStatus { UnAuthenticated, Authenticated, Loading, AuthError }

@immutable
class AuthState extends Equatable {
  final AuthStatus authStatus;
  final String? error;
  final Club? club;
  AuthState({required this.authStatus, this.error, this.club});

  AuthState copyWith({AuthStatus? authStatus, String? error, Club? club}) {
    return AuthState(authStatus: authStatus ?? this.authStatus, error: error ?? this.error, club: club ?? this.club);
  }

  @override
  List<Object> get props => [authStatus, error ?? '', club ?? ''];
}
