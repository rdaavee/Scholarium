import 'package:isHKolarium/api/models/user_model.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileLoadedSuccessState extends ProfileState {
  final List<UserModel> users;

  ProfileLoadedSuccessState({required this.users});
}

class ProfileErrorState extends ProfileState {
  final String message;

  ProfileErrorState({required this.message});
}

class LogoutInitialState extends ProfileState {}

class LogoutLoadingState extends ProfileState {}

class LogoutLoadedSuccessState extends ProfileState {}

class LogoutErrorState extends ProfileState {
  final String message;
  LogoutErrorState({required this.message});
}
