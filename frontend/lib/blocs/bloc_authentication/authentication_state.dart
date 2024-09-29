part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState {}

abstract class AuthenticationActionState extends AuthenticationState {}

final class LoginInitial extends AuthenticationState {}

class LoginLoadingState extends AuthenticationState {}

class LoginLoadedSuccessState extends AuthenticationState {}

class LoginErrorState extends AuthenticationState {
  final String errorMessage;

  LoginErrorState({required this.errorMessage});
}

class LoginNavigateToStudentHomePageActionState extends AuthenticationActionState {}

class LoginNavigateToProfessorHomePageActionState extends AuthenticationActionState {}

class LoginNavigateToAdminHomePageActionState extends AuthenticationActionState {}
