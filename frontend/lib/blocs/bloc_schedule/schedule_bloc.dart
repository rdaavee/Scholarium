import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/api/implementations/professor_repository_impl.dart';
import 'package:isHKolarium/api/implementations/student_repository_impl.dart';
import 'package:isHKolarium/blocs/bloc_schedule/schedule_event.dart';
import 'package:isHKolarium/blocs/bloc_schedule/schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final StudentRepositoryImpl studentService;
  final ProfessorRepositoryImpl profService;

  ScheduleBloc(this.studentService, this.profService)
      : super(ScheduleInitialState()) {
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
      switch (event.role) {
        case "Student":
          final schedule = await studentService.getSchedule(
              selectedMonth: event.selectedMonth);
          emit(ScheduleLoadedSuccessState(schedule: schedule));
          break;
        case "Professor":
          final schedule =
              await profService.getSchedule(selectedMonth: event.selectedMonth);
          emit(ScheduleLoadedSuccessState(schedule: schedule));
      }
    } catch (e) {
      emit(ScheduleErrorState(e.toString()));
    }
  }
}
