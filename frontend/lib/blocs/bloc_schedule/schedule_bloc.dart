import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/api/implementations/student_repository_impl.dart';
import 'package:isHKolarium/blocs/bloc_schedule/schedule_event.dart';
import 'package:isHKolarium/blocs/bloc_schedule/schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final StudentRepositoryImpl apiService;

  ScheduleBloc(this.apiService) : super(ScheduleInitialState()) {
    on<ScheduleInitialEvent>(scheduleInitialEvent);
    on<LoadScheduleEvent>(_onLoadScheduleEvent);
  }

  FutureOr<void> scheduleInitialEvent(
      ScheduleInitialEvent event, Emitter<ScheduleState> emit) async {
    emit(ScheduleLoadingState());
    emit(
      ScheduleLoadedSuccessState(schedule: const []),
    );
  }

  Future<void> _onLoadScheduleEvent(
    LoadScheduleEvent event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(ScheduleLoadingState());
    try {
      final schedule =
          await apiService.getSchedule(selectedMonth: event.selectedMonth);
      emit(ScheduleLoadedSuccessState(schedule: schedule));
    } catch (e) {
      emit(ScheduleErrorState(e.toString()));
    }
  }
}
