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
    on<LoadUpcomingScheduleEvent>(_onLoadUpcomingSchedule);
    on<LoadScheduleEvent>(_onLoadScheduleEvent);
  }

  FutureOr<void> scheduleInitialEvent(
      ScheduleInitialEvent event, Emitter<ScheduleState> emit) async {
    emit(ScheduleLoadingState());
    emit(
      ScheduleLoadedSuccessState(schedule: const []),
    );
  }

  FutureOr<void> _onLoadUpcomingSchedule(
      LoadUpcomingScheduleEvent event, Emitter<ScheduleState> emit) async {
    emit(ScheduleLoadingState());
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token').toString();
      final scheduleData = await apiService.fetchUpcomingSchedule(token: token);
      final schedule = await apiService.getSchedule(token: event.token);
      emit(ScheduleLoadedSuccessState(
          // todaySchedule: scheduleData['today'],
          // nextSchedule: [scheduleData['next']],
          schedule: schedule));
    } catch (e) {
      emit(ScheduleErrorState('Failed to load schedule'));
    }
  }

  Future<void> _onLoadScheduleEvent(
    LoadScheduleEvent event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(ScheduleLoadingState());
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token').toString();
      final scheduleData = await apiService.fetchUpcomingSchedule(token: token);
      final schedule = await apiService.getSchedule(token: event.token);
      emit(ScheduleLoadedSuccessState(
          // todaySchedule: scheduleData['today'],
          // nextSchedule: [scheduleData['next']],
          schedule: schedule));
    } catch (e) {
      emit(ScheduleErrorState(e.toString()));
    }
  }
}
