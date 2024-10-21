import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:isHKolarium/api/implementations/global_repository_impl.dart';
import 'package:isHKolarium/api/models/event_model.dart';
import 'package:meta/meta.dart';

part 'events_event.dart';
part 'events_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final GlobalRepositoryImpl _globalService;
  EventsBloc(this._globalService) : super(EventsInitial()) {
    on<EventsEvent>((event, emit) {});
    on<FetchEvents>((event, emit) async {
      emit(EventsLoadingState());
      try {
        final List<EventModel> eventsList = await _globalService.fetchEvents();
        emit(EventsLoadedState(events: eventsList));
      } catch (error) {
        emit(EventsErrorState(error.toString()));
      }
    });
  }
}
