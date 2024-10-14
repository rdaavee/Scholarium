part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent {}

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

class VerifyCode extends AuthenticationEvent {
  final String email;
  final String code;
  VerifyCode(this.email, this.code);
}

class ResetPasswordEvent extends AuthenticationEvent {
  final String email;
  final String newPassword;
  ResetPasswordEvent(this.email, this.newPassword);
}
class LoginButtonNavigateEvent extends AuthenticationEvent {}
