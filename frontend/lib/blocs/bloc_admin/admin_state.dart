part of 'admin_bloc.dart';

@immutable
abstract class AdminState {}

class AdminInitial extends AdminState {}

class AdminLoadingState extends AdminState {}

class AdminLoadedState extends AdminState {
  final List<UserModel> users;
  final int activeCount;
  final int inactiveCount;

  AdminLoadedState({
    required this.users,
    required this.activeCount,
    required this.inactiveCount,
  });
}

class AdminErrorState extends AdminState {
  final String message;

  AdminErrorState({required this.message});
}
