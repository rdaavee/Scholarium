part of 'professors_bloc.dart';
abstract class ProfessorsState {}

final class ProfessorsInitialState extends ProfessorsState {}

final class ProfessorsLoadingState extends ProfessorsState {}

final class ProfessorsLoadedSuccessState extends ProfessorsState {
  final List<UserModel> users;
  final List<ProfessorScheduleModel> schedules;
  final List<AnnouncementModel> announcements;
  ProfessorsLoadedSuccessState(
      {required this.users,
      required this.announcements,
      required this.schedules});
}

final class ProfessorsErrorState extends ProfessorsState {
  final String message;

  ProfessorsErrorState({required this.message});
}

final class PostInitial extends ProfessorsState {}

final class PostLoading extends ProfessorsState {}

final class PostCreated extends ProfessorsState {}

final class PostErrorState extends ProfessorsState {}
