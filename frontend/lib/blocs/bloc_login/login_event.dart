part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class LoginInitialEvent extends LoginEvent {}

class LoginButtonClickedEvent extends LoginEvent {
  final String schoolID;
  final String password;

  LoginButtonClickedEvent(this.schoolID, this.password);
}

class LoginButtonNavigateEvent extends LoginEvent {}
