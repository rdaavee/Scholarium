part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

abstract class LoginActionState extends LoginState {}

final class LoginInitial extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginLoadedSuccessState extends LoginState {}

class LoginErrorState extends LoginState {}

class LoginNavigateToStudentHomePageActionState extends LoginActionState {}

class LoginNavigateToProfessorHomePageActionState extends LoginActionState {}
