part of 'events_bloc.dart';

abstract class EventsState {}

class EventsInitial extends EventsState {}

class EventsErrorState extends EventsState {
  EventsErrorState(String string);
}

class EventsLoadingState extends EventsState {}

class EventsLoadedState extends EventsState {
  final List<EventModel> events;

  EventsLoadedState({required this.events});
}
