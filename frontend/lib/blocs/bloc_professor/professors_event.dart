part of 'professors_bloc.dart';

@immutable
abstract class ProfessorsEvent {}

final class ProfessorsInitialEvent extends ProfessorsEvent {}
class FetchLatestEvent extends ProfessorsEvent {}
class ProfessorsCreatePostEvent extends ProfessorsEvent {
  final String title;
  final String body;

  ProfessorsCreatePostEvent({required this.title, required this.body});
}
