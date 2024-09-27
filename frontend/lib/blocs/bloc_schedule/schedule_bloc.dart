import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/api/implementations/student_repository_impl.dart';
import 'package:isHKolarium/blocs/bloc_schedule/schedule_event.dart';
import 'package:isHKolarium/blocs/bloc_schedule/schedule_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.getString('token').toString();
      final schedule = await apiService.getSchedule(
          token: event.token, selectedMonth: event.selectedMonth);
      emit(ScheduleLoadedSuccessState(
          schedule: schedule));
    } catch (e) {
      emit(ScheduleErrorState(e.toString()));
    }
  }
}
