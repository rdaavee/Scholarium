part of 'professors_bloc.dart';

@immutable
abstract class ProfessorsState {}

final class ProfessorsInitialState extends ProfessorsState {}

final class ProfessorsLoadingState extends ProfessorsState {}

final class ProfessorsLoadedSuccessState extends ProfessorsState {}

final class ProfessorsErrorState extends ProfessorsState {
  final String message;

  ProfessorsErrorState({ required this.message});
}
