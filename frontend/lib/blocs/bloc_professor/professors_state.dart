part of 'professors_bloc.dart';

@immutable
abstract class ProfessorsState {}

final class ProfessorsInitialState extends ProfessorsState {}

final class ProfessorsLoadingState extends ProfessorsState {}

final class ProfessorsLoadedSuccessState extends ProfessorsState {}

final class ProfessorsErrorState extends ProfessorsState {
  final String message;

  ProfessorsErrorState({required this.message});
}

final class PostInitial extends ProfessorsState {}

final class PostLoading extends ProfessorsState {}

final class PostCreated extends ProfessorsState {}

final class PostErrorState extends ProfessorsState {}
