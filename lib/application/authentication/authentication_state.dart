part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitialState extends AuthenticationState {}

class AuthenticationLoadingState extends AuthenticationState {}

class AuthenticationAppStartedState extends AuthenticationState {}

class AuthenticationAppStartErrorState extends AuthenticationState {
  final String error;

  const AuthenticationAppStartErrorState({required this.error});

  @override
  List<Object> get props => [error];
}

class AuthenticationSignInLoadingState extends AuthenticationState {}

class AuthenticationSignedInState extends AuthenticationState {}

class AuthenticationSignInErrorState extends AuthenticationState {
  final String error;

  const AuthenticationSignInErrorState({required this.error});

  @override
  List<Object> get props => [error];
}
