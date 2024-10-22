part of 'students_bloc.dart';

@immutable
abstract class StudentsState {}

abstract class StudentsActionState extends StudentsState {}

class StudentsInitial extends StudentsState {}

class StudentsLoadingState extends StudentsState {}

class StudentsLoadedSuccessState extends StudentsState {
  final List<UserModel> users;
  final List<ScheduleModel> todaySchedule;
  final List<ScheduleModel> nextSchedule;
  final List<AnnouncementModel> announcements;
  final List<DtrHoursModel> hours;
  StudentsLoadedSuccessState(
      {required this.users,
      required this.todaySchedule,
      required this.nextSchedule,
      required this.announcements,
      required this.hours});
}

class StudentsErrorState extends StudentsState {
  final String message;

  StudentsErrorState({required this.message});
}

class StudentHomeAnnouncementActionState extends StudentsActionState {}
