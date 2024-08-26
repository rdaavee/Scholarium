abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String name;
  final String email;
  final String studentId;
  final String hkType;
  final String status;

  ProfileLoaded({
    required this.name,
    required this.email,
    required this.studentId,
    required this.hkType,
    required this.status,
  });
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError({required this.message});
}

class LogoutInitial extends ProfileState {}

class LogoutInProgress extends ProfileState {}

class LogoutSuccess extends ProfileState {}

class LogoutError extends ProfileState {
  final String message;
  LogoutError({required this.message});
}
