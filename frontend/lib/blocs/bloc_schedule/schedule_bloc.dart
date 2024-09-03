import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/api/api_service/api_service.dart';
import 'package:isHKolarium/blocs/bloc_schedule/schedule_event.dart';
import 'package:isHKolarium/blocs/bloc_schedule/schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final ApiService apiService;

  ScheduleBloc(this.apiService) : super(ScheduleInitialState()) {
    on<LoadScheduleEvent>(_onLoadScheduleEvent);
  }

  Future<void> _onLoadScheduleEvent(
    LoadScheduleEvent event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(ScheduleLoadingState());
    try {
      final schedule = await apiService.getSchedule(token: event.token);
      emit(ScheduleLoadedSuccess(schedule));
    } catch (e) {
      emit(ScheduleErrorState(e.toString()));
    }
  }
}
