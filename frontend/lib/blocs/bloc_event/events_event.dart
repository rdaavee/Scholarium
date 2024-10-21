part of 'events_bloc.dart';

@immutable
abstract class EventsEvent extends Equatable{}

class FetchEvents extends EventsEvent{
  

  @override
  List<Object?> get props => throw UnimplementedError();
}
