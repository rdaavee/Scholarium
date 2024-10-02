part of 'admin_bloc.dart';

@immutable
abstract class AdminState {}

class AdminInitialState extends AdminState {}

class AdminLoadingState extends AdminState {}

class AdminLoadedSuccessState extends AdminState {
  final List<UserModel> users;
  final int activeCount;
  final int inactiveCount;
  final int completedSchedulesCount;
  final int todaySchedulesCount;

  AdminLoadedSuccessState({
    required this.users,
    required this.activeCount,
    required this.inactiveCount,
    required this.completedSchedulesCount,
    required this.todaySchedulesCount,
  });
}

class AdminErrorState extends AdminState {
  final String message;

  AdminErrorState({required this.message});
}
