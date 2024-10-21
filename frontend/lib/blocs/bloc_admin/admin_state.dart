part of 'admin_bloc.dart';

@immutable
abstract class AdminState {}

class AdminInitialState extends AdminState {}

class AdminLoadingState extends AdminState {}

class AdminCreateEventSuccessState extends AdminState {}

class AdminLoadedSuccessState extends AdminState {
  final List<UserModel> users;
  final List<AnnouncementModel> announcements;
  final int activeCount;
  final int inactiveCount;
  final int hk25;
  final int hk50;
  final int hk75;
  final int completedDtr;
  final int completedSchedulesCount;
  final int todaySchedulesCount;

  AdminLoadedSuccessState({
    required this.users,
    required this.announcements,
    required this.activeCount,
    required this.inactiveCount,
    required this.hk25,
    required this.hk50,
    required this.hk75,
    required this.completedDtr,
    required this.completedSchedulesCount,
    required this.todaySchedulesCount,
  });
}

class AdminListScreenSuccessState extends AdminState {
  final List<UserModel> filteredUsers;

  AdminListScreenSuccessState({required this.filteredUsers});
}

class AdminErrorState extends AdminState {
  final String message;

  AdminErrorState({required this.message});
}
