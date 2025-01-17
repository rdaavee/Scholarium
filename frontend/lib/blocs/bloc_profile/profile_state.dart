import 'package:isHKolarium/api/models/dtr_total_hours_model.dart';
import 'package:isHKolarium/api/models/user_model.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileLoadedSuccessState extends ProfileState {
  final List<UserModel> users;
  final List<DtrHoursModel> hours;

  ProfileLoadedSuccessState({required this.users, required this.hours});
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

class ProfileUploadingState extends ProfileState {
  final String imageUrl;

  ProfileUploadingState({required this.imageUrl});
}

class ProfileUploadSuccess extends ProfileState {}

class ProfileUploadFailure extends ProfileState {
  final String error;

  ProfileUploadFailure(this.error);
}
