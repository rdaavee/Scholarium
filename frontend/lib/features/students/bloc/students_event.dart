part of 'students_bloc.dart';

@immutable
abstract class StudentsEvent {}

class StudentsInitialEvent extends StudentsEvent {}
class FetchAnnouncementEvent extends StudentsEvent {}
class FetchLatestAnnouncementEvent extends StudentsEvent {}
