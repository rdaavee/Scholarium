part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent {}

class LoginInitialEvent extends AuthenticationEvent {}
class PasswordInitialEvent extends AuthenticationEvent {}

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

class GetOTPEvent extends AuthenticationEvent {
  final String email;
  GetOTPEvent(this.email);
}
class ResetPasswordEvent extends AuthenticationEvent {
  final String email;
  final String code;
  final String newPassword;
  ResetPasswordEvent(this.email, this.code, this.newPassword);
}

class LoginButtonNavigateEvent extends AuthenticationEvent {}
