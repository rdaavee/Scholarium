part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent {}

class LoginInitialEvent extends AuthenticationEvent {}

class LoginButtonClickedEvent extends AuthenticationEvent {
  final String schoolID;
  final String password;

  LoginButtonClickedEvent(this.schoolID, this.password);
}

class LoginAutomaticEvent extends AuthenticationEvent {
  final String schoolID;
  final String password;

  LoginAutomaticEvent(this.schoolID, this.password);
}

class LoginButtonNavigateEvent extends AuthenticationEvent {}
