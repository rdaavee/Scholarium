part of 'students_bloc.dart';

@immutable
abstract class StudentsState {}

abstract class StudentsActionState extends StudentsState {}

final class StudentsInitial extends StudentsState {}

class StudentsLoadingState extends StudentsState {}

class StudentLoadedSuccessState extends StudentsState {}

class StudentsErrorState extends StudentsState {}
