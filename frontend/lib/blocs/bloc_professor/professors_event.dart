part of 'professors_bloc.dart';

abstract class ProfessorsEvent {}

final class ProfessorsInitialEvent extends ProfessorsEvent {}

class FetchLatestEvent extends ProfessorsEvent {}
class ProfessorsCreatePostEvent extends ProfessorsEvent {
  final String title;
  final String message;

  ProfessorsCreatePostEvent({required this.title, required this.message});
}
