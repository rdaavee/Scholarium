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

final class PasswordInitial extends AuthenticationState {}
class PasswordLoadingState extends AuthenticationState {}
class PasswordLoadedSuccessState extends AuthenticationState {}
class PasswordErrorState extends AuthenticationState {
  final String message;

  PasswordErrorState({required this.message});
}
class LoginNavigateToStudentHomePageActionState extends AuthenticationActionState {}
class LoginNavigateToProfessorHomePageActionState extends AuthenticationActionState {}
class LoginNavigateToAdminHomePageActionState extends AuthenticationActionState {}
class EmailNavigateToOTPPageActionState extends AuthenticationActionState {}
class OTPNavigateToResetPageActionState extends AuthenticationActionState {}
class ResetPasswordNavigateToLoginPageActionState extends AuthenticationActionState {}
