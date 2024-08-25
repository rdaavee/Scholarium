part of 'students_bloc.dart';

@immutable
abstract class StudentsState {}

abstract class StudentsActionState extends StudentsState {}

class StudentsInitial extends StudentsState {}

class StudentsLoadingState extends StudentsState {}

class StudentsLoadedSuccessState extends StudentsState {
  final List<AnnouncementModel> announcements;
  StudentsLoadedSuccessState({required this.announcements});
}

class StudentsErrorState extends StudentsState {
  final String message;

  StudentsErrorState({required this.message});
}

class StudentHomeAnnouncementActionState extends StudentsActionState {}
