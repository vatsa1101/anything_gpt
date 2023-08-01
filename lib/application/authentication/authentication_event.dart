part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Event {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationAppStartEvent extends AuthenticationEvent {}

class AuthenticationSignInEvent extends AuthenticationEvent {}

class AuthenticationLogoutEvent extends AuthenticationEvent {}
