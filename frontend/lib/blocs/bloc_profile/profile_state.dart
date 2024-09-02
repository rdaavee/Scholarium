abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileLoadedSuccessState extends ProfileState {
  final String name;
  final String email;
  final String studentId;
  final String gender;
  final String contact;
  final String address;
  final String hkType;
  final String status;
  final String profilePicture;

  ProfileLoadedSuccessState({
    required this.name,
    required this.email,
    required this.studentId,
    required this.gender,
    required this.contact,
    required this.address,
    required this.hkType,
    required this.status,
    required this.profilePicture,
  });
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
