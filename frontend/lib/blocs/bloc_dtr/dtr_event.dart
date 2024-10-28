part of 'dtr_bloc.dart';

@immutable
abstract class DtrEvent {}

class FetchDtrEvent extends DtrEvent {
  final String schoolId;

  FetchDtrEvent({required this.schoolId});
}
