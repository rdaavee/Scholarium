import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/api/implementations/professor_repository_impl.dart';
import 'package:isHKolarium/api/implementations/student_repository_impl.dart';
import 'package:isHKolarium/blocs/bloc_schedule/schedule_event.dart';
import 'package:isHKolarium/blocs/bloc_schedule/schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final StudentRepositoryImpl studentRepository;
  final ProfessorRepositoryImpl professorRepository;

  ScheduleBloc(this.studentRepository, this.professorRepository)
      : super(ScheduleLoadingState()) {
    on<FetchScheduleEvent>(fetchScheduleEvent);
    on<UpdateDutySchedule>(updateDutySchedule);
    on<CreateDTREvent>(createDTREvent);
  }

  Future<void> fetchScheduleEvent(
    FetchScheduleEvent event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(ScheduleLoadingState());
    try {
      switch (event.role) {
        case "Student":
          final schedule = await studentRepository.getSchedule(
              selectedMonth: event.selectedMonth);
          emit(ScheduleLoadedSuccessState(schedule: schedule));
          break;
        case "Professor":
          final schedule = await professorRepository.getSchedule(
              selectedMonth: event.selectedMonth);
          emit(ScheduleLoadedSuccessState(schedule: schedule));
      }
    } catch (e) {
      emit(ScheduleErrorState(e.toString()));
    }
  }

  FutureOr<void> updateDutySchedule(
      UpdateDutySchedule event, Emitter<ScheduleState> emit) async {
    emit(ScheduleLoadingState());
    try {
      await professorRepository.updateStudentSchedule(event.id);
      add(FetchScheduleEvent(selectedMonth: event.selectedMonth, role: event.role));
    } catch (e) {
      emit(ScheduleErrorState(e.toString()));
    }
  }

  FutureOr<void> createDTREvent(
      CreateDTREvent event, Emitter<ScheduleState> emit) async {
    emit(ScheduleLoadingState());
    try {
      await professorRepository.createDTR(event.dtr);
      add(FetchScheduleEvent(selectedMonth: event.selectedMonth, role: event.role));
    } catch (e) {
      emit(ScheduleErrorState(e.toString()));
    }
  }
}
